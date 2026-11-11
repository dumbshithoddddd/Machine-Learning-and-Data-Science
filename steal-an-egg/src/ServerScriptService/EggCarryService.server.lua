--!strict
-- EggCarryService: steal prompts on NestEgg, carry weld, delivery detection,
-- drop handling and nest respawn. Does not touch WalkSpeed or fire noise.

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local EggConfig = require(ReplicatedStorage:WaitForChild("EggConfig"))
local ServerBus = require(ServerScriptService:WaitForChild("ServerBus"))

local NEST_TAG = "NestEgg"
local ZONE_TAG = "DeliveryZone"

type NestState = {
	instance: Instance,
	eggType: string,
	prompt: ProximityPrompt,
	available: boolean,
	token: number, -- invalidates stale respawn timers
	original: { [BasePart]: { Transparency: number, CanCollide: boolean } },
}

type Carry = { eggType: string, nest: NestState?, clone: Instance }

local nests: { [Instance]: NestState } = {}
local zones: { [BasePart]: boolean } = {}
local carrying: { [Player]: Carry } = {}
local lastSteal: { [Player]: number } = {}
local charConns: { [Player]: { RBXScriptConnection } } = {}

-- Allocated once; filter list is refreshed only when characters change.
local overlapParams = OverlapParams.new()
overlapParams.FilterType = Enum.RaycastFilterType.Include
overlapParams.MaxParts = 200
local characterSet: { [Model]: boolean } = {}
local filterDirty = true

local function markFilterDirty()
	filterDirty = true
end

local function refreshFilter()
	local list: { Instance } = {}
	for character in characterSet do
		table.insert(list, character)
	end
	overlapParams.FilterDescendantsInstances = list
	filterDirty = false
end

local function pivotPosition(inst: Instance): Vector3?
	if inst:IsA("Model") then
		return inst:GetPivot().Position
	elseif inst:IsA("BasePart") then
		return inst.Position
	end
	return nil
end

local function primaryOf(inst: Instance): BasePart?
	if inst:IsA("BasePart") then
		return inst
	elseif inst:IsA("Model") then
		return inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart", true)
	end
	return nil
end

local function setNestVisible(nest: NestState, visible: boolean)
	for part, orig in nest.original do
		if part.Parent then
			part.Transparency = if visible then orig.Transparency else 1
			part.CanCollide = if visible then orig.CanCollide else false
		end
	end
	nest.prompt.Enabled = visible
	nest.available = visible
end

local function returnNest(nest: NestState)
	nest.token += 1
	if nest.instance.Parent then
		setNestVisible(nest, true)
	end
end

local function scheduleRespawn(nest: NestState)
	nest.token += 1
	local token = nest.token
	task.delay(EggConfig.NestRespawnDelay, function()
		if nest.token == token and nests[nest.instance] == nest then
			returnNest(nest)
		end
	end)
end

local function buildCarriedCopy(source: Instance, root: BasePart): Instance?
	local clone = source:Clone()
	-- Clone copies tags and prompts; strip them so it is not a second NestEgg.
	local all = clone:GetDescendants()
	table.insert(all, clone)
	for _, d in all do
		CollectionService:RemoveTag(d, NEST_TAG)
	end
	for _, d in clone:GetDescendants() do
		if d:IsA("ProximityPrompt") then
			d:Destroy()
		end
	end
	local primary = primaryOf(clone)
	if not primary then
		clone:Destroy()
		return nil
	end
	for _, d in clone:GetDescendants() do
		if d:IsA("BasePart") then
			d.Anchored = false
			d.CanCollide = false
			d.CanQuery = false
			d.CanTouch = false
			d.Massless = true
		end
	end
	if clone:IsA("BasePart") then
		clone.Anchored = false
		clone.CanCollide = false
		clone.CanQuery = false
		clone.CanTouch = false
		clone.Massless = true
	end

	local target = root.CFrame * CFrame.new(EggConfig.CarryOffset)
	if clone:IsA("Model") then
		clone:PivotTo(target)
	else
		(clone :: BasePart).CFrame = target
	end
	-- Fully original appearance (source may be hidden later, clone made first).
	for _, d in clone:GetDescendants() do
		if d:IsA("BasePart") and d ~= primary then
			local w = Instance.new("WeldConstraint")
			w.Part0 = primary
			w.Part1 = d
			w.Parent = d
		end
	end
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = root
	weld.Part1 = primary
	weld.Parent = primary
	clone.Parent = root.Parent
	return clone
end

local function clearCarry(player: Player): Carry?
	local carry = carrying[player]
	if not carry then
		return nil
	end
	carrying[player] = nil
	carry.clone:Destroy()
	if player.Parent then
		player:SetAttribute("CarryingEgg", nil)
	end
	return carry
end

local function dropEgg(player: Player, reason: string)
	local carry = clearCarry(player)
	if not carry then
		return
	end
	if carry.nest then
		returnNest(carry.nest)
	end
	ServerBus.fire("EggDropped", player, carry.eggType, reason)
end

local function onSteal(nest: NestState, player: Player)
	if not nest.available or nests[nest.instance] ~= nest then
		return
	end
	if carrying[player] then
		return
	end
	local now = os.clock()
	if now - (lastSteal[player] or -math.huge) < EggConfig.StealCooldown then
		return
	end
	lastSteal[player] = now

	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not (character and humanoid and root and root:IsA("BasePart")) or humanoid.Health <= 0 then
		return
	end
	local nestPos = pivotPosition(nest.instance)
	if not nestPos then
		return
	end
	local maxDist = nest.prompt.MaxActivationDistance + EggConfig.StealDistanceTolerance
	if (root.Position - nestPos).Magnitude > maxDist then
		return
	end

	local clone = buildCarriedCopy(nest.instance, root)
	if not clone then
		return
	end
	setNestVisible(nest, false)
	nest.token += 1 -- cancel any pending respawn
	carrying[player] = { eggType = nest.eggType, nest = nest, clone = clone }
	player:SetAttribute("CarryingEgg", nest.eggType)
	ServerBus.fire("EggStolen", player, nest.eggType)
