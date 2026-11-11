--!strict
-- EggHatchService: server-side inventory of delivered eggs, validated hatch
-- requests, and the weighted roll. The client never sees weights or rolls.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Remotes = require(ReplicatedStorage:WaitForChild("Remotes"))
local EggConfig = require(ReplicatedStorage:WaitForChild("EggConfig"))
local ServerBus = require(ServerScriptService:WaitForChild("ServerBus"))
local CurrencyService = require(ServerScriptService:WaitForChild("CurrencyService"))

local hatchRequest = Remotes.get("HatchEggRequest")
local hatchResponse = Remotes.get("HatchEggResponse")
local inventoryRequest = Remotes.get("EggInventoryRequest") -- extra: client asks for a snapshot
local inventoryResponse = Remotes.get("EggInventoryResponse") -- extra: server pushes counts

local rng = Random.new()

local inventory: { [Player]: { [string]: number } } = {}
local lastHatch: { [Player]: number } = {}
local lastInventoryRequest: { [Player]: number } = {}

local function getInventory(player: Player): { [string]: number }
	local inv = inventory[player]
	if not inv then
		inv = {}
		inventory[player] = inv
	end
	return inv
end

local function pushInventory(player: Player)
	local snapshot: { [string]: number } = {}
	for eggType in EggConfig.Eggs do
		snapshot[eggType] = getInventory(player)[eggType] or 0
	end
	inventoryResponse:FireClient(player, snapshot)
end

-- Weighted roll. Weights of rarer pets are scaled up by the player's luck:
-- the most common pet keeps its weight, a pet with weight w is multiplied by
-- luck ^ (1 - w / maxWeight). Returns nil when the table is unusable.
local function roll(eggType: string, luck: number): EggConfig.Pet?
	local def = EggConfig.Eggs[eggType]
	if not def then
		return nil
	end
	local maxWeight = 0
	for _, pet in def.Pets do
		if pet.Weight > maxWeight then
			maxWeight = pet.Weight
		end
	end
	if maxWeight <= 0 then
		return nil
	end

	local adjusted: { number } = {}
	local total = 0
	for i, pet in def.Pets do
		local w = 0
		if pet.Weight > 0 then
			w = pet.Weight * math.pow(luck, 1 - pet.Weight / maxWeight)
		end
		adjusted[i] = w
		total += w
	end
	if total <= 0 or total ~= total then
		return nil
	end

	local r = rng:NextNumber() * total
	local lastValid: EggConfig.Pet? = nil
	for i, pet in def.Pets do
		local w = adjusted[i]
		if w > 0 then
			lastValid = pet
			if r < w then
				return pet
			end
			r -= w
		end
	end
	return lastValid -- floating point edge: fall back to last positive-weight pet
end

local function getLuck(player: Player): number
	local luck = player:GetAttribute("LuckMultiplier")
	if type(luck) ~= "number" or luck ~= luck then
		luck = 1
	end
	return math.clamp(luck :: number, EggConfig.LuckMin, EggConfig.LuckMax)
end

ServerBus.connect("EggDelivered", function(player: Player, eggType: string)
	if not player.Parent or EggConfig.Eggs[eggType] == nil then
		return
	end
	local inv = getInventory(player)
	inv[eggType] = (inv[eggType] or 0) + 1
	pushInventory(player)
end)

hatchRequest.OnServerEvent:Connect(function(player: Player, eggType: unknown)
	if type(eggType) ~= "string" then
		return
	end
	local now = os.clock()
	if now - (lastHatch[player] or -math.huge) < EggConfig.HatchCooldown then
		return -- rate limited; silently drop spam
	end
	lastHatch[player] = now

	if EggConfig.Eggs[eggType] == nil then
		hatchResponse:FireClient(player, false, "")
		return
	end
	local inv = getInventory(player)
	if (inv[eggType] or 0) <= 0 then
		hatchResponse:FireClient(player, false, eggType)
		return
	end

	inv[eggType] -= 1 -- consume before anything else so a double fire cannot duplicate
	local pet = roll(eggType, getLuck(player))
	local coins = if pet then math.floor(pet.CoinValue) else 0
	if not pet or not CurrencyService.AddCoins(player, coins, "Hatch:" .. eggType) then
		inv[eggType] += 1 -- refund
		hatchResponse:FireClient(player, false, eggType)
		pushInventory(player)
		return
	end

	hatchResponse:FireClient(player, true, eggType, pet.Name, coins)
	pushInventory(player)
end)

inventoryRequest.OnServerEvent:Connect(function(player: Player)
	local now = os.clock()
	if now - (lastInventoryRequest[player] or -math.huge) < 1 then
		return
	end
	lastInventoryRequest[player] = now
	pushInventory(player)
end)

Players.PlayerRemoving:Connect(function(player: Player)
	inventory[player] = nil
	lastHatch[player] = nil
	lastInventoryRequest[player] = nil
end)
