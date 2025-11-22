local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

-- Setup RemoteEvents
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
local FuelUpdate = getRemote("FuelUpdate")

-- Load Classes
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ClassesFolder = Modules:WaitForChild("Classes")

local CLASSES = {
	Scout = require(ClassesFolder.Scout),
	Assault = require(ClassesFolder.Assault),
	Heavy = require(ClassesFolder.Heavy),
	Support = require(ClassesFolder.Support),
}

-- Helper to apply class
local function applyClassToPlayer(player, className)
	local classModule = CLASSES[className]
	if not classModule then
		warn("Invalid class requested: " .. tostring(className))
		return
	end
	
	-- Store selection
	player:SetAttribute("Class", className)
	
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			-- Create instance to get stats
			local classInstance = classModule.new()
			
			-- Apply Server-Side Stats
			humanoid.WalkSpeed = classInstance.Speed
			humanoid.MaxHealth = classInstance.Health
			humanoid.Health = classInstance.Health
			
			-- Prepare stats for client
			local stats = {
				Name = classInstance.Name,
				Speed = classInstance.Speed,
				Health = classInstance.Health,
				Armor = classInstance.Armor,
				JetpackMaxFuel = classInstance.JetpackMaxFuel,
				JetpackRechargeRate = classInstance.JetpackRechargeRate,
				JetpackThrust = classInstance.JetpackThrust,
				JetpackUpwardSpeed = classInstance.JetpackUpwardSpeed
			}
			
			-- Notify Client
			ClassApplied:FireClient(player, className, stats)
			print(string.format("[Server] Applied %s to %s", className, player.Name))
		end
	end
end

-- Event Listeners
RequestClassChange.OnServerEvent:Connect(function(player, className)
	if CLASSES[className] then
		applyClassToPlayer(player, className)
	end
end)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		-- Wait for humanoid
		character:WaitForChild("Humanoid")
		
		-- Check if player already selected a class, otherwise default to Scout
		local currentClass = player:GetAttribute("Class") or "Scout"
		
		-- Apply (with a small delay to ensure client is ready listening)
		task.spawn(function()
			task.wait(0.1)
			applyClassToPlayer(player, currentClass)
		end)
	end)
end)

return {}