end

local function registerNest(inst: Instance)
	if nests[inst] then
		return
	end
	local eggType = inst:GetAttribute("EggType")
	if type(eggType) ~= "string" or EggConfig.Eggs[eggType] == nil then
		warn(("[EggCarryService] NestEgg %s has missing/unknown EggType attribute"):format(inst:GetFullName()))
		return
	end
	local anchor = primaryOf(inst)
	if not anchor then
		warn(("[EggCarryService] NestEgg %s has no BasePart"):format(inst:GetFullName()))
		return
	end

	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = EggConfig.StealPromptText
	prompt.ObjectText = EggConfig.Eggs[eggType].DisplayName
	prompt.HoldDuration = EggConfig.StealHoldDuration
	prompt.MaxActivationDistance = EggConfig.StealMaxActivationDistance
	prompt.RequiresLineOfSight = false
	prompt.Parent = anchor

	local original = {}
	local parts = inst:GetDescendants()
	table.insert(parts, inst)
	for _, d in parts do
		if d:IsA("BasePart") then
			original[d] = { Transparency = d.Transparency, CanCollide = d.CanCollide }
		end
	end

	local nest: NestState = {
		instance = inst,
		eggType = eggType,
		prompt = prompt,
		available = true,
		token = 0,
		original = original,
	}
	nests[inst] = nest
	prompt.Triggered:Connect(function(player: Player)
		onSteal(nest, player)
	end)
end

local function unregisterNest(inst: Instance)
	local nest = nests[inst]
	if not nest then
		return
	end
	nests[inst] = nil
	nest.token += 1
	nest.prompt:Destroy()
	for player, carry in carrying do
		if carry.nest == nest then
			carry.nest = nil
		end
	end
end

local function trackCharacter(player: Player, character: Model)
	characterSet[character] = true
	markFilterDirty()
	local humanoid = character:WaitForChild("Humanoid", 10)
	if humanoid and humanoid:IsA("Humanoid") then
		local conns = charConns[player]
		if conns then
			table.insert(
				conns,
				humanoid.Died:Connect(function()
					dropEgg(player, "Died")
				end)
			)
		end
	end
end

local function trackPlayer(player: Player)
	charConns[player] = {}
	local conns = charConns[player]
	table.insert(
		conns,
		player.CharacterAdded:Connect(function(character)
			trackCharacter(player, character)
		end)
	)
	table.insert(
		conns,
		player.CharacterRemoving:Connect(function(character)
			characterSet[character] = nil
			markFilterDirty()
			dropEgg(player, "Respawn")
		end)
	)
	if player.Character then
		task.spawn(trackCharacter, player, player.Character)
	end
end

-- Delivery loop (fixed rate, skips all work when nobody is carrying).
local function deliveryTick()
	if next(carrying) == nil or next(zones) == nil then
		return
	end
	if filterDirty then
		refreshFilter()
	end
	local found: { [Model]: boolean } = {}
	for zone in zones do
		if zone.Parent then
			for _, part in workspace:GetPartsInPart(zone, overlapParams) do
				local model = part:FindFirstAncestorOfClass("Model")
				if model and characterSet[model] then
					found[model] = true
				end
			end
		end
	end
	for player, carry in carrying do
		local character = player.Character
		if character and found[character] then
			local cleared = clearCarry(player)
			if cleared then
				if cleared.nest then
					scheduleRespawn(cleared.nest)
				end
				ServerBus.fire("EggDelivered", player, cleared.eggType)
			end
		end
	end
end

-- Wiring
ServerBus.connect("PlayerCaught", function(player: Player)
	dropEgg(player, "Caught")
end)

Players.PlayerAdded:Connect(trackPlayer)
for _, player in Players:GetPlayers() do
	trackPlayer(player)
end

Players.PlayerRemoving:Connect(function(player: Player)
	dropEgg(player, "Left")
	lastSteal[player] = nil
	local conns = charConns[player]
	if conns then
		for _, c in conns do
			c:Disconnect()
		end
		charConns[player] = nil
	end
	if player.Character then
		characterSet[player.Character] = nil
		markFilterDirty()
	end
end)

for _, inst in CollectionService:GetTagged(NEST_TAG) do
	registerNest(inst)
end
CollectionService:GetInstanceAddedSignal(NEST_TAG):Connect(registerNest)
CollectionService:GetInstanceRemovedSignal(NEST_TAG):Connect(unregisterNest)

for _, inst in CollectionService:GetTagged(ZONE_TAG) do
	if inst:IsA("BasePart") then
		zones[inst] = true
	end
end
CollectionService:GetInstanceAddedSignal(ZONE_TAG):Connect(function(inst)
	if inst:IsA("BasePart") then
		zones[inst] = true
	end
end)
CollectionService:GetInstanceRemovedSignal(ZONE_TAG):Connect(function(inst)
	if inst:IsA("BasePart") then
		zones[inst] = nil
	end
end)

if next(nests) == nil then
	warn("[EggCarryService] no valid NestEgg instances found yet; idling until some are tagged")
end
if next(zones) == nil then
	warn("[EggCarryService] no DeliveryZone instances found yet; idling until some are tagged")
end

task.spawn(function()
	local interval = 1 / math.min(EggConfig.DeliveryTickRate, 10)
	while true do
		task.wait(interval)
		deliveryTick()
	end
end)
