local Scout = {}
Scout.__index = Scout

function Scout.new()
	local self = setmetatable({}, Scout)
	self.Name = "Scout"
	self.Speed = 26
	self.Health = 90
	self.Armor = 0
	self.JetpackMaxFuel = 140
	self.JetpackRechargeRate = 20
	self.JetpackThrust = 5200
	self.JetpackUpwardSpeed = 78
	return self
end

function Scout:OnSpawn(character)
	local humanoid = character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = self.Speed
		humanoid.MaxHealth = self.Health
		humanoid.Health = self.Health
	end
end

return Scout
