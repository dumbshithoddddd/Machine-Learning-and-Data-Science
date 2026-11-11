--!strict
-- BranchSnapController (cosmetic + sneak input).
-- Input: LeftControl / C / mobile button toggles sneak by firing SneakToggleRequest
-- (the server validates and owns IsSneaking). DetectionRingController has no input.
-- Cosmetics: snap sound / particles / camera nudge on NoiseEmitResponse "Branch",
-- and reflects the server's `Snapped` attribute on Branch parts.

local CollectionService = game:GetService("CollectionService")
local ContextActionService = game:GetService("ContextActionService")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Remotes = require(ReplicatedStorage:WaitForChild("Remotes"))
local SneakConfig = require(ReplicatedStorage:WaitForChild("SneakConfig"))

local player = Players.LocalPlayer
local toggleRemote = Remotes.get("SneakToggleRequest")
local noiseRemote = Remotes.get("NoiseEmitResponse")

-- Sneak input ------------------------------------------------------------------

local ACTION = "SneakToggle"
local lastSent = 0

local function onSneakAction(_name: string, state: Enum.UserInputState, _input: InputObject): Enum.ContextActionResult
	if state ~= Enum.UserInputState.Begin then
		return Enum.ContextActionResult.Pass
	end
	local now = os.clock()
	if now - lastSent < SneakConfig.ToggleMinInterval then
		return Enum.ContextActionResult.Sink
	end
	lastSent = now
	toggleRemote:FireServer(player:GetAttribute("IsSneaking") ~= true)
	return Enum.ContextActionResult.Sink
end

ContextActionService:BindAction(ACTION, onSneakAction, true, Enum.KeyCode.LeftControl, Enum.KeyCode.C)
ContextActionService:SetTitle(ACTION, "Sneak")
ContextActionService:SetPosition(ACTION, UDim2.new(1, -150, 1, -190))

-- Branch visuals (Snapped attribute) ---------------------------------------------

local originalTransparency: { [BasePart]: number } = {}
local snappedConns: { [BasePart]: RBXScriptConnection } = {}

local function reflect(part: BasePart)
	local base = originalTransparency[part]
	if base == nil then
		return
	end
	if part:GetAttribute("Snapped") == true then
		part.Transparency = math.max(base, SneakConfig.SnappedTransparency)
	else
		part.Transparency = base
	end
end

local function trackBranch(instance: Instance)
	if not instance:IsA("BasePart") or snappedConns[instance] then
		return
	end
	originalTransparency[instance] = instance.Transparency
	snappedConns[instance] = instance:GetAttributeChangedSignal("Snapped"):Connect(function()
		reflect(instance)
	end)
	reflect(instance)
end

local function untrackBranch(instance: Instance)
	if not instance:IsA("BasePart") then
		return
	end
	local conn = snappedConns[instance]
	if conn then
		conn:Disconnect()
		snappedConns[instance] = nil
	end
	originalTransparency[instance] = nil
end

CollectionService:GetInstanceAddedSignal("Branch"):Connect(trackBranch)
CollectionService:GetInstanceRemovedSignal("Branch"):Connect(untrackBranch)
for _, inst in CollectionService:GetTagged("Branch") do
	trackBranch(inst)
end

-- Snap effects ---------------------------------------------------------------------

local nudging = false

local function cameraNudge(position: Vector3)
	if nudging then
		return
	end
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not humanoid or not root or not root:IsA("BasePart") then
		return
	end
	local dist = (root.Position - position).Magnitude
	if dist > SneakConfig.SnapCameraNudgeRange then
		return
	end
	nudging = true
	local strength = SneakConfig.SnapCameraNudge * (1 - dist / SneakConfig.SnapCameraNudgeRange)
	humanoid.CameraOffset = Vector3.new((math.random() - 0.5) * strength, (math.random() - 0.5) * strength, 0)
	local tween = TweenService:Create(humanoid, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { CameraOffset = Vector3.zero })
	tween.Completed:Once(function()
		nudging = false
	end)
	tween:Play()
end

local function playSnap(position: Vector3)
	local anchor = Instance.new("Part")
	anchor.Name = "BranchSnapFx"
	anchor.Anchored = true
	anchor.CanCollide = false
	anchor.CanQuery = false
	anchor.CanTouch = false
	anchor.Transparency = 1
	anchor.Size = Vector3.one
	anchor.Position = position
	anchor.Parent = workspace

	local emitter = Instance.new("ParticleEmitter")
	emitter.Enabled = false
	emitter.Lifetime = NumberRange.new(0.4, 0.8)
	emitter.Speed = NumberRange.new(6, 12)
	emitter.SpreadAngle = Vector2.new(60, 60)
	emitter.Size = NumberSequence.new(0.4, 0)
	emitter.Color = ColorSequence.new(Color3.fromRGB(139, 105, 60))
	emitter.Acceleration = Vector3.new(0, -20, 0)
	emitter.Parent = anchor
	emitter:Emit(14)

	if SneakConfig.SnapSoundId ~= "" then
		local sound = Instance.new("Sound")
		sound.SoundId = SneakConfig.SnapSoundId
		sound.Volume = SneakConfig.SnapSoundVolume
		sound.RollOffMaxDistance = 120
		sound.Parent = anchor
		sound:Play()
	end
	Debris:AddItem(anchor, 2)
end

noiseRemote.OnClientEvent:Connect(function(position: unknown, _loudness: unknown, source: unknown)
	if source ~= "Branch" or typeof(position) ~= "Vector3" then
		return
	end
	playSnap(position)
	cameraNudge(position)
end)
