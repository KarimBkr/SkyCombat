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
local SharedFolder = Modules:WaitForChild("Shared")
local ClassCosmetics = require(SharedFolder:WaitForChild("ClassCosmetics"))

local CLASSES = {
	Scout = require(ClassesFolder:WaitForChild("Scout")),
	Assault = require(ClassesFolder:WaitForChild("Assault")),
	Heavy = require(ClassesFolder:WaitForChild("Heavy")),
	Support = require(ClassesFolder:WaitForChild("Support")),
}

local function buildStats(classInstance)
	local stats = {}

	for k, v in pairs(classInstance) do
		local t = typeof(v)
		if t == "number" or t == "boolean" or t == "string" then
			stats[k] = v
		end
	end

	if classInstance.Name ~= nil then
		stats.Name = classInstance.Name
	end

	return stats
end

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

	humanoid.WalkSpeed = classInstance.Speed or humanoid.WalkSpeed
	humanoid.MaxHealth = classInstance.Health or humanoid.MaxHealth
	humanoid.Health = classInstance.Health or humanoid.Health

	local stats = buildStats(classInstance)

	ClassApplied:FireClient(player, className, stats)

	ClassCosmetics.Apply(className, character)

	print(string.format("[Server] Applied %s to %s", className, player.Name))
end

RequestClassChange.OnServerEvent:Connect(function(player, className)
	if CLASSES[className] then
		applyClassToPlayer(player, className)
	end
end)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		character:WaitForChild("Humanoid")

		local currentClass = player:GetAttribute("Class") or "Scout"

		task.spawn(function()
			task.wait(0.1)
			applyClassToPlayer(player, currentClass)
		end)
	end)
end)

return {}
