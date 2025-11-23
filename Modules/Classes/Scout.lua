local Scout = {}
Scout.__index = Scout

function Scout.new()
	local self = setmetatable({}, Scout)
	self.Name = "Scout"
	self.Speed = 26
	self.Health = 90
	self.Armor = 0

	self.JetpackMaxFuel = 130
	self.JetpackRechargeRate = 20
	self.FuelBurnRate = 24

	self.JetpackThrust = 5600
	self.JetpackUpwardSpeed = 78

	self.AirControl = 1.0
	self.AirAcceleration = 110

	return self
end

function Scout:GetStats()
	return {
		Speed = self.Speed,
		Health = self.Health,
		Armor = self.Armor,
		JetpackMaxFuel = self.JetpackMaxFuel,
		JetpackRechargeRate = self.JetpackRechargeRate,
		FuelBurnRate = self.FuelBurnRate,
		JetpackThrust = self.JetpackThrust,
		JetpackUpwardSpeed = self.JetpackUpwardSpeed,
		AirControl = self.AirControl,
		AirAcceleration = self.AirAcceleration
	}
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
