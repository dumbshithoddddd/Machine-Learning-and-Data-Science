--!strict
-- TreadmillService: tagged "Treadmill" hitboxes train SpeedBonus.
-- Fixed-rate server overlap loop; never touches Humanoid.WalkSpeed (SneakService owns it).

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local CollectionService = game:GetService("CollectionService")

local TreadmillConfig = require(ReplicatedStorage.TreadmillConfig)
local CurrencyService = require(ServerScriptService.CurrencyService)

local TAG = "Treadmill"

local treadmills: { [BasePart]: boolean } = {}
local count = 0

local function add(inst: Instance)
	if inst:IsA("BasePart") and not treadmills[inst] then
		treadmills[inst] = true
		count += 1
	end
end

local function remove(inst: Instance)
	if treadmills[inst :: BasePart] then
		treadmills[inst :: BasePart] = nil
		count -= 1
	end
end

CollectionService:GetInstanceAddedSignal(TAG):Connect(add)
CollectionService:GetInstanceRemovedSignal(TAG):Connect(remove)
for _, inst in CollectionService:GetTagged(TAG) do
	add(inst)
end

if count == 0 then
	warn("TreadmillService: no parts tagged '" .. TAG .. "' yet; idling until some appear.")
end

-- Created once, reused every tick.
local params = OverlapParams.new()
params.FilterType = Enum.RaycastFilterType.Include
params.MaxParts = 512 -- one character is 15-30+ parts; a low cap could hide whole players

local function characterToPlayer(part: BasePart): Player?
	local model = part:FindFirstAncestorOfClass("Model")
	if not model then
		return nil
	end
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return nil
	end
	return Players:GetPlayerFromCharacter(model)
end

-- Guard against TickRate <= 0 and keep the loop at 10 Hz or slower.
local tickRate = math.clamp(TreadmillConfig.TickRate, 0.1, 10)
local interval = 1 / tickRate

-- Reused every tick (cleared, not reallocated). No per-player state is kept.
local rewarded: { [Player]: number } = {} -- one reward per character per tick
local characters: { Instance } = {}

while true do
	task.wait(interval)
	if count == 0 then
		continue
	end

	table.clear(rewarded)
	table.clear(characters)
	for _, plr in Players:GetPlayers() do
		if plr.Character then
			table.insert(characters, plr.Character)
		end
	end
	if #characters == 0 then
		continue
	end
	params.FilterDescendantsInstances = characters

	for tread in treadmills do
		local perTick = tread:GetAttribute("SpeedPerTick")
		if type(perTick) ~= "number" or perTick <= 0 then
			perTick = TreadmillConfig.SpeedPerTick
		end
		for _, part in workspace:GetPartsInPart(tread, params) do
			local plr = characterToPlayer(part)
			if plr and not rewarded[plr] then
				rewarded[plr] = perTick
			end
		end
	end

	for plr, perTick in rewarded do
		local cur = plr:GetAttribute("SpeedBonus")
		cur = if type(cur) == "number" then cur else 0
		if cur < TreadmillConfig.MaxSpeedBonus then
			plr:SetAttribute("SpeedBonus", math.min(cur + perTick, TreadmillConfig.MaxSpeedBonus))
			if TreadmillConfig.CoinsPerTick > 0 then
				CurrencyService.AddCoins(plr, TreadmillConfig.CoinsPerTick, TreadmillConfig.CoinReason)
			end
		end
	end
end
