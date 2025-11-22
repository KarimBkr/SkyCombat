local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Folders
local remoteFolder = ReplicatedStorage:WaitForChild("RemoteEvents")
local RequestClassChange = remoteFolder:WaitForChild("RequestClassChange")
local ClassApplied = remoteFolder:WaitForChild("ClassApplied")
local FuelUpdate = remoteFolder:WaitForChild("FuelUpdate")

local clientEvents = ReplicatedStorage:WaitForChild("ClientEvents")
local classChangedBindable = clientEvents:WaitForChild("ClassChanged")
local fuelChangedBindable = clientEvents:WaitForChild("FuelChanged")

local Modules = ReplicatedStorage:WaitForChild("Modules")
local MovementFolder = Modules:WaitForChild("Movement")
local JetpackController = require(MovementFolder:WaitForChild("JetpackController"))

-- State
local player = Players.LocalPlayer
local jetpack = nil
local currentClassName = "Scout"

-- Listen for UI requests (Bindable) and forward to Server
classChangedBindable.Event:Connect(function(className)
	print("[Client] Requesting class: " .. className)
	RequestClassChange:FireServer(className)
end)

-- Listen for Server confirmation
ClassApplied.OnClientEvent:Connect(function(className, stats)
	print("[Client] Class applied: " .. className)
	currentClassName = className
	
	local character = player.Character
	if character then
		-- Re-create Jetpack with server-provided stats
		if jetpack then jetpack:Destroy() end
		jetpack = JetpackController.new(character, stats)
		
		-- Update HUD immediately
		fuelChangedBindable:Fire(1, currentClassName)
	end
end)

-- Update Fuel HUD loop
RunService.Heartbeat:Connect(function()
	if jetpack and jetpack.MaxFuel and jetpack.MaxFuel > 0 then
		local pct = (jetpack.Fuel or 0) / jetpack.MaxFuel
		fuelChangedBindable:Fire(pct, currentClassName)
	end
end)
