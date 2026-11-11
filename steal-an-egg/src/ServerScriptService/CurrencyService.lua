--!strict
-- CurrencyService: the only writer of player.leaderstats.Coins. Server only.
-- No DataStore in this version: balances reset when the player leaves.

local Players = game:GetService("Players")

local CurrencyService = {}

local function isPositiveInteger(n: any): boolean
	return type(n) == "number" and n == n and n > 0 and n < 2 ^ 31 and n % 1 == 0
end

local function setup(player: Player)
	local stats = player:FindFirstChild("leaderstats")
	if not stats then
		stats = Instance.new("Folder")
		stats.Name = "leaderstats"
		stats.Parent = player
	end
	if not stats:FindFirstChild("Coins") then
		local coins = Instance.new("IntValue")
		coins.Name = "Coins"
		coins.Value = 0
		coins.Parent = stats
	end
end

local function getValue(player: Player): IntValue?
	local stats = player:FindFirstChild("leaderstats")
	local coins = stats and stats:FindFirstChild("Coins")
	if coins and coins:IsA("IntValue") then
		return coins
	end
	return nil
end

function CurrencyService.GetCoins(player: Player): number
	local v = getValue(player)
	return v and v.Value or 0
end

function CurrencyService.AddCoins(player: Player, amount: number, reason: string): boolean
	if not isPositiveInteger(amount) then
		return false
	end
	local v = getValue(player)
	if not v then
		return false
	end
	v.Value = math.min(v.Value + amount, 2147483647)
	return true
end

function CurrencyService.SpendCoins(player: Player, amount: number, reason: string): boolean
	if not isPositiveInteger(amount) then
		return false
	end
	local v = getValue(player)
	if not v or v.Value < amount then
		return false
	end
	v.Value -= amount
	return true
end

Players.PlayerAdded:Connect(setup)
for _, p in Players:GetPlayers() do
	setup(p)
end

return CurrencyService
