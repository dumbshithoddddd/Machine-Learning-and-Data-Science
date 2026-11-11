--!strict
-- SpinClient: minimal code-built wheel GUI. No reward logic: it asks the
-- server to spin and animates to the slotIndex the server returns.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Remotes = require(ReplicatedStorage.Remotes)
local SpinConfig = require(ReplicatedStorage.SpinConfig)

local player = Players.LocalPlayer
local SpinRequest = Remotes.get("SpinRequest")
local SpinResponse = Remotes.get("SpinResponse")
local SpinOpenResponse = Remotes.get("SpinOpenResponse")

local slots = SpinConfig.Slots
local slotCount = #slots
local WHEEL_SIZE = 280
local NEXT_FREE_ATTR = SpinConfig.NextFreeSpinAttribute

local gui = Instance.new("ScreenGui")
gui.Name = "SpinGui"
gui.ResetOnSpawn = false
gui.Enabled = false
gui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.fromScale(0.5, 0.5)
panel.Size = UDim2.fromOffset(340, 460)
panel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
panel.Parent = gui
Instance.new("UICorner").Parent = panel

local info = Instance.new("TextLabel")
info.BackgroundTransparency = 1
info.Position = UDim2.fromOffset(10, 8)
info.Size = UDim2.new(1, -20, 0, 40)
info.TextColor3 = Color3.new(1, 1, 1)
info.TextScaled = true
info.Font = Enum.Font.GothamBold
info.Text = ""
info.Parent = panel

local wheelHolder = Instance.new("Frame")
wheelHolder.AnchorPoint = Vector2.new(0.5, 0)
wheelHolder.Position = UDim2.new(0.5, 0, 0, 60)
wheelHolder.Size = UDim2.fromOffset(WHEEL_SIZE, WHEEL_SIZE)
wheelHolder.BackgroundTransparency = 1
wheelHolder.Parent = panel

local wheel = Instance.new("Frame")
wheel.Size = UDim2.fromScale(1, 1)
wheel.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
wheel.Parent = wheelHolder
local wheelCorner = Instance.new("UICorner")
wheelCorner.CornerRadius = UDim.new(0.5, 0)
wheelCorner.Parent = wheel

-- Slot i's centre sits at angle (i - 0.5) * 360/n clockwise from the top.
local step = 360 / math.max(slotCount, 1)
for i, slot in ipairs(slots) do
	local angle = math.rad((i - 0.5) * step)
	local radius = WHEEL_SIZE * 0.34
	local label = Instance.new("TextLabel")
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Position = UDim2.new(0.5, math.sin(angle) * radius, 0.5, -math.cos(angle) * radius)
	label.Size = UDim2.fromOffset(70, 28)
	label.Rotation = (i - 0.5) * step
	label.BackgroundColor3 = if i % 2 == 0 then Color3.fromRGB(90, 70, 140) else Color3.fromRGB(60, 110, 150)
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextScaled = true
	label.Font = Enum.Font.Gotham
	label.Text = slot.Label
	label.Parent = wheel
end

local pointer = Instance.new("TextLabel")
pointer.AnchorPoint = Vector2.new(0.5, 0.5)
pointer.Position = UDim2.new(0.5, 0, 0, 0)
pointer.Size = UDim2.fromOffset(30, 30)
pointer.BackgroundTransparency = 1
pointer.Text = "V"
pointer.TextColor3 = Color3.fromRGB(255, 80, 80)
pointer.TextScaled = true
pointer.Font = Enum.Font.GothamBlack
pointer.ZIndex = 5
pointer.Parent = wheelHolder

local result = Instance.new("TextLabel")
result.BackgroundTransparency = 1
result.Position = UDim2.new(0, 10, 0, 350)
result.Size = UDim2.new(1, -20, 0, 30)
result.TextColor3 = Color3.fromRGB(255, 220, 90)
result.TextScaled = true
result.Font = Enum.Font.GothamBold
result.Text = ""
result.Parent = panel

local spinButton = Instance.new("TextButton")
spinButton.Position = UDim2.new(0.5, -80, 0, 392)
spinButton.Size = UDim2.fromOffset(160, 44)
spinButton.BackgroundColor3 = Color3.fromRGB(70, 170, 90)
spinButton.TextColor3 = Color3.new(1, 1, 1)
spinButton.TextScaled = true
spinButton.Font = Enum.Font.GothamBold
spinButton.Text = "SPIN"
spinButton.Parent = panel

local closeButton = Instance.new("TextButton")
closeButton.Position = UDim2.new(1, -34, 0, 6)
closeButton.Size = UDim2.fromOffset(28, 28)
closeButton.BackgroundColor3 = Color3.fromRGB(170, 60, 60)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = panel

local spinning = false

local function refreshInfo()
	local spins = player:GetAttribute("Spins")
	local spinCount = if type(spins) == "number" then spins else 0
	local nextFree = player:GetAttribute(NEXT_FREE_ATTR)
	local remaining = (if type(nextFree) == "number" then nextFree else 0) - os.time()
	local freeText = if remaining <= 0 then "Free spin ready!" else string.format("Free spin in %d:%02d", remaining // 60, remaining % 60)
	info.Text = string.format("%s  |  Spins: %d", freeText, spinCount)
end

local function setSpinning(value: boolean)
	spinning = value
	spinButton.Text = if value then "..." else "SPIN"
	spinButton.AutoButtonColor = not value
end

spinButton.Activated:Connect(function()
	if spinning then
		return
	end
	setSpinning(true) -- cosmetic; the server enforces the real lock
	result.Text = ""
	SpinRequest:FireServer()
	-- The server may drop throttled rejections; unstick the button if nothing arrives.
	task.delay(2, function()
		if spinning and wheel:GetAttribute("Animating") ~= true then
			setSpinning(false)
		end
	end)
end)

SpinResponse.OnClientEvent:Connect(function(success: boolean, slotIndex: number?, message: string?)
	if not success or type(slotIndex) ~= "number" or slotIndex < 1 or slotIndex > slotCount then
		result.Text = message or "Spin failed"
		setSpinning(false)
		return
	end
	-- Rotating the wheel by R clockwise moves slot centre c to c + R; we need
	-- (c + R) mod 360 == 0, so R = -c (mod 360), plus several full turns.
	local centre = (slotIndex - 0.5) * step
	local current = wheel.Rotation
	local base = math.floor(current / 360) * 360
	local target = base + 360 * 6 + (360 - centre)
	if target <= current + 360 * 3 then
		target += 360
	end
	local tween = TweenService:Create(
		wheel,
		TweenInfo.new(SpinConfig.SpinDuration - 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{ Rotation = target }
	)
	wheel:SetAttribute("Animating", true)
	tween.Completed:Connect(function()
		wheel:SetAttribute("Animating", false)
		result.Text = message or ""
		setSpinning(false)
	end)
	tween:Play()
end)

closeButton.Activated:Connect(function()
	gui.Enabled = false
end)

SpinOpenResponse.OnClientEvent:Connect(function()
	gui.Enabled = true
	refreshInfo()
end)

-- Countdown display only (1 Hz, while open).
task.spawn(function()
	while true do
		if gui.Enabled then
			refreshInfo()
		end
		task.wait(1)
	end
end)
