--!strict
-- EggConfig: all egg tunables and weighted pet tables. Shape of Eggs[eggType]
-- is fixed by docs/CONTRACT.md. Weights are relative (not percentages).

export type Pet = { Name: string, Weight: number, CoinValue: number }
export type EggDef = {
	DisplayName: string,
	CarrySpeedMultiplier: number,
	GrabLoudness: number,
	Pets: { Pet },
}

local EggConfig = {}

EggConfig.Eggs = {
	Common = {
		DisplayName = "Common Egg",
		CarrySpeedMultiplier = 0.9,
		GrabLoudness = 20,
		Pets = {
			{ Name = "Chick", Weight = 60, CoinValue = 10 },
			{ Name = "Duckling", Weight = 30, CoinValue = 25 },
			{ Name = "Gosling", Weight = 10, CoinValue = 60 },
		},
	},
	Spotted = {
		DisplayName = "Spotted Egg",
		CarrySpeedMultiplier = 0.8,
		GrabLoudness = 30,
		Pets = {
			{ Name = "Lizard", Weight = 50, CoinValue = 40 },
			{ Name = "Snake", Weight = 35, CoinValue = 90 },
			{ Name = "Baby Drake", Weight = 15, CoinValue = 220 },
		},
	},
	Golden = {
		DisplayName = "Golden Egg",
		CarrySpeedMultiplier = 0.65,
		GrabLoudness = 45,
		Pets = {
			{ Name = "Gilded Hen", Weight = 55, CoinValue = 150 },
			{ Name = "Phoenix Chick", Weight = 35, CoinValue = 400 },
			{ Name = "Dragon Hatchling", Weight = 10, CoinValue = 1200 },
		},
	},
} :: { [string]: EggDef }

-- Hatching
EggConfig.HatchCooldown = 1.5 -- seconds between hatches per player
EggConfig.LuckMin = 1 -- LuckMultiplier is clamped to [LuckMin, LuckMax]
EggConfig.LuckMax = 50

-- Stealing / carrying
EggConfig.StealPromptText = "Steal"
EggConfig.StealHoldDuration = 0.8
EggConfig.StealMaxActivationDistance = 8
EggConfig.StealDistanceTolerance = 6 -- extra studs the server allows over the prompt distance
EggConfig.StealCooldown = 1 -- per-player seconds between steal attempts
EggConfig.NestRespawnDelay = 20 -- seconds until a delivered egg reappears in its nest
EggConfig.CarryOffset = Vector3.new(0, 0, 1.6) -- relative to HumanoidRootPart (positive Z = behind)
EggConfig.DeliveryTickRate = 5 -- overlap checks per second (must be <= 10)

return EggConfig
