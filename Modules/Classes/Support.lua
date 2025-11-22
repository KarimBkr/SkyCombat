local Support = {}
Support.__index = Support

function Support.new()
	local self = setmetatable({}, Support)
	self.Name = "Support"
	self.Speed = 17
	self.Health = 125
	self.Armor = 10
	self.JetpackMaxFuel = 120
	self.JetpackRechargeRate = 16
	self.JetpackThrust = 5400
	self.JetpackUpwardSpeed = 68
	return self
end

function Support:OnSpawn(character)
	local humanoid = character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = self.Speed
		humanoid.MaxHealth = self.Health
		humanoid.Health = self.Health
	end
end

return Support
