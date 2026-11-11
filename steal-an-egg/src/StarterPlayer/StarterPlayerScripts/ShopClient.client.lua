--!strict
-- ShopClient: minimal code-built shop GUI. No purchase logic; the server decides.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Remotes)
local ShopConfig = require(ReplicatedStorage.ShopConfig)

local buyRequest = Remotes.get("BuyItemRequest")
local buyResponse = Remotes.get("BuyItemResponse")

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "ShopGui"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.fromOffset(80, 32)
toggle.Position = UDim2.new(0, 10, 0.5, -16)
toggle.Text = "Shop"
toggle.Parent = gui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(300, 300)
frame.Position = UDim2.new(0, 100, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = false
frame.Parent = gui

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 28)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.new(1, 1, 1)
status.Text = ""
status.LayoutOrder = 100
status.Parent = frame

for i, itemId in ShopConfig.ItemOrder do
	local item = ShopConfig.Items[itemId]
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 0, 36)
	button.LayoutOrder = i
	button.TextScaled = true
	button.Text = string.format("%s - %d coins", item.DisplayName, item.Price)
	button.Parent = frame
	button.Activated:Connect(function()
		buyRequest:FireServer(itemId)
	end)
end

toggle.Activated:Connect(function()
	frame.Visible = not frame.Visible
end)

buyResponse.OnClientEvent:Connect(function(success: boolean, itemId: string, message: string)
	status.TextColor3 = if success then Color3.fromRGB(120, 255, 120) else Color3.fromRGB(255, 120, 120)
	status.Text = message
end)
