--!strict
-- SpinConfig: all tunables and the weighted slot table for the spin wheel.
-- Reward.Kind: "Coins" | "SpeedBonus" | "Spins". Rewards are granted by the
-- server only; the client reads this file purely to draw labels.

export type Reward = { Kind: string, Amount: number }
export type Slot = { Label: string, Weight: number, Reward: Reward }

local SpinConfig = {
	-- Seconds between free spins.
	FreeSpinCooldown = 600,
	-- Seconds the wheel animates; the server blocks further spins this long.
	SpinDuration = 4.5,
	-- Max value of the Spins attribute (stops unbounded stacking).
	MaxSpins = 99,
	-- ProximityPrompt settings for SpinWheel-tagged parts.
	PromptActionText = "Spin the Wheel",
	PromptObjectText = "Lucky Wheel",
	PromptMaxDistance = 12,
	-- Player attribute (os.time epoch seconds) after which a free spin is ready.
	NextFreeSpinAttribute = "NextFreeSpinAt",

	-- Order matters: slotIndex sent to the client is the index in this list.
	Slots = {
		{ Label = "50 Coins", Weight = 30, Reward = { Kind = "Coins", Amount = 50 } },
		{ Label = "+1 Speed", Weight = 15, Reward = { Kind = "SpeedBonus", Amount = 1 } },
		{ Label = "150 Coins", Weight = 20, Reward = { Kind = "Coins", Amount = 150 } },
		{ Label = "+1 Spin", Weight = 10, Reward = { Kind = "Spins", Amount = 1 } },
		{ Label = "400 Coins", Weight = 10, Reward = { Kind = "Coins", Amount = 400 } },
		{ Label = "+2 Speed", Weight = 8, Reward = { Kind = "SpeedBonus", Amount = 2 } },
		{ Label = "1000 Coins", Weight = 5, Reward = { Kind = "Coins", Amount = 1000 } },
		{ Label = "+3 Spins", Weight = 2, Reward = { Kind = "Spins", Amount = 3 } },
	} :: { Slot },
}

return SpinConfig
