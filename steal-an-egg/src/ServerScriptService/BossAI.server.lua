--!strict
-- BossAI: drives the BossNPC model with PathfindingService.
-- Modes: Idle (asleep on BossNest) / Patrol (Stirring, BossWaypoints by Order) /
-- Chase (Awake) / Return (Returning, back to BossNest) / Hold (chase over,
-- waiting for BossWakeStateMachine to say Returning).
-- Mode is chosen by ServerBus "BossStateChanged". When a chase ends or the
-- boss reaches the nest it increments counter attributes on the boss model
-- (BossConfig.ChaseOverAttribute / ReturnDoneAttribute) for BossWakeStateMachine.
-- Exactly one BossNPC model is supported (the first live tagged one is bound).
-- Single fixed-rate loop (AITickRate), no per-frame work.
-- Waypoint advance is polled (horizontal distance <= WaypointReachDistance) and
-- MoveTo is re-issued every tick, so Humanoid's ~8 s MoveTo timeout never matters;
-- WaypointTimeout replaces the reference's MoveToFinished/timeout retry.

local CollectionService = game:GetService("CollectionService")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local BossConfig = require(ReplicatedStorage:WaitForChild("BossConfig"))
local ServerBus = require(ServerScriptService:WaitForChild("ServerBus"))

-- ===== Tag tracking (read once, then signals) =====
local bossModels: { Model } = {}
local nests: { BasePart } = {}
local waypointParts: { BasePart } = {}

local function track(tag: string, list: { Instance }, onChange: (() -> ())?)
	local function add(inst: Instance)
		if not table.find(list, inst) then
			table.insert(list, inst)
		end
		if onChange then
			onChange()
		end
	end
	for _, inst in CollectionService:GetTagged(tag) do
		add(inst)
	end
	CollectionService:GetInstanceAddedSignal(tag):Connect(add)
	CollectionService:GetInstanceRemovedSignal(tag):Connect(function(inst)
		local i = table.find(list, inst)
		if i then
			table.remove(list, i)
		end
	end)
end
track("BossNPC", bossModels :: { any }, nil)
track("BossNest", nests :: { any }, nil)
track("BossWaypoint", waypointParts :: { any }, nil)

local function sortedWaypoints(): { BasePart }
	local out: { BasePart } = {}
	for _, p in waypointParts do
		if p.Parent then
			table.insert(out, p)
		end
	end
	table.sort(out, function(a, b)
		local ao = a:GetAttribute("Order")
		local bo = b:GetAttribute("Order")
		return (type(ao) == "number" and ao or 0) < (type(bo) == "number" and bo or 0)
	end)
	return out
end

local function getNest(): BasePart?
	for _, n in nests do
		if n.Parent then
			return n
		end
	end
	return nil
end

-- ===== Bound boss =====
local boss: Model? = nil
local humanoid: Humanoid? = nil
local root: BasePart? = nil
local path: Path? = nil
local blockedConn: RBXScriptConnection? = nil
local warned: { [string]: boolean } = {}

local function warnOnce(key: string, msg: string)
	if not warned[key] then
		warned[key] = true
		warn("[BossAI] " .. msg)
	end
end

-- Path-following state
local mode = "Idle"
local modeVersion = 0
local target: Player? = nil
local waypoints: { PathWaypoint } = {}
local wpIndex = 1
local wpSince = 0
local lastCompute = -math.huge
local lastDest: Vector3? = nil
local needRecompute = true
local currentWaypointTarget = 1 -- patrol index
local lostTime = 0
local chaseStart = 0
local returnStart = 0
local stopped = false
local chaseOverAt: number? = nil

local function unbindBoss()
	if blockedConn then
		blockedConn:Disconnect()
		blockedConn = nil
	end
	if path then
		path:Destroy()
		path = nil
	end
	boss, humanoid, root = nil, nil, nil
end

local jumpedIndex = 0 -- waypoint index whose Jump was already issued
local applyModeSpeed: () -> () -- defined below; bindBoss applies the current mode's speed

local function bindBoss(model: Model): boolean
	local hum = model:FindFirstChildOfClass("Humanoid")
	local hrp = model:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp or not hrp:IsA("BasePart") then
		warnOnce("badboss", "BossNPC model needs a Humanoid and HumanoidRootPart")
		return false
	end
	unbindBoss()
	boss, humanoid, root = model, hum, hrp
	pcall(function()
		hrp:SetNetworkOwner(nil)
	end)
	local p = PathfindingService:CreatePath(BossConfig.AgentParameters)
	path = p
	blockedConn = p.Blocked:Connect(function(blockedIdx: number)
		if blockedIdx >= wpIndex then
			needRecompute = true
		end
	end)
	applyModeSpeed()
	return true
end

local function resetPath()
	waypoints = {}
	wpIndex = 1
	jumpedIndex = 0
	lastDest = nil
	needRecompute = true
	wpSince = os.clock()
end

local function stopMoving()
	if humanoid and root then
		humanoid:MoveTo(root.Position)
	end
