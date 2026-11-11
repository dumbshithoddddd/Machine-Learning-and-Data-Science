--!strict
-- SneakConfig: every tunable for sneaking, noise, branches and the detection ring.
-- Loudness values are in studs: the radius at which the noise is fully audible.

local SneakConfig = {
	-- Movement (read by other groups: BaseWalkSpeed, SneakSpeedMultiplier)
	BaseWalkSpeed = 16,
	SneakSpeedMultiplier = 0.45,
	ToggleMinInterval = 0.25, -- seconds between accepted SneakToggleRequests per player

	-- Footsteps
	FootstepRate = 4, -- server checks per second (must be <= 5)
	FootstepLoudnessRun = 40,
	FootstepLoudnessSneak = 8,
	CarryLoudnessMultiplier = 1.5, -- applied while CarryingEgg is set
	MinMoveSpeed = 2, -- studs/s of horizontal velocity needed to count as moving

	-- Landing
	LandingLoudness = 35,
	LandingSneakMultiplier = 0.6,
	LandingMinAirTime = 0.4, -- seconds in Freefall before a landing is audible
	LandingSpawnGrace = 1.5, -- seconds after spawn during which landings are silent

	-- Egg grab fallback if EggConfig has no GrabLoudness
	EggGrabDefaultLoudness = 45,

	-- Branches
	BranchDefaultLoudness = 55,
	BranchRearmTime = 20, -- seconds until a snapped branch is armed again
	BranchCheckRate = 8, -- server checks per second (<= 10)
	BranchStepRadius = 2.5, -- studs around the character's feet that count as stepping on
	SneakSnapChance = 0, -- 0..1, rolled once per new contact while sneaking (0 = sneaking is always safe)

	-- Per-player emission rate cap (token bucket)
	EmitBucketSize = 6,
	EmitRefillPerSecond = 4,
	-- Clients farther than this from a noise do not receive NoiseEmitResponse (source player always does)
	ClientNoiseRange = 250,

	-- Detection ring (client cosmetics)
	RingMinRadius = 1.5,
	RingMaxRadius = 80,
	RingHoldTime = 0.35, -- seconds a new noise radius is held before easing down
	RingRiseRate = 14, -- exponential ease speed going up
	RingFallRate = 1.6, -- exponential ease speed going down
	RingHeight = 0.15,
	RingTransparency = 0.65,
	RingColors = {
		Asleep = Color3.fromRGB(80, 220, 120),
		Stirring = Color3.fromRGB(245, 215, 70),
		Awake = Color3.fromRGB(235, 70, 60),
		Returning = Color3.fromRGB(240, 150, 60),
	},

	-- Branch snap cosmetics (client)
	SnapSoundId = "", -- set to an rbxassetid:// sound; empty = silent
	SnapSoundVolume = 0.8,
	SnapCameraNudge = 0.6, -- studs of CameraOffset shake
	SnapCameraNudgeRange = 60,
	SnappedTransparency = 0.6,
}

return SneakConfig
