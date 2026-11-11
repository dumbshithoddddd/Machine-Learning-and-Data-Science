--!strict
-- ShopService: coin purchases of tiered upgrades + Robux dev-product receipts.
-- Server looks up the price by itemId; the client only sends an id string.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local MarketplaceService = game:GetService("MarketplaceService")

local Remotes = require(ReplicatedStorage.Remotes)
local ShopConfig = require(ReplicatedStorage.ShopConfig)
local CurrencyService = require(ServerScriptService.CurrencyService)

local buyRequest = Remotes.get("BuyItemRequest")
local buyResponse = Remotes.get("BuyItemResponse")

-- Per-player state, cleared on PlayerRemoving.
local lastRequest: { [Player]: number } = {}
local owned: { [Player]: { [string]: number } } = {} -- Line -> highest tier owned

local function ensureDefaults(player: Player)
	if player:GetAttribute("NoiseMultiplier") == nil then
		player:SetAttribute("NoiseMultiplier", 1)
	end
	if player:GetAttribute("LuckMultiplier") == nil then
		player:SetAttribute("LuckMultiplier", 1)
	end
	if player:GetAttribute("Spins") == nil then
		player:SetAttribute("Spins", 0)
	end
	owned[player] = owned[player] or {}
end

local function reply(player: Player, success: boolean, itemId: string, message: string)
	buyResponse:FireClient(player, success, itemId, message)
end

buyRequest.OnServerEvent:Connect(function(player: Player, itemId: any)
	if type(itemId) ~= "string" or #itemId > 64 then
		return
	end
	local now = os.clock()
	local last = lastRequest[player]
	if last and now - last < ShopConfig.RequestCooldown then
		return
	end
	lastRequest[player] = now

	local item = ShopConfig.Items[itemId]
	if not item then
		reply(player, false, itemId, "Unknown item.")
		return
	end
	local lines = owned[player]
	if not lines then
		return
	end
	local have = lines[item.Line] or 0
	if item.Tier <= have then
		reply(player, false, itemId, "Already owned.")
		return
	end
	if item.Tier ~= have + 1 then
		reply(player, false, itemId, "Buy the previous tier first.")
		return
	end
	if not CurrencyService.SpendCoins(player, item.Price, "Shop:" .. itemId) then
		reply(player, false, itemId, "Not enough coins.")
		return
	end
	lines[item.Line] = item.Tier
	player:SetAttribute(item.Attribute, item.Value)
	reply(player, true, itemId, "Purchased " .. item.DisplayName .. "!")
end)

-- Sole ProcessReceipt handler in the game.
-- LIMITATION: no DataStore in this version, so purchase ids are remembered only
-- in memory (processedIds). A server restart or rejoin could in principle re-run
-- a receipt Roblox retries; persist PurchaseId in a DataStore before shipping.
local processedIds: { [string]: boolean } = {}

MarketplaceService.ProcessReceipt = function(info: { [string]: any }): Enum.ProductPurchaseDecision
	local purchaseId = tostring(info.PurchaseId)
	if processedIds[purchaseId] then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end
	local player = Players:GetPlayerByUserId(info.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	local product = ShopConfig.DevProducts[info.ProductId]
	if not product or product.Kind ~= "Spins" then
		warn("ShopService: unknown dev product", info.ProductId)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	local current = player:GetAttribute("Spins")
	player:SetAttribute("Spins", (if type(current) == "number" then current else 0) + product.Amount)
	processedIds[purchaseId] = true
	return Enum.ProductPurchaseDecision.PurchaseGranted
end

Players.PlayerAdded:Connect(ensureDefaults)
for _, p in Players:GetPlayers() do
	ensureDefaults(p)
end

Players.PlayerRemoving:Connect(function(player)
	lastRequest[player] = nil
	owned[player] = nil
end)
