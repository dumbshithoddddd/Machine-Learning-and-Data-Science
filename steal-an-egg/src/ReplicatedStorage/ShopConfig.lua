--!strict
-- ShopConfig: all shop tunables. Server looks prices up here by itemId.
-- Items are tiered upgrades; each tier is bought in order (Tier N requires N-1).

export type Item = {
	DisplayName: string,
	Attribute: string, -- player attribute the item sets ("NoiseMultiplier" or "LuckMultiplier")
	Tier: number, -- 1-based level within Line
	Line: string, -- upgrade line; tiers of one line must be bought in order
	Price: number, -- coins
	Value: number, -- attribute value after purchase
}

local ShopConfig = {}

-- Ordered list so the client can display it stably.
ShopConfig.ItemOrder = {
	"SoftSoles1", "SoftSoles2", "SoftSoles3",
	"LuckyCharm1", "LuckyCharm2", "LuckyCharm3",
}

ShopConfig.Items = {
	SoftSoles1 = { DisplayName = "Soft Soles I (-15% noise)", Attribute = "NoiseMultiplier", Line = "SoftSoles", Tier = 1, Price = 100, Value = 0.85 },
	SoftSoles2 = { DisplayName = "Soft Soles II (-30% noise)", Attribute = "NoiseMultiplier", Line = "SoftSoles", Tier = 2, Price = 400, Value = 0.70 },
	SoftSoles3 = { DisplayName = "Soft Soles III (-50% noise)", Attribute = "NoiseMultiplier", Line = "SoftSoles", Tier = 3, Price = 1500, Value = 0.50 },
	LuckyCharm1 = { DisplayName = "Lucky Charm I (+10% luck)", Attribute = "LuckMultiplier", Line = "LuckyCharm", Tier = 1, Price = 150, Value = 1.10 },
	LuckyCharm2 = { DisplayName = "Lucky Charm II (+25% luck)", Attribute = "LuckMultiplier", Line = "LuckyCharm", Tier = 2, Price = 600, Value = 1.25 },
	LuckyCharm3 = { DisplayName = "Lucky Charm III (+50% luck)", Attribute = "LuckMultiplier", Line = "LuckyCharm", Tier = 3, Price = 2000, Value = 1.50 },
} :: { [string]: Item }

-- Developer products (Robux). PLACEHOLDER ids: must be replaced with real product ids
-- before shipping (unknown ids make ProcessReceipt return NotProcessedYet).
ShopConfig.DevProducts = {
	[1234567001] = { Kind = "Spins", Amount = 1 },
	[1234567002] = { Kind = "Spins", Amount = 5 },
	[1234567003] = { Kind = "Spins", Amount = 20 },
} :: { [number]: { Kind: string, Amount: number } }

-- Minimum seconds between BuyItemRequest from one player.
ShopConfig.RequestCooldown = 0.5

return ShopConfig