end

function applyModeSpeed()
	if humanoid then
		if mode == "Chase" then
			humanoid.WalkSpeed = BossConfig.ChaseSpeed
		elseif mode == "Patrol" then
			humanoid.WalkSpeed = BossConfig.PatrolSpeed
		elseif mode == "Return" then
			humanoid.WalkSpeed = BossConfig.ReturnSpeed
		end
	end
end

local function setMode(newMode: string, newTarget: Player?)
	modeVersion += 1
	mode = newMode
	target = newTarget
	resetPath()
	lostTime = 0
	stopped = false
	chaseOverAt = nil
	if newMode == "Chase" then
		chaseStart = os.clock()
	elseif newMode == "Return" then
		returnStart = os.clock()
	end
	applyModeSpeed()
end

local function bump(attr: string)
	if boss then
		local v = boss:GetAttribute(attr)
		boss:SetAttribute(attr, (type(v) == "number" and v or 0) + 1)
	end
end

local function horizontalDist(a: Vector3, b: Vector3): number
	return Vector3.new(a.X - b.X, 0, a.Z - b.Z).Magnitude
end

-- ===== Pathing =====
local function compute(dest: Vector3): boolean
	local p, r = path, root
	if not p or not r then
		return false
	end
	local version = modeVersion
	local bossAtStart = boss
	lastCompute = os.clock()
	lastDest = dest
	local ok = pcall(function()
		p:ComputeAsync(r.Position, dest)
	end)
	if version ~= modeVersion or bossAtStart ~= boss then
		return false -- state changed while ComputeAsync yielded
	end
	if ok and p.Status == Enum.PathStatus.Success then
		waypoints = p:GetWaypoints()
		wpIndex = #waypoints > 1 and 2 or 1
		jumpedIndex = 0
		wpSince = os.clock()
		needRecompute = false
		return true
	end
	waypoints = {}
	wpIndex = 1
	return false
end

-- Moves toward the next waypoint. Returns true when the path is exhausted.
local function stepPath(): boolean
	local hum, r = humanoid, root
	if not hum or not r or wpIndex > #waypoints then
		return true
	end
	local wp = waypoints[wpIndex]
	if horizontalDist(wp.Position, r.Position) <= BossConfig.WaypointReachDistance then
		wpIndex += 1
		wpSince = os.clock()
		if wpIndex > #waypoints then
			return true
		end
		wp = waypoints[wpIndex]
	elseif os.clock() - wpSince > BossConfig.WaypointTimeout then
		needRecompute = true
		wpSince = os.clock()
	end
	if wp.Action == Enum.PathWaypointAction.Jump and jumpedIndex ~= wpIndex then
		-- Same as the reference NPCPathFollower: Jump waypoints trigger a jump state (once).
		jumpedIndex = wpIndex
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end
	hum:MoveTo(wp.Position)
	return false
end

local function goTo(dest: Vector3)
	local hum, r = humanoid, root
	if not hum or not r then
		return
	end
	local now = os.clock()
	local moved = lastDest == nil or (dest - lastDest).Magnitude > BossConfig.RecomputeMinTargetMove
	local stale = needRecompute or #waypoints == 0 or moved
	if stale and now - lastCompute >= BossConfig.PathRecomputeInterval then
		local version = modeVersion
		if not compute(dest) then
			needRecompute = true
		end
		if version ~= modeVersion then
			return -- mode changed while ComputeAsync yielded: no stale MoveTo
		end
	end
	if #waypoints > 0 then
		if stepPath() then
			hum:MoveTo(dest)
			needRecompute = horizontalDist(dest, r.Position) > BossConfig.WaypointReachDistance
		end
	else
		hum:MoveTo(dest) -- no path (yet): walk straight, retried on next interval
	end
end

-- ===== Behaviours =====
local function targetRoot(player: Player?): (BasePart?, Humanoid?)
	if not player or player.Parent ~= Players then
		return nil, nil
	end
	local char = player.Character
	if not char then
		return nil, nil
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hum and hum.Health > 0 and hrp and hrp:IsA("BasePart") then
		return hrp, hum
	end
	return nil, nil
end

local function endChase()
	if mode ~= "Chase" then
		return
	end
	setMode("Hold", nil)
	stopMoving()
	chaseOverAt = os.clock() -- signal BossWakeStateMachine on the next Hold tick
end

local function tickChase(now: number)
	local r = root
	if not r then
		return
	end
	local tRoot, tHum = targetRoot(target)
	if not tRoot or not tHum then
		endChase() -- target died or left
		return
	end
	local dist = (tRoot.Position - r.Position).Magnitude
	if dist <= BossConfig.CatchRadius then
		local caught = target :: Player
		ServerBus.fire("PlayerCaught", caught)
		tHum.Health = 0
		setMode("Hold", nil)
		stopMoving()
		chaseOverAt = now + BossConfig.CatchPauseSeconds
		return
	end
	if dist > BossConfig.LoseDistance then
		if lostTime == 0 then
			lostTime = now -- timestamp when the target first went out of range
		end
		if now - lostTime >= BossConfig.LoseTimeSeconds then
			endChase()
			return
		end
	else
		lostTime = 0
	end
	if now - chaseStart > BossConfig.MaxChaseSeconds then
		endChase()
		return
	end
	goTo(tRoot.Position)
