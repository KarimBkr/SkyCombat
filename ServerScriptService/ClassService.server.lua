local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local remoteFolder = ReplicatedStorage:FindFirstChild("RemoteEvents")
if not remoteFolder then
	remoteFolder = Instance.new("Folder")
	remoteFolder.Name = "RemoteEvents"
	remoteFolder.Parent = ReplicatedStorage
end

local function getRemote(name)
	local remote = remoteFolder:FindFirstChild(name)
	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = remoteFolder
	end
	return remote
end

local RequestClassChange = getRemote("RequestClassChange")
local ClassApplied = getRemote("ClassApplied")

local Modules = ReplicatedStorage:WaitForChild("Modules")
local ClassesFolder = Modules:WaitForChild("Classes")

local CLASSES = {
	Scout = require(ClassesFolder.Scout),
	Assault = require(ClassesFolder.Assault),
	Heavy = require(ClassesFolder.Heavy),
	Support = require(ClassesFolder.Support),
}

local function applyClassToPlayer(player, className)
	local classModule = CLASSES[className]
	if not classModule then
		warn("Invalid class requested: " .. tostring(className))
		return
	end

	player:SetAttribute("Class", className)

	local character = player.Character
	if not character then return end

	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then return end

	local classInstance = classModule.new()

	humanoid.WalkSpeed = classInstance.Speed
	humanoid.MaxHealth = classInstance.Health
	humanoid.Health = classInstance.Health

	local stats = {
		Name = classInstance.Name,
		Speed = classInstance.Speed,
		Health = classInstance.Health,
		Armor = classInstance.Armor,

		JetpackMaxFuel = classInstance.JetpackMaxFuel,
		JetpackRechargeRate = classInstance.JetpackRechargeRate,
		FuelBurnRate = classInstance.FuelBurnRate,

		JetpackThrust = classInstance.JetpackThrust,
		JetpackUpwardSpeed = classInstance.JetpackUpwardSpeed,
		JetpackUpwardAccel = classInstance.JetpackUpwardAccel,
		JetpackMaxUpSpeed = classInstance.JetpackMaxUpSpeed,
		JetpackMaxFallSpeed = classInstance.JetpackMaxFallSpeed,

		AirControl = classInstance.AirControl,
		AirAcceleration = classInstance.AirAcceleration,
		AirMaxSpeed = classInstance.AirMaxSpeed,
		AirDrag = classInstance.AirDrag,
		VelocityResponse = classInstance.VelocityResponse,
	}

	ClassApplied:FireClient(player, className, stats)
end

RequestClassChange.OnServerEvent:Connect(function(player, className)
	if CLASSES[className] then
		applyClassToPlayer(player, className)
	end
end)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(0.1)
		local currentClass = player:GetAttribute("Class") or "Scout"
		applyClassToPlayer(player, currentClass)
	end)
end)

return {}
