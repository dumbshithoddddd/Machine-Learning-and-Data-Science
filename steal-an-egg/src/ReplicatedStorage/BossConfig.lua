--!strict
-- BossConfig: every tunable for the boss (BossAI + BossWakeStateMachine).

local BossConfig = {
	-- ===== Wake state machine =====
	-- Alertness is 0..1.
	StirringThreshold = 0.3, -- Asleep -> Stirring at or above this
	AwakeThreshold = 0.8, -- Stirring -> Awake at or above this
	AsleepThreshold = 0.12, -- Stirring -> Asleep at or below this (hysteresis)
	DecayPerSecond = 0.05, -- alertness lost per second (not while Awake)
	ReturnAlertness = 0.2, -- alertness set when the chase ends (Returning)

	-- Noise -> alertness. gain = GainPerLoudnessStud * loudness * falloff.
	GainPerLoudnessStud = 0.01, -- loudness 20 studs fully audible => +0.2
	-- falloff is 1 within `loudness` studs of the boss, fading linearly to 0 at
	-- loudness * HearingMaxMultiplier; beyond that the noise is inaudible.
	HearingMaxMultiplier = 2.5,

	TargetMemorySeconds = 8, -- noise score of a player decays to 0 over this long
	StateTickRate = 5, -- wake loop Hz (must be <= 10)
	AlertnessBroadcastInterval = 0.25, -- min seconds between BossWakeResponse updates
	AlertnessBroadcastEpsilon = 0.01, -- min alertness change worth broadcasting

	-- Group-private signalling BossAI -> BossWakeStateMachine (boss model attributes).
	ChaseOverAttribute = "ChaseOverCount",
	ReturnDoneAttribute = "ReturnDoneCount",

	-- ===== Boss AI =====
	AITickRate = 10, -- AI loop Hz (must be <= 10)
	PatrolWhileStirring = true,
	PatrolSpeed = 8,
	ChaseSpeed = 20,
	ReturnSpeed = 12,

	PathRecomputeInterval = 0.6, -- seconds; hard floor between ComputeAsync calls
	RecomputeMinTargetMove = 4, -- studs the target must move to justify a recompute
	WaypointReachDistance = 3.5, -- horizontal studs to count a waypoint as reached
	WaypointTimeout = 2.5, -- seconds without waypoint progress => recompute
	PatrolReachDistance = 5,
	NestArrivalDistance = 6,
	ReturnTimeoutSeconds = 40, -- teleport home if the walk takes longer than this

	CatchRadius = 5, -- studs from boss root to target HumanoidRootPart
	CatchPauseSeconds = 1.0, -- boss stands still this long after a catch
	LoseDistance = 90, -- target farther than this ...
	LoseTimeSeconds = 6, -- ... for this long ends the chase
	MaxChaseSeconds = 60,

	AgentParameters = {
		AgentRadius = 3,
		AgentHeight = 8,
		AgentCanJump = true,
		AgentCanClimb = false,
		WaypointSpacing = 4,
	},
}

return BossConfig
