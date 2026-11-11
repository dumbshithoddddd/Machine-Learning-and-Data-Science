--!strict
-- BossWakeStateMachine: owns the boss wake decision.
-- Asleep -> Stirring -> Awake -> Returning -> Asleep.
-- Sole firer of ServerBus "BossStateChanged"; sole writer of workspace
-- attributes BossState / BossAlertness.
-- Talks to BossAI through attributes on the BossNPC model (BossAI writes
-- BossConfig.ChaseOverAttribute / ReturnDoneAttribute counters; we poll them).

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local BossConfig = require(ReplicatedStorage:WaitForChild("BossConfig"))
local Remotes = require(ReplicatedStorage:WaitForChild("Remotes"))
local ServerBus = require(ServerScriptService:WaitForChild("ServerBus"))

local wakeRemote = Remotes.get("BossWakeResponse")

local state = "Asleep"
local alertness = 0
-- NOTE: the chase target is fixed at the moment the boss wakes (Awake). There is
-- no mid-chase retargeting to a noisier player; noise while Awake is ignored.
local target: Player? = nil
local stateSince = os.clock() -- when the current state was entered (watchdog)

-- Exactly one BossNPC model is supported (the first tagged one); extras are ignored.
-- Boss tracking (event driven, GetTagged read once).
local bosses: { Model } = {}
local warnedNoBoss = false

local function addBoss(inst: Instance)
	if inst:IsA("Model") and not table.find(bosses, inst) then
		table.insert(bosses, inst)
	end
end
for _, inst in CollectionService:GetTagged("BossNPC") do
	addBoss(inst)
end
CollectionService:GetInstanceAddedSignal("BossNPC"):Connect(addBoss)
CollectionService:GetInstanceRemovedSignal("BossNPC"):Connect(function(inst)
	local i = table.find(bosses, inst :: Model)
	if i then
		table.remove(bosses, i)
	end
end)

local function getBoss(): Model?
	for i = #bosses, 1, -1 do
		if bosses[i].Parent == nil then
			table.remove(bosses, i)
		end
	end
	-- A boss without a Humanoid, or with a dead one, counts as absent.
	for _, m in bosses do
		local hum = m:FindFirstChildOfClass("Humanoid")
		if hum and hum.Health > 0 then
			return m
		end
	end
	return nil
end

local function getBossRoot(boss: Model?): BasePart?
	if not boss then
		return nil
	end
	local root = boss:FindFirstChild("HumanoidRootPart")
	if root and root:IsA("BasePart") then
		return root
	end
	return nil
end

-- Per-player noise memory: score decays linearly to 0 over TargetMemorySeconds.
local noiseScore: { [Player]: { score: number, t: number } } = {}

local function currentScore(entry: { score: number, t: number }, now: number): number
	local age = now - entry.t
	return math.max(0, entry.score * (1 - age / BossConfig.TargetMemorySeconds))
end

local function playerRoot(player: Player): BasePart?
	local char = player.Character
	if not char then
		return nil
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if hum and hum.Health > 0 and root and root:IsA("BasePart") then
		return root
	end
	return nil
end

local function chooseTarget(): Player?
	local now = os.clock()
	local best: Player? = nil
	local bestScore = 0
	for player, entry in noiseScore do
		if player.Parent == Players and playerRoot(player) then
			local s = currentScore(entry, now)
			if s > bestScore then
				best, bestScore = player, s
			end
		end
	end
	if best then
		return best
	end
	-- Fallback (e.g. noise with no player): nearest living player.
	local bossRoot = getBossRoot(getBoss())
	if not bossRoot then
		return nil
	end
	local nearest: Player? = nil
	local nearestDist = math.huge
	for _, player in Players:GetPlayers() do
		local root = playerRoot(player)
		if root then
			local d = (root.Position - bossRoot.Position).Magnitude
			if d < nearestDist then
				nearest, nearestDist = player, d
			end
		end
	end
	return nearest
end

-- Broadcast throttling
local lastBroadcastAlertness = -1
local lastBroadcastTime = 0

local function publishAlertness(force: boolean)
	local now = os.clock()
	if
		force
		or (
			math.abs(alertness - lastBroadcastAlertness) >= BossConfig.AlertnessBroadcastEpsilon
			and now - lastBroadcastTime >= BossConfig.AlertnessBroadcastInterval
		)
	then
		workspace:SetAttribute("BossAlertness", alertness) -- throttled with the broadcast
		lastBroadcastAlertness = alertness
		lastBroadcastTime = now
		wakeRemote:FireAllClients(state, alertness)
	end
end

