local Heavy = {}
Heavy.__index = Heavy

function Heavy.new()
	local self = setmetatable({}, Heavy)
	self.Name = "Heavy"
	self.Speed = 14
	self.Health = 230
	self.Armor = 55
	self.JetpackMaxFuel = 85
	self.JetpackRechargeRate = 7
	self.JetpackThrust = 4800
	self.JetpackUpwardSpeed = 60
	return self
end

function Heavy:OnSpawn(character)
	local humanoid = character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = self.Speed
		humanoid.MaxHealth = self.Health
		humanoid.Health = self.Health
	end
end

return Heavy
