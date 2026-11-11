--!strict
-- SneakService: validates SneakToggleRequest, owns IsSneaking, and is the SOLE
-- writer of Humanoid.WalkSpeed (formula fixed by docs/CONTRACT.md).

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage:WaitForChild("Remotes"))
local SneakConfig = require(ReplicatedStorage:WaitForChild("SneakConfig"))

local toggleRemote = Remotes.get("SneakToggleRequest")

-- Required up front so WalkSpeed is never computed with a missing carry multiplier.
local eggConfigCache: any = nil
do
	local module = ReplicatedStorage:WaitForChild("EggConfig", 10)
	if module and module:IsA("ModuleScript") then
		local ok, result = pcall(require, module)
		if ok then
			eggConfigCache = result
		else
			warn("SneakService: EggConfig failed to load: " .. tostring(result))
		end
	else
		warn("SneakService: EggConfig not found; carry speed multiplier ignored")
	end
end
local function getEggConfig(): any
	return eggConfigCache
end

local function computeWalkSpeed(player: Player): number
	local bonus = player:GetAttribute("SpeedBonus")
	if typeof(bonus) ~= "number" then
		bonus = 0
	end
	local speed = SneakConfig.BaseWalkSpeed + bonus
	if player:GetAttribute("IsSneaking") == true then
		speed *= SneakConfig.SneakSpeedMultiplier
	end
	local carrying = player:GetAttribute("CarryingEgg")
	if typeof(carrying) == "string" then
		local cfg = getEggConfig()
		local entry = cfg and cfg.Eggs and cfg.Eggs[carrying]
		local mult = entry and entry.CarrySpeedMultiplier
		if typeof(mult) == "number" then
			speed *= mult
		end
	end
	return math.max(speed, 0)
end

local lastToggle: { [Player]: number } = {}
local playerConns: { [Player]: { RBXScriptConnection } } = {}

local function applySpeed(player: Player)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = computeWalkSpeed(player)
	end
end

local function setupPlayer(player: Player)
	if playerConns[player] then
		return
	end
	if player:GetAttribute("IsSneaking") == nil then
		player:SetAttribute("IsSneaking", false)
	end
	local conns: { RBXScriptConnection } = {}
	playerConns[player] = conns

	for _, name in { "SpeedBonus", "IsSneaking", "CarryingEgg" } do
		table.insert(
			conns,
			player:GetAttributeChangedSignal(name):Connect(function()
				applySpeed(player)
			end)
		)
	end

	local function onCharacter(character: Model)
		player:SetAttribute("IsSneaking", false)
		local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 10)
		if humanoid and humanoid:IsA("Humanoid") and player.Character == character then
			humanoid.WalkSpeed = computeWalkSpeed(player)
		end
	end
	table.insert(conns, player.CharacterAdded:Connect(onCharacter))
	if player.Character then
		task.spawn(onCharacter, player.Character)
	end
end

local function cleanupPlayer(player: Player)
	lastToggle[player] = nil
	local conns = playerConns[player]
	if conns then
		for _, c in conns do
			c:Disconnect()
		end
		playerConns[player] = nil
	end
end

toggleRemote.OnServerEvent:Connect(function(player: Player, wantSneak: unknown)
	if typeof(wantSneak) ~= "boolean" then
		return
	end
	local now = os.clock()
	local last = lastToggle[player]
	if last and now - last < SneakConfig.ToggleMinInterval then
		return
	end
	lastToggle[player] = now
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return
	end
	if player:GetAttribute("IsSneaking") ~= wantSneak then
		player:SetAttribute("IsSneaking", wantSneak)
	end
end)

Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(cleanupPlayer)
for _, player in Players:GetPlayers() do
	setupPlayer(player)
end
