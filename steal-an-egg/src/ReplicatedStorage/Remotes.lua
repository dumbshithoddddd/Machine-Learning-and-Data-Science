--!strict
-- Remotes: single registry for every RemoteEvent in the game.
-- Server: Remotes.get(name) creates the RemoteEvent on first use.
-- Client: Remotes.get(name) waits for the server to have created it.
-- Naming is fixed by docs/CONTRACT.md: <System><Action>Request / <System><Action>Response.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local FOLDER_NAME = "RemoteEvents"

local Remotes = {}

local function getFolder(): Instance
	if RunService:IsServer() then
		local folder = ReplicatedStorage:FindFirstChild(FOLDER_NAME)
		if not folder then
			folder = Instance.new("Folder")
			folder.Name = FOLDER_NAME
			folder.Parent = ReplicatedStorage
		end
		return folder
	end
	return ReplicatedStorage:WaitForChild(FOLDER_NAME)
end

function Remotes.get(name: string): RemoteEvent
	assert(
		string.match(name, "Request$") ~= nil or string.match(name, "Response$") ~= nil,
		"Remote name must end in Request or Response: " .. name
	)
	local folder = getFolder()
	if RunService:IsServer() then
		local remote = folder:FindFirstChild(name)
		if not remote then
			remote = Instance.new("RemoteEvent")
			remote.Name = name
			remote.Parent = folder
		end
		return remote :: RemoteEvent
	end
	return folder:WaitForChild(name) :: RemoteEvent
end

return Remotes
