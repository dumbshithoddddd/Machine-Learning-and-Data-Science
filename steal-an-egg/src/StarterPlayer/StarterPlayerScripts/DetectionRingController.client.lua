--!strict
-- DetectionRingController: purely cosmetic HUD. A ground ring around the local
-- character shows the current noise radius (eased down over time), coloured by
-- boss state, plus a small alertness meter. No detection, no input, no GetTagged.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Remotes = require(ReplicatedStorage:WaitForChild("Remotes"))
local SneakConfig = require(ReplicatedStorage:WaitForChild("SneakConfig"))

local player = Players.LocalPlayer
local noiseRemote = Remotes.get("NoiseEmitResponse")
local bossRemote = Remotes.get("BossWakeResponse")

-- Boss state ------------------------------------------------------------------------

local bossState = "Asleep"
local alertness = 0
local ringColor: Color3 = SneakConfig.RingColors.Asleep

local function setBoss(state: unknown, alert: unknown)
	if typeof(state) == "string" then
		bossState = state
	end
	if typeof(alert) == "number" then
		alertness = math.clamp(alert, 0, 1)
	end
end

setBoss(workspace:GetAttribute("BossState"), workspace:GetAttribute("BossAlertness"))
workspace:GetAttributeChangedSignal("BossState"):Connect(function()
	setBoss(workspace:GetAttribute("BossState"), nil)
end)
workspace:GetAttributeChangedSignal("BossAlertness"):Connect(function()
	setBoss(nil, workspace:GetAttribute("BossAlertness"))
end)
bossRemote.OnClientEvent:Connect(setBoss)

-- HUD meter ---------------------------------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "DetectionHud"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local meterBack = Instance.new("Frame")
meterBack.Name = "AlertMeter"
meterBack.AnchorPoint = Vector2.new(0.5, 0)
meterBack.Position = UDim2.new(0.5, 0, 0, 16)
meterBack.Size = UDim2.fromOffset(200, 12)
meterBack.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
meterBack.BackgroundTransparency = 0.3
meterBack.BorderSizePixel = 0
meterBack.Parent = gui
Instance.new("UICorner").Parent = meterBack

local meterFill = Instance.new("Frame")
meterFill.Name = "Fill"
meterFill.Size = UDim2.fromScale(0, 1)
meterFill.BorderSizePixel = 0
meterFill.BackgroundColor3 = ringColor
meterFill.Parent = meterBack
Instance.new("UICorner").Parent = meterFill

local meterLabel = Instance.new("TextLabel")
meterLabel.BackgroundTransparency = 1
meterLabel.Size = UDim2.new(1, 0, 0, 14)
meterLabel.Position = UDim2.new(0, 0, 1, 2)
meterLabel.Font = Enum.Font.GothamMedium
meterLabel.TextSize = 12
meterLabel.TextColor3 = Color3.new(1, 1, 1)
meterLabel.TextStrokeTransparency = 0.5
meterLabel.Text = "Asleep"
meterLabel.Parent = meterBack

gui.Parent = player:WaitForChild("PlayerGui")

-- Ring ----------------------------------------------------------------------------------

local ring = Instance.new("Part")
ring.Name = "DetectionRing"
ring.Shape = Enum.PartType.Cylinder
ring.Anchored = true
ring.CanCollide = false
ring.CanQuery = false
ring.CanTouch = false
ring.CastShadow = false
ring.Material = Enum.Material.Neon
ring.Transparency = SneakConfig.RingTransparency
ring.Color = ringColor
local minDiameter = SneakConfig.RingMinRadius * 2
ring.Size = Vector3.new(SneakConfig.RingHeight, minDiameter, minDiameter)
-- Cylinder axis is X; roll 90 degrees so it lies flat.
local FLAT = CFrame.Angles(0, 0, math.rad(90))

local rootPart: BasePart? = nil
local footOffset = 3

local function onCharacter(character: Model)
	local humanoid = character:WaitForChild("Humanoid", 10)
	local root = character:WaitForChild("HumanoidRootPart", 10)
	if humanoid and root and humanoid:IsA("Humanoid") and root:IsA("BasePart") and player.Character == character then
		rootPart = root
		footOffset = root.Size.Y / 2 + humanoid.HipHeight - 0.05
		ring.Parent = workspace
	end
end
player.CharacterAdded:Connect(function(character)
	rootPart = nil
	ring.Parent = nil
	onCharacter(character)
end)
player.CharacterRemoving:Connect(function()
	rootPart = nil
	ring.Parent = nil
end)
if player.Character then
	task.spawn(onCharacter, player.Character)
end

-- Noise radius ---------------------------------------------------------------------------

local targetRadius = 0
local holdUntil = 0
local shownRadius = SneakConfig.RingMinRadius

noiseRemote.OnClientEvent:Connect(function(_position: unknown, loudness: unknown, _source: unknown, isOwn: unknown)
	if isOwn ~= true or typeof(loudness) ~= "number" then
		return
	end
	local radius = math.min(loudness, SneakConfig.RingMaxRadius)
	if radius >= targetRadius or os.clock() >= holdUntil then
		targetRadius = radius
		holdUntil = os.clock() + SneakConfig.RingHoldTime
	end
end)

RunService.RenderStepped:Connect(function(dt: number)
	local now = os.clock()
	if now >= holdUntil then
		targetRadius = 0
	end
	local goal = math.max(targetRadius, SneakConfig.RingMinRadius)
	local rate = if goal > shownRadius then SneakConfig.RingRiseRate else SneakConfig.RingFallRate
	shownRadius += (goal - shownRadius) * (1 - math.exp(-rate * dt))

	local color = SneakConfig.RingColors[bossState] or SneakConfig.RingColors.Asleep
	ringColor = ringColor:Lerp(color, math.min(1, dt * 8))

	local root = rootPart
	if root then
		local d = shownRadius * 2
		ring.Size = Vector3.new(SneakConfig.RingHeight, d, d)
		ring.CFrame = CFrame.new(root.Position - Vector3.new(0, footOffset, 0)) * FLAT
		ring.Color = ringColor
	end

	meterFill.Size = UDim2.fromScale(alertness, 1)
	meterFill.BackgroundColor3 = ringColor
	meterLabel.Text = bossState
end)
