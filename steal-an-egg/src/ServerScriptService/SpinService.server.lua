--!strict
-- SpinService: server-authoritative spin wheel.
-- The server checks eligibility, rolls, and PAYS IMMEDIATELY. The client only
-- animates to the slotIndex it is told; nothing it reports gates the reward.

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Remotes = require(ReplicatedStorage.Remotes)
local SpinConfig = require(ReplicatedStorage.SpinConfig)
local TreadmillConfig = require(ReplicatedStorage.TreadmillConfig)
local CurrencyService = require(ServerScriptService.CurrencyService)

local SpinRequest = Remotes.get("SpinRequest")
local SpinResponse = Remotes.get("SpinResponse")
local SpinOpenResponse = Remotes.get("SpinOpenResponse")

local TAG = "SpinWheel"
local NEXT_FREE_ATTR = SpinConfig.NextFreeSpinAttribute

-- Per-player os.clock() time until which a new spin is refused (in-flight lock).
local lockedUntil: { [Player]: number } = {}
local lastReplyAt: { [Player]: number } = {}
local REPLY_THROTTLE = 0.5 -- seconds between rejection replies per player
local prompts: { [Instance]: ProximityPrompt } = {}
local warnedNoWheel = false

local function getNumberAttr(player: Player, name: string, default: number): number
	local v = player:GetAttribute(name)
	if type(v) == "number" and v == v then
		return v
	end
	return default
end

-- Weighted roll. Returns nil when no slot has positive weight.
local function rollSlot(): number?
	local total = 0
	for _, slot in ipairs(SpinConfig.Slots) do
		if slot.Weight > 0 then
			total += slot.Weight
		end
	end
	if total <= 0 then
		return nil
	end
	local pick = math.random() * total
	local acc = 0
	local lastValid: number? = nil
	for i, slot in ipairs(SpinConfig.Slots) do
		if slot.Weight > 0 then
			lastValid = i
			acc += slot.Weight
			if pick < acc then
				return i
			end
		end
	end
	return lastValid -- floating point edge
end

-- Adds `amount` to a numeric attribute up to `cap`. Never lowers a value that
-- is already at/above the cap. Returns the amount actually added.
local function addCapped(player: Player, attr: string, amount: number, cap: number): number
	local cur = getNumberAttr(player, attr, 0)
	if cur >= cap then
		return 0
	end
	local newVal = math.min(cur + amount, cap)
	player:SetAttribute(attr, newVal)
	return newVal - cur
end

-- Returns ok, label suffix. ok=false means nothing was paid (caller refunds).
local function grant(player: Player, reward: SpinConfig.Reward): (boolean, string)
	local amount = math.floor(reward.Amount)
	if amount <= 0 then
		return false, ""
	end
	if reward.Kind == "Coins" then
		return CurrencyService.AddCoins(player, amount, "Spin") == true, ""
	elseif reward.Kind == "SpeedBonus" then
		local added = addCapped(player, "SpeedBonus", amount, TreadmillConfig.MaxSpeedBonus)
		return true, if added <= 0 then " (already maxed)" else ""
	elseif reward.Kind == "Spins" then
		local added = addCapped(player, "Spins", amount, SpinConfig.MaxSpins)
		return true, if added <= 0 then " (already maxed)" else ""
	end
	warn("[SpinService] unknown reward kind: " .. tostring(reward.Kind))
	return false, ""
end

local function fail(player: Player, message: string)
	local t = os.clock()
	local last = lastReplyAt[player]
	if last and t - last < REPLY_THROTTLE then
		return -- drop silently: a spamming client gets no unlimited replies
	end
	lastReplyAt[player] = t
	SpinResponse:FireClient(player, false, nil, message)
end

local function handleSpin(player: Player)
	local now = os.clock()
	local lock = lockedUntil[player]
	if lock and now < lock then
		fail(player, "Wheel is already spinning")
		return
	end

	local slotIndex = rollSlot()
	if slotIndex == nil then
		fail(player, "Wheel unavailable")
		return
	end

	-- Eligibility: free spin first, otherwise consume a held spin.
	local wall = os.time()
	local usedFree = false
	local prevNextFree = getNumberAttr(player, NEXT_FREE_ATTR, 0)
	if wall >= getNumberAttr(player, NEXT_FREE_ATTR, 0) then
		usedFree = true
	elseif getNumberAttr(player, "Spins", 0) < 1 then
		fail(player, "No spins available")
		return
	end

	-- Commit: lock, consume, then pay immediately.
	lockedUntil[player] = now + SpinConfig.SpinDuration
	if usedFree then
		player:SetAttribute(NEXT_FREE_ATTR, wall + SpinConfig.FreeSpinCooldown)
	else
		player:SetAttribute("Spins", getNumberAttr(player, "Spins", 0) - 1)
	end

	local slot = SpinConfig.Slots[slotIndex]
	local pcallOk, paid, suffix = pcall(grant, player, slot.Reward)
	if not pcallOk or paid ~= true then
		if not pcallOk then
			warn("[SpinService] grant threw: " .. tostring(paid))
		end
		-- Refund the consumed spin and release the lock.
		if usedFree then
			player:SetAttribute(NEXT_FREE_ATTR, prevNextFree)
		else
			player:SetAttribute("Spins", getNumberAttr(player, "Spins", 0) + 1)
		end
		lockedUntil[player] = nil
		SpinResponse:FireClient(player, false, nil, "Spin failed, not charged")
		return
	end
	SpinResponse:FireClient(player, true, slotIndex, slot.Label .. (suffix :: string))
end

SpinRequest.OnServerEvent:Connect(function(player: Player, ...: any)
	-- SpinRequest takes no arguments; ignore any payload.
	handleSpin(player)
end)

-- SpinWheel prompts ---------------------------------------------------------

local function addWheel(inst: Instance)
	if prompts[inst] or not inst:IsA("BasePart") then
		return
	end
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = SpinConfig.PromptActionText
	prompt.ObjectText = SpinConfig.PromptObjectText
	prompt.MaxActivationDistance = SpinConfig.PromptMaxDistance
	prompt.RequiresLineOfSight = false
	prompt.Triggered:Connect(function(player: Player)
		SpinOpenResponse:FireClient(player)
	end)
	prompt.Parent = inst
	prompts[inst] = prompt
end

local function removeWheel(inst: Instance)
	local prompt = prompts[inst]
	if prompt then
		prompts[inst] = nil
		prompt:Destroy()
	end
end

CollectionService:GetInstanceAddedSignal(TAG):Connect(addWheel)
CollectionService:GetInstanceRemovedSignal(TAG):Connect(removeWheel)
for _, inst in ipairs(CollectionService:GetTagged(TAG)) do
	addWheel(inst)
end
if next(prompts) == nil and not warnedNoWheel then
	warnedNoWheel = true
	warn("[SpinService] no SpinWheel-tagged parts found; idling until one appears")
end

-- Player setup / cleanup ----------------------------------------------------

local function setupPlayer(player: Player)
	if player:GetAttribute("Spins") == nil then
		player:SetAttribute("Spins", 0)
	end
	if player:GetAttribute(NEXT_FREE_ATTR) == nil then
		player:SetAttribute(NEXT_FREE_ATTR, 0)
	end
end

Players.PlayerAdded:Connect(setupPlayer)
for _, p in ipairs(Players:GetPlayers()) do
	setupPlayer(p)
end

Players.PlayerRemoving:Connect(function(player: Player)
	lockedUntil[player] = nil
	lastReplyAt[player] = nil
end)
