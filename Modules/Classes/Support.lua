local Support = {}
Support.__index = Support

function Support.new()
	local self = setmetatable({}, Support)
	self.Name = "Support"
	self.Speed = 17
	self.Health = 125
	self.Armor = 10

	self.JetpackMaxFuel = 115
	self.JetpackRechargeRate = 18
	self.FuelBurnRate = 19

	self.JetpackThrust = 6000
	self.JetpackUpwardSpeed = 65

	self.AirControl = 0.7
	self.AirAcceleration = 85

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
