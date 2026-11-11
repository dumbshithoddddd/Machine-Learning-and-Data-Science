--!strict
-- NoiseService: the ONLY script that fires ServerBus "NoiseEmitted".
-- Sources: Footstep (throttled loop), Landing (StateChanged), Branch (throttled
-- radius query around players), EggGrab (ServerBus EggStolen).
-- Every decision is made from server-observed state; clients only receive.

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Remotes = require(ReplicatedStorage:WaitForChild("Remotes"))
local SneakConfig = require(ReplicatedStorage:WaitForChild("SneakConfig"))
local ServerBus = require(ServerScriptService:WaitForChild("ServerBus"))

local noiseRemote = Remotes.get("NoiseEmitResponse")

local FOOTSTEP_INTERVAL = 1 / math.min(SneakConfig.FootstepRate, 5)
local BRANCH_INTERVAL = 1 / math.min(SneakConfig.BranchCheckRate, 10)

local eggConfigCache: any = nil
local function getEggConfig(): any
	if eggConfigCache == nil then
		local module = ReplicatedStorage:FindFirstChild("EggConfig")
		if module and module:IsA("ModuleScript") then
			local ok, result = pcall(require, module)
			if ok then
				eggConfigCache = result
			end
		end
	end
	return eggConfigCache
end

-- Per-player state ------------------------------------------------------------

type CharInfo = { humanoid: Humanoid, root: BasePart }
local chars: { [Player]: CharInfo } = {}
local charConns: { [Player]: { RBXScriptConnection } } = {}
local playerConns: { [Player]: RBXScriptConnection } = {}
local airStart: { [Player]: number } = {}
local buckets: { [Player]: { tokens: number, t: number } } = {}
local contacts: { [Player]: { [BasePart]: number } } = {}

-- Emission -----------------------------------------------------------------------

local function takeToken(player: Player): boolean
	local now = os.clock()
	local b = buckets[player]
	if not b then
		b = { tokens = SneakConfig.EmitBucketSize, t = now }
		buckets[player] = b
	end
	b.tokens = math.min(SneakConfig.EmitBucketSize, b.tokens + (now - b.t) * SneakConfig.EmitRefillPerSecond)
	b.t = now
	if b.tokens < 1 then
		return false
	end
	b.tokens -= 1
	return true
end

local function emit(player: Player?, position: Vector3, loudness: number, source: string)
	if loudness <= 0 then
		return
	end
	-- EggGrab is rare and server-originated: it never consumes or waits on the bucket.
	if player and source ~= "EggGrab" and not takeToken(player) then
		return
	end
	ServerBus.fire("NoiseEmitted", player, position, loudness, source)

	local range = SneakConfig.ClientNoiseRange
	for other, info in chars do
		if other == player or (info.root.Position - position).Magnitude <= range then
			noiseRemote:FireClient(other, position, loudness, source, other == player)
		end
	end
end

local function noiseMultiplier(player: Player): number
	local m = player:GetAttribute("NoiseMultiplier")
	if typeof(m) == "number" and m >= 0 then
		return m
	end
	return 1
end

local function carryMultiplier(player: Player): number
	if typeof(player:GetAttribute("CarryingEgg")) == "string" then
		return SneakConfig.CarryLoudnessMultiplier
	end
	return 1
end

-- Character tracking -----------------------------------------------------------

local function clearCharacter(player: Player)
	chars[player] = nil
	airStart[player] = nil
	contacts[player] = nil
	local conns = charConns[player]
	if conns then
		for _, c in conns do
			c:Disconnect()
		end
		charConns[player] = nil
	end
end

local function onCharacterAdded(player: Player, character: Model)
	clearCharacter(player)
	local humanoid = character:WaitForChild("Humanoid", 10)
	local root = character:WaitForChild("HumanoidRootPart", 10)
	if
		not humanoid
		or not root
		or not humanoid:IsA("Humanoid")
		or not root:IsA("BasePart")
		or player.Character ~= character
	then
		return
	end
	chars[player] = { humanoid = humanoid, root = root }
	contacts[player] = {}

	local conns: { RBXScriptConnection } = {}
	charConns[player] = conns
	table.insert(
		conns,
		humanoid.StateChanged:Connect(function(_old, new)
			if new == Enum.HumanoidStateType.Freefall then
				if airStart[player] == nil then
					airStart[player] = os.clock()
				end
			elseif new == Enum.HumanoidStateType.Landed then
				local started = airStart[player]
				airStart[player] = nil
				if started and os.clock() - started >= SneakConfig.LandingMinAirTime and humanoid.Health > 0 then
					local loud = SneakConfig.LandingLoudness * noiseMultiplier(player) * carryMultiplier(player)
					if player:GetAttribute("IsSneaking") == true then
						loud *= SneakConfig.LandingSneakMultiplier
					end
					emit(player, root.Position, loud, "Landing")
				end
			elseif new == Enum.HumanoidStateType.Dead then
				airStart[player] = nil
			end
		end)
	)
	table.insert(
		conns,
		character.AncestryChanged:Connect(function(_, parent)
			if parent == nil and chars[player] and chars[player].root == root then
				clearCharacter(player)
			end
		end)
	)
end

local function setupPlayer(player: Player)
	if playerConns[player] then
		return
	end
	playerConns[player] = player.CharacterAdded:Connect(function(character)
		onCharacterAdded(player, character)
	end)
	if player.Character then
		task.spawn(onCharacterAdded, player, player.Character)
	end
