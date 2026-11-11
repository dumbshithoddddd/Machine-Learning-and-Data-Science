--!strict
-- EggHatchClient: minimal code-built GUI. Shows inventory, requests hatches,
-- animates the reveal. All roll/reward logic is on the server.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Remotes = require(ReplicatedStorage:WaitForChild("Remotes"))
local EggConfig = require(ReplicatedStorage:WaitForChild("EggConfig"))

local hatchRequest = Remotes.get("HatchEggRequest")
local hatchResponse = Remotes.get("HatchEggResponse")
local inventoryRequest = Remotes.get("EggInventoryRequest")
local inventoryResponse = Remotes.get("EggInventoryResponse")

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "EggHatchGui"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local panel = Instance.new("Frame")
panel.AnchorPoint = Vector2.new(0, 0.5)
panel.Position = UDim2.new(0, 12, 0.5, 0)
panel.Size = UDim2.fromOffset(220, 0)
panel.AutomaticSize = Enum.AutomaticSize.Y
panel.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
panel.BackgroundTransparency = 0.15
panel.Parent = gui
Instance.new("UICorner").Parent = panel
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.Name
layout.Parent = panel
local pad = Instance.new("UIPadding")
pad.PaddingTop, pad.PaddingBottom = UDim.new(0, 8), UDim.new(0, 8)
pad.PaddingLeft, pad.PaddingRight = UDim.new(0, 8), UDim.new(0, 8)
pad.Parent = panel

local countLabels: { [string]: TextLabel } = {}
local hatchButtons: { [string]: TextButton } = {}

local names: { string } = {}
for eggType in EggConfig.Eggs do
	table.insert(names, eggType)
end
table.sort(names)

for _, eggType in names do
	local def = EggConfig.Eggs[eggType]
	local row = Instance.new("Frame")
	row.Name = eggType
	row.Size = UDim2.new(1, 0, 0, 30)
	row.BackgroundTransparency = 1
	row.Parent = panel

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -80, 1, 0)
	label.BackgroundTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 14
	label.Text = def.DisplayName .. " x0"
	label.Parent = row
	countLabels[eggType] = label

	local button = Instance.new("TextButton")
	button.AnchorPoint = Vector2.new(1, 0)
	button.Position = UDim2.new(1, 0, 0, 0)
	button.Size = UDim2.new(0, 72, 1, 0)
	button.BackgroundColor3 = Color3.fromRGB(80, 170, 90)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.Text = "Hatch"
	button.Parent = row
	Instance.new("UICorner").Parent = button
	hatchButtons[eggType] = button

	button.Activated:Connect(function()
		hatchRequest:FireServer(eggType)
	end)
end

-- Reveal popup
local reveal = Instance.new("TextLabel")
reveal.AnchorPoint = Vector2.new(0.5, 0.5)
reveal.Position = UDim2.fromScale(0.5, 0.4)
reveal.Size = UDim2.fromOffset(0, 0)
reveal.BackgroundColor3 = Color3.fromRGB(255, 240, 190)
reveal.TextColor3 = Color3.fromRGB(40, 30, 10)
reveal.Font = Enum.Font.GothamBlack
reveal.TextScaled = true
reveal.Visible = false
reveal.Parent = gui
Instance.new("UICorner").Parent = reveal

local revealToken = 0
local function showReveal(text: string)
	revealToken += 1
	local token = revealToken
	reveal.Text = text
	reveal.Size = UDim2.fromOffset(0, 0)
	reveal.TextTransparency = 0
	reveal.BackgroundTransparency = 0
	reveal.Visible = true
	TweenService:Create(
		reveal,
		TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Size = UDim2.fromOffset(320, 90) }
	):Play()
	task.delay(2, function()
		if token ~= revealToken then
			return
		end
		local fade = TweenService:Create(
			reveal,
			TweenInfo.new(0.4),
			{ TextTransparency = 1, BackgroundTransparency = 1 }
		)
		fade:Play()
		fade.Completed:Wait()
		if token == revealToken then
			reveal.Visible = false
		end
	end)
end

inventoryResponse.OnClientEvent:Connect(function(counts: unknown)
	if type(counts) ~= "table" then
		return
	end
	for eggType, label in countLabels do
		local n = (counts :: { [string]: any })[eggType]
		if type(n) ~= "number" then
			n = 0
		end
		label.Text = ("%s x%d"):format(EggConfig.Eggs[eggType].DisplayName, n)
		hatchButtons[eggType].AutoButtonColor = n > 0
		hatchButtons[eggType].BackgroundColor3 = if n > 0
			then Color3.fromRGB(80, 170, 90)
			else Color3.fromRGB(90, 90, 90)
	end
end)

hatchResponse.OnClientEvent:Connect(function(success: unknown, eggType: unknown, petName: unknown, coinValue: unknown)
	if success == true and type(petName) == "string" and type(coinValue) == "number" then
		showReveal(("%s!  +%d coins"):format(petName, coinValue))
	else
		showReveal("Nothing to hatch")
	end
end)

inventoryRequest:FireServer()
