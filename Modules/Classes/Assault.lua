local Assault = {}
Assault.__index = Assault

function Assault.new()
	local self = setmetatable({}, Assault)
	self.Name = "Assault"
	self.Speed = 18
	self.Health = 150
	self.Armor = 20

	self.JetpackMaxFuel = 110
	self.JetpackRechargeRate = 12
	self.FuelBurnRate = 20

	self.JetpackThrust = 6400
	self.JetpackUpwardSpeed = 70

	self.AirControl = 0.75
	self.AirAcceleration = 90

	return self
end

function Assault:OnSpawn(character)
	local humanoid = character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = self.Speed
		humanoid.MaxHealth = self.Health
		humanoid.Health = self.Health
	end
end

return Assault
