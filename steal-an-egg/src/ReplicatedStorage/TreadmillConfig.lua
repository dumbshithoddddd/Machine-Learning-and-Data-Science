--!strict
-- TreadmillConfig: tunables for tagged "Treadmill" hitboxes.

local TreadmillConfig = {
	TickRate = 5, -- overlap checks per second (contract: 5)
	SpeedPerTick = 0.02, -- default SpeedBonus added per tick (part attribute SpeedPerTick overrides)
	MaxSpeedBonus = 8, -- SpeedBonus cap (studs/sec added to base walk speed)
	CoinsPerTick = 0, -- optional small coin reward per tick; 0 disables
	CoinReason = "Treadmill",
}

return TreadmillConfig
