local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local ClassSelectUI = {}

local Modules = ReplicatedStorage:WaitForChild("Modules")
local ClassesFolder = Modules:WaitForChild("Classes")

local CLASS_MODULES = {
	Scout = require(ClassesFolder:WaitForChild("Scout")),
	Assault = require(ClassesFolder:WaitForChild("Assault")),
	Heavy = require(ClassesFolder:WaitForChild("Heavy")),
	Support = require(ClassesFolder:WaitForChild("Support")),
}

local ORDER = {"Scout","Assault","Heavy","Support"}

local function getEvents()
	local folder = ReplicatedStorage:FindFirstChild("ClientEvents")
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = "ClientEvents"
		folder.Parent = ReplicatedStorage
	end

	local classChanged = folder:FindFirstChild("ClassChanged")
	if not classChanged then
		classChanged = Instance.new("BindableEvent")
		classChanged.Name = "ClassChanged"
		classChanged.Parent = folder
	end

	return classChanged
end

function ClassSelectUI.Show()
	if ClassSelectUI.Gui then return end

	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ClassSelectionUI"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder = 50
	screenGui.Parent = playerGui

	local frame = Instance.new("Frame")
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.Size = UDim2.new(0, 650, 0, 360)
	frame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
	frame.BorderSizePixel = 0
	frame.Parent = screenGui

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 54)
	title.BackgroundTransparency = 1
	title.Text = "SELECT YOUR CLASS"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 30
	title.Parent = frame

	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 36, 0, 36)
	closeBtn.Position = UDim2.new(1, -44, 0, 8)
	closeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	closeBtn.TextColor3 = Color3.new(1,1,1)
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 20
	closeBtn.Text = "X"
	closeBtn.Parent = frame
	closeBtn.MouseButton1Click:Connect(function()
		ClassSelectUI.Hide()
	end)

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 1, -60)
	container.Position = UDim2.new(0, 0, 0, 60)
	container.BackgroundTransparency = 1
	container.Parent = frame

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0.02, 0)
	layout.Parent = container

	for _, className in ipairs(ORDER) do
		local mod = CLASS_MODULES[className]
		local statsObj = mod.new()

		local hp = statsObj.Health or 0
		local spd = statsObj.Speed or 0
		local armor = statsObj.Armor or 0
		local fuel = statsObj.JetpackMaxFuel or statsObj.JetpackFuel or 0
		local recharge = statsObj.JetpackRechargeRate or 0

		local button = Instance.new("TextButton")
		button.Name = className
		button.Size = UDim2.new(0.22, 0, 0.8, 0)
		button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
		button.BorderSizePixel = 0
		button.Text = ""
		button.Parent = container

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(1, 0, 0.22, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = className
		nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.TextSize = 22
		nameLabel.Parent = button

		local statsLabel = Instance.new("TextLabel")
		statsLabel.Size = UDim2.new(0.9, 0, 0.7, 0)
		statsLabel.Position = UDim2.new(0.05, 0, 0.25, 0)
		statsLabel.BackgroundTransparency = 1
		statsLabel.Text = string.format(
			"HP: %d\nSpeed: %d\nArmor: %d\nFuel: %d\nRecharge: %d/s",
			hp, spd, armor, fuel, recharge
		)
		statsLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
		statsLabel.Font = Enum.Font.Gotham
		statsLabel.TextSize = 14
		statsLabel.TextYAlignment = Enum.TextYAlignment.Top
		statsLabel.Parent = button

		button.MouseButton1Click:Connect(function()
			local classChangedEvent = getEvents()
			classChangedEvent:Fire(className)
			ClassSelectUI.Hide()
		end)
	end

	ClassSelectUI.Gui = screenGui
end

function ClassSelectUI.Hide()
	if ClassSelectUI.Gui then
		ClassSelectUI.Gui:Destroy()
		ClassSelectUI.Gui = nil
	end
end

return ClassSelectUI
