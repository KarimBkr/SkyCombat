local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")

local JetpackController = {}
JetpackController.__index = JetpackController

function JetpackController.new(character, classStats)
	local self = setmetatable({}, JetpackController)

	self.Character = character
	self.Humanoid = character:WaitForChild("Humanoid")
	self.RootPart = character:WaitForChild("HumanoidRootPart")
	self.ClassStats = classStats or {}

	self.MaxFuel = self.ClassStats.JetpackMaxFuel or self.ClassStats.JetpackFuel or 100
	self.Fuel = self.MaxFuel
	self.RechargeRate = self.ClassStats.JetpackRechargeRate or 10
	self.Thrust = self.ClassStats.JetpackThrust or 8000
	self.UpwardSpeed = self.ClassStats.JetpackUpwardSpeed or 60

	self.IsActive = false

	self:_setupPhysics()
	self:_setupInput()
	self:_setupVisuals()

	self._conn = RunService.Heartbeat:Connect(function(dt)
		self:_update(dt)
	end)

	return self
end

function JetpackController:_setupPhysics()
	local rootAttachment = self.RootPart:FindFirstChild("RootAttachment")
	if not rootAttachment then
		rootAttachment = Instance.new("Attachment")
		rootAttachment.Name = "RootAttachment"
		rootAttachment.Parent = self.RootPart
	end

	local lv = Instance.new("LinearVelocity")
	lv.Name = "JetpackLV"
	lv.Attachment0 = rootAttachment
	lv.RelativeTo = Enum.ActuatorRelativeTo.World
	lv.VectorVelocity = Vector3.zero

	lv.ForceLimitMode = Enum.ForceLimitMode.Magnitude
	lv.ForceLimitsEnabled = true
	lv.MaxForce = 0

	lv.Parent = self.RootPart

	self.LinearVelocity = lv
end

function JetpackController:_setupInput()
	local function handler(_, state)
		if state == Enum.UserInputState.Begin then
			self.IsActive = true
		elseif state == Enum.UserInputState.End then
			self.IsActive = false
		end
		return Enum.ContextActionResult.Pass
	end

	ContextActionService:BindAction("JetpackThrust", handler, true, Enum.KeyCode.Space)
end

function JetpackController:_setupVisuals()
	local trail = Instance.new("Trail")
	trail.Color = ColorSequence.new(Color3.fromRGB(255, 200, 0))
	trail.Lifetime = 0.3
	trail.Enabled = false

	local a1 = Instance.new("Attachment")
	a1.Position = Vector3.new(0.5, -1, 0)
	a1.Parent = self.RootPart

	local a2 = Instance.new("Attachment")
	a2.Position = Vector3.new(-0.5, -1, 0)
	a2.Parent = self.RootPart

	trail.Attachment0 = a1
	trail.Attachment1 = a2
	trail.Parent = self.RootPart

	self.Trail = trail
end

function JetpackController:_update(dt)
	if not self.Character or not self.Character.Parent then
		self:Destroy()
		return
	end

	if self.IsActive and self.Fuel > 0 then
		self.LinearVelocity.MaxForce = self.Thrust
		self.LinearVelocity.VectorVelocity = Vector3.new(0, self.UpwardSpeed, 0)

		self.Fuel = math.max(0, self.Fuel - (20 * dt))
		self.Trail.Enabled = true
	else
		self.LinearVelocity.MaxForce = 0
		self.LinearVelocity.VectorVelocity = Vector3.zero

		if self.Humanoid.FloorMaterial ~= Enum.Material.Air then
			self.Fuel = math.min(self.MaxFuel, self.Fuel + (self.RechargeRate * dt))
		end

		self.Trail.Enabled = false
	end
end

function JetpackController:Destroy()
	if self._conn then self._conn:Disconnect() end
	ContextActionService:UnbindAction("JetpackThrust")
	if self.LinearVelocity then self.LinearVelocity:Destroy() end
	if self.Trail then self.Trail:Destroy() end
end

return JetpackController