end

local function cleanupPlayer(player: Player)
	clearCharacter(player)
	buckets[player] = nil
	local c = playerConns[player]
	if c then
		c:Disconnect()
		playerConns[player] = nil
	end
end

Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(cleanupPlayer)
for _, player in Players:GetPlayers() do
	setupPlayer(player)
end

-- Footsteps ----------------------------------------------------------------------

task.spawn(function()
	while true do
		task.wait(FOOTSTEP_INTERVAL)
		for player, info in chars do
			local humanoid, root = info.humanoid, info.root
			if
				humanoid.Health > 0
				and not humanoid.Sit
				and humanoid.FloorMaterial ~= Enum.Material.Air
				and humanoid.MoveDirection.Magnitude >= SneakConfig.MinMoveDirection
			then
				local v = root.AssemblyLinearVelocity
				local horizontal = math.sqrt(v.X * v.X + v.Z * v.Z)
				if horizontal >= SneakConfig.MinMoveSpeed then
					local base = if player:GetAttribute("IsSneaking") == true
						then SneakConfig.FootstepLoudnessSneak
						else SneakConfig.FootstepLoudnessRun
					emit(player, root.Position, base * noiseMultiplier(player) * carryMultiplier(player), "Footstep")
				end
			end
		end
	end
end)

-- Egg grab -----------------------------------------------------------------------

ServerBus.connect("EggStolen", function(player: Player, eggType: string)
	local info = chars[player]
	if not info then
		return
	end
	local loud = SneakConfig.EggGrabDefaultLoudness
	local cfg = getEggConfig()
	local entry = cfg and cfg.Eggs and cfg.Eggs[eggType]
	if entry and typeof(entry.GrabLoudness) == "number" then
		loud = entry.GrabLoudness
	end
	emit(player, info.root.Position, loud * noiseMultiplier(player), "EggGrab")
end)

-- Branches -----------------------------------------------------------------------

local branches: { [BasePart]: boolean } = {} -- value = armed
local armGen: { [BasePart]: number } = {}
local branchList: { Instance } = {}
local branchesDirty = true
local warnedEmpty = false
local tickId = 0

local overlapParams = OverlapParams.new()
overlapParams.FilterType = Enum.RaycastFilterType.Include
overlapParams.MaxParts = 32

local function registerBranch(instance: Instance)
	if not instance:IsA("BasePart") or branches[instance] ~= nil then
		return
	end
	instance.CanQuery = true
	branches[instance] = true
	armGen[instance] = 0
	instance:SetAttribute("Snapped", false)
	branchesDirty = true
end

local function unregisterBranch(instance: Instance)
	if not instance:IsA("BasePart") or branches[instance] == nil then
		return
	end
	branches[instance] = nil
	armGen[instance] = nil
	for _, map in contacts do
		map[instance] = nil
	end
	branchesDirty = true
end

CollectionService:GetInstanceAddedSignal("Branch"):Connect(registerBranch)
CollectionService:GetInstanceRemovedSignal("Branch"):Connect(unregisterBranch)
for _, inst in CollectionService:GetTagged("Branch") do
	registerBranch(inst)
end

local function snap(player: Player, part: BasePart)
	branches[part] = false
	local gen = (armGen[part] or 0) + 1
	armGen[part] = gen
	part:SetAttribute("Snapped", true)
	task.delay(SneakConfig.BranchRearmTime, function()
		if branches[part] == false and armGen[part] == gen then
			branches[part] = true
			part:SetAttribute("Snapped", false)
		end
	end)
	local loud = part:GetAttribute("Loudness")
	if typeof(loud) ~= "number" or loud <= 0 then
		loud = SneakConfig.BranchDefaultLoudness
	end
	emit(player, part.Position, loud, "Branch")
end

task.spawn(function()
	while true do
		task.wait(BRANCH_INTERVAL)
		if branchesDirty then
			branchesDirty = false
			table.clear(branchList)
			for part in branches do
				table.insert(branchList, part)
			end
			overlapParams.FilterDescendantsInstances = branchList
			if #branchList == 0 and not warnedEmpty then
				warnedEmpty = true
				warn("NoiseService: no Branch-tagged parts; branch noise idle")
			end
		end
		if #branchList > 0 then
			tickId += 1
			for player, info in chars do
				local humanoid, root = info.humanoid, info.root
				if humanoid.Health > 0 and humanoid.FloorMaterial ~= Enum.Material.Air then
					local feet = root.Position - Vector3.new(0, root.Size.Y / 2 + humanoid.HipHeight, 0)
					local found = workspace:GetPartBoundsInRadius(feet, SneakConfig.BranchStepRadius, overlapParams)
					local map = contacts[player]
					if map then
						local sneaking = player:GetAttribute("IsSneaking") == true
						for _, part in found do
							local bp = part :: BasePart
							if branches[bp] ~= nil then
								-- Contact is stamped even while the branch is snapped, so a
								-- character that stays on it through the re-arm must leave
								-- (a tick without overlap) and re-enter to snap it again.
								local isNew = map[bp] ~= tickId - 1
								map[bp] = tickId
								if isNew and branches[bp] == true then
									if not sneaking or math.random() < SneakConfig.SneakSnapChance then
										snap(player, bp)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)
