local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local remoteFolder = ReplicatedStorage:WaitForChild("RemoteEvents")
local RequestClassChange = remoteFolder:WaitForChild("RequestClassChange")
local ClassApplied = remoteFolder:WaitForChild("ClassApplied")

local clientEvents = ReplicatedStorage:WaitForChild("ClientEvents")
local classChangedBindable = clientEvents:WaitForChild("ClassChanged")
local fuelChangedBindable = clientEvents:WaitForChild("FuelChanged")

local Modules = ReplicatedStorage:WaitForChild("Modules")
local MovementFolder = Modules:WaitForChild("Movement")
local JetpackController = require(MovementFolder:WaitForChild("JetpackController"))

local player = Players.LocalPlayer
local jetpack = nil
local currentClassName = "Scout"
local lastStats = nil

local function pushFuel()
	if not jetpack then return end
	local maxFuel = jetpack.MaxFuel or 100
	local fuel = jetpack.Fuel or 0
	local pct = (maxFuel > 0) and (fuel / maxFuel) or 0

	fuelChangedBindable:Fire(
		pct,
		currentClassName,
		fuel,
		maxFuel,
		jetpack.FuelBurnRate,
		jetpack.RechargeRate,
		jetpack.AirMaxSpeed
	)
end

classChangedBindable.Event:Connect(function(className)
	RequestClassChange:FireServer(className)
end)

ClassApplied.OnClientEvent:Connect(function(className, stats)
	currentClassName = className
	lastStats = stats

	local character = player.Character
	if not character then return end

	if jetpack then jetpack:Destroy() end
	jetpack = JetpackController.new(character, stats)

	pushFuel()
end)

player.CharacterAdded:Connect(function(character)
	if lastStats and jetpack then
		jetpack:Destroy()
		jetpack = JetpackController.new(character, lastStats)
	end
	pushFuel()
end)

RunService.Heartbeat:Connect(function()
	pushFuel()
end)