end

local patrolList: { BasePart } = {}

local function tickPatrol()
	local r = root
	if not r then
		return
	end
	if #patrolList == 0 then
		patrolList = sortedWaypoints()
		if #patrolList == 0 then
			warnOnce("nowaypoints", "no BossWaypoint instances; boss will stay still while Stirring")
			if not stopped then
				stopped = true
				stopMoving()
			end
			return
		end
	end
	if currentWaypointTarget > #patrolList then
		currentWaypointTarget = 1
	end
	local part = patrolList[currentWaypointTarget]
	if not part.Parent then
		patrolList = {}
		return
	end
	if horizontalDist(part.Position, r.Position) <= BossConfig.PatrolReachDistance then
		currentWaypointTarget = currentWaypointTarget % #patrolList + 1
		resetPath()
		return
	end
	goTo(part.Position)
end

local function tickReturn(now: number)
	local r = root
	if not r then
		return
	end
	local nest = getNest()
	if not nest then
		warnOnce("nonest", "no BossNest instance; boss stays where it is")
		setMode("Idle", nil)
		bump(BossConfig.ReturnDoneAttribute)
		return
	end
	if horizontalDist(nest.Position, r.Position) <= BossConfig.NestArrivalDistance then
		setMode("Idle", nil)
		stopMoving()
		bump(BossConfig.ReturnDoneAttribute)
		return
	end
	if now - returnStart > BossConfig.ReturnTimeoutSeconds and boss then
		boss:PivotTo(nest.CFrame + Vector3.new(0, 3, 0)) -- stuck: snap home
		return
	end
	goTo(nest.Position)
end

local function applyBossState(state: string, newTarget: Player?)
	if state == "Awake" then
		setMode("Chase", newTarget)
	elseif state == "Returning" then
		setMode("Return", nil)
	elseif state == "Stirring" then
		if BossConfig.PatrolWhileStirring then
			patrolList = {}
			setMode("Patrol", nil)
		else
			setMode("Idle", nil)
		end
	else -- Asleep
		local nest, r = getNest(), root
		if nest and r and horizontalDist(nest.Position, r.Position) > BossConfig.NestArrivalDistance then
			setMode("Return", nil) -- walk home quietly; Wake SM ignores the done counter
		else
			setMode("Idle", nil)
		end
	end
end

ServerBus.connect("BossStateChanged", function(state: any, newTarget: any)
	if type(state) ~= "string" then
		return
	end
	local t: Player? = nil
	if typeof(newTarget) == "Instance" and newTarget:IsA("Player") then
		t = newTarget
	end
	applyBossState(state, t)
end)

-- Load-order race: BossWakeStateMachine may already have left Asleep before we
-- connected. The target is unknown here; a Chase with no target ends at once
-- and the wake SM's watchdog / counters take it from there.
do
	local current = workspace:GetAttribute("BossState")
	if type(current) == "string" and current ~= "Asleep" then
		applyBossState(current, nil)
	end
end

Players.PlayerRemoving:Connect(function(player)
	if target == player then
		target = nil -- tickChase sees no valid target next tick and ends the chase
	end
end)

-- ===== Main loop =====
task.spawn(function()
	local interval = 1 / math.min(BossConfig.AITickRate, 10)
	while true do
		task.wait(interval)
		local now = os.clock()

		-- (Re)bind boss if needed
		if boss and (boss.Parent == nil or not humanoid or humanoid.Parent == nil or not root or root.Parent == nil) then
			unbindBoss()
			resetPath()
		end
		if not boss then
			local candidate = nil
			local sawDead = false
			for _, m in bossModels do
				local mh = m:FindFirstChildOfClass("Humanoid")
				if m.Parent and mh and mh.Health > 0 then -- never bind a dead boss
					candidate = m
					break
				elseif m.Parent then
					sawDead = true
				end
			end
			if candidate then
				bindBoss(candidate)
			elseif sawDead then
				warnOnce("deadboss", "BossNPC is dead (or has no Humanoid); idling until a live one appears")
			else
				warnOnce("noboss", "no BossNPC model tagged; idling")
			end
		end

		if boss and humanoid and root then
			if humanoid.Health <= 0 then
				-- boss itself died: nothing sensible to do until respawned/rebound
				unbindBoss()
			elseif mode == "Chase" then
				tickChase(now)
			elseif mode == "Patrol" then
				tickPatrol()
			elseif mode == "Return" then
				tickReturn(now)
			elseif mode == "Hold" then
				if chaseOverAt and now >= chaseOverAt then
					chaseOverAt = nil
					bump(BossConfig.ChaseOverAttribute)
				end
			elseif not stopped then
				stopped = true
				stopMoving()
			end
		end
	end
end)