local function setState(newState: string, newTarget: Player?)
	if newState == state and newTarget == target then
		return
	end
	state = newState
	target = newTarget
	stateSince = os.clock()
	if newState == "Awake" then
		alertness = 1
	elseif newState == "Returning" then
		alertness = math.min(alertness, BossConfig.ReturnAlertness)
	elseif newState == "Asleep" then
		alertness = math.min(alertness, BossConfig.AsleepThreshold)
	end
	workspace:SetAttribute("BossState", state)
	publishAlertness(true)
	ServerBus.fire("BossStateChanged", state, target)
end

-- Counters written by BossAI; we only react to increases.
local seenChaseOver = 0
local seenReturnDone = 0
local lastBoss: Model? = nil

local function readCounter(boss: Model?, attr: string): number
	if boss then
		local v = boss:GetAttribute(attr)
		if typeof(v) == "number" then
			return v
		end
	end
	return 0
end

local function evaluate()
	local boss = getBoss()
	if not boss then
		if state ~= "Asleep" then
			setState("Asleep", nil)
		end
		return
	end

	if boss ~= lastBoss then
		-- New/respawned boss model: its counters restart, so resync instead of
		-- waiting for the watchdog.
		lastBoss = boss
		seenChaseOver = readCounter(boss, BossConfig.ChaseOverAttribute)
		seenReturnDone = readCounter(boss, BossConfig.ReturnDoneAttribute)
	end

	local chaseOver = readCounter(boss, BossConfig.ChaseOverAttribute)
	local returnDone = readCounter(boss, BossConfig.ReturnDoneAttribute)
	local chaseOverNew = chaseOver > seenChaseOver
	local returnDoneNew = returnDone > seenReturnDone
	seenChaseOver, seenReturnDone = chaseOver, returnDone

	if state == "Asleep" then
		if alertness >= BossConfig.StirringThreshold then
			setState("Stirring", nil)
		end
	end
	if state == "Stirring" or state == "Returning" then
		if alertness >= BossConfig.AwakeThreshold then
			local t = chooseTarget()
			if t then
				setState("Awake", t)
			else
				alertness = BossConfig.AwakeThreshold - 0.01 -- nobody to chase
			end
		end
	end
	local inState = os.clock() - stateSince
	local margin = BossConfig.WatchdogMarginSeconds
	if state == "Stirring" and alertness <= BossConfig.AsleepThreshold then
		setState("Asleep", nil)
	elseif
		state == "Awake"
		and (chaseOverNew or inState > BossConfig.MaxChaseSeconds + BossConfig.CatchPauseSeconds + margin)
	then
		-- watchdog: BossAI never reported the chase over (dead boss, missing script...)
		setState("Returning", nil)
	elseif
		state == "Returning"
		and (returnDoneNew or inState > BossConfig.ReturnTimeoutSeconds + margin)
	then
		alertness = 0
		setState("Asleep", nil)
	end
end

ServerBus.connect("NoiseEmitted", function(player: any, position: any, loudness: any, _source: any)
	if typeof(position) ~= "Vector3" or type(loudness) ~= "number" or loudness <= 0 then
		return
	end
	local bossRoot = getBossRoot(getBoss())
	if not bossRoot then
		if not warnedNoBoss then
			warnedNoBoss = true
			warn("[BossWakeStateMachine] no BossNPC model; ignoring noise")
		end
		return
	end
	local dist = (bossRoot.Position - position).Magnitude
	local maxRange = loudness * BossConfig.HearingMaxMultiplier
	if dist > maxRange then
		return
	end
	local falloff = 1
	if dist > loudness and maxRange > loudness then
		falloff = 1 - (dist - loudness) / (maxRange - loudness)
	end
	local gain = BossConfig.GainPerLoudnessStud * loudness * falloff
	if gain <= 0 then
		return
	end

	if player ~= nil and typeof(player) == "Instance" and player:IsA("Player") then
		local now = os.clock()
		local entry = noiseScore[player]
		local prev = entry and currentScore(entry, now) or 0
		noiseScore[player] = { score = prev + gain, t = now }
	end

	if state ~= "Awake" then
		alertness = math.min(1, alertness + gain)
		evaluate()
		publishAlertness(false)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	noiseScore[player] = nil
	if target == player then
		target = nil -- BossAI notices the departed target and ends the chase
	end
end)

workspace:SetAttribute("BossState", state)
workspace:SetAttribute("BossAlertness", alertness)

task.spawn(function()
	local interval = 1 / math.min(BossConfig.StateTickRate, 10)
	local last = os.clock()
	while true do
		task.wait(interval)
		local now = os.clock()
		local dt = now - last
		last = now
		if state ~= "Awake" and alertness > 0 then
			alertness = math.max(0, alertness - BossConfig.DecayPerSecond * dt)
		end
		for player, entry in noiseScore do
			if currentScore(entry, now) <= 0 then
				noiseScore[player] = nil
			end
		end
		evaluate()
		publishAlertness(false)
	end
end)
