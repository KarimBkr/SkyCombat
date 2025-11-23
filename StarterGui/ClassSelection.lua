local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local M = {}

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

	local fuelChanged = folder:FindFirstChild("FuelChanged")
	if not fuelChanged then
		fuelChanged = Instance.new("BindableEvent")
		fuelChanged.Name = "FuelChanged"
		fuelChanged.Parent = folder
	end

	return classChanged, fuelChanged
end

local gui, fuelFill, classText, fuelNumbers, classNumbers
local fuelConn, inputConn

local function createUI()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	gui = Instance.new("ScreenGui")
	gui.Name = "SkyCombatHUD"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 10
	gui.Parent = playerGui

	local box = Instance.new("Frame")
	box.AnchorPoint = Vector2.new(0.5, 0)
	box.Position = UDim2.new(0.5, 0, 0, 16)
	box.Size = UDim2.new(0, 560, 0, 86)
	box.BackgroundTransparency = 0.25
	box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	box.BorderSizePixel = 0
	box.Parent = gui

	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.Size = UDim2.new(1, -24, 0, 26)
	title.Position = UDim2.new(0, 12, 0, 6)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 19
	title.TextColor3 = Color3.fromRGB(255,255,255)
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Text = "Espace: Jetpack  |  C: Changer de classe"
	title.Parent = box

	classText = Instance.new("TextLabel")
	classText.BackgroundTransparency = 1
	classText.Size = UDim2.new(1, -24, 0, 22)
	classText.Position = UDim2.new(0, 12, 0, 34)
	classText.Font = Enum.Font.Gotham
	classText.TextSize = 18
	classText.TextColor3 = Color3.fromRGB(180, 230, 255)
	classText.TextXAlignment = Enum.TextXAlignment.Left
	classText.Text = "Classe actuelle : …"
	classText.Parent = box

	classNumbers = Instance.new("TextLabel")
	classNumbers.BackgroundTransparency = 1
	classNumbers.Size = UDim2.new(1, -24, 0, 18)
	classNumbers.Position = UDim2.new(0, 12, 0, 58)
	classNumbers.Font = Enum.Font.Gotham
	classNumbers.TextSize = 14
	classNumbers.TextColor3 = Color3.fromRGB(210, 210, 210)
	classNumbers.TextXAlignment = Enum.TextXAlignment.Left
	classNumbers.Text = ""
	classNumbers.Parent = box

	local fuelFrame = Instance.new("Frame")
	fuelFrame.AnchorPoint = Vector2.new(0.5, 1)
	fuelFrame.Position = UDim2.new(0.5, 0, 1, -30)
	fuelFrame.Size = UDim2.new(0, 520, 0, 18)
	fuelFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
	fuelFrame.BackgroundTransparency = 0.2
	fuelFrame.BorderSizePixel = 0
	fuelFrame.Parent = gui

	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, -4, 1, -4)
	bg.Position = UDim2.new(0, 2, 0, 2)
	bg.BackgroundColor3 = Color3.fromRGB(15,15,15)
	bg.BorderSizePixel = 0
	bg.Parent = fuelFrame

	fuelFill = Instance.new("Frame")
	fuelFill.Size = UDim2.new(1, 0, 1, 0)
	fuelFill.BackgroundColor3 = Color3.fromRGB(0,170,255)
	fuelFill.BorderSizePixel = 0
	fuelFill.Parent = bg

	fuelNumbers = Instance.new("TextLabel")
	fuelNumbers.BackgroundTransparency = 1
	fuelNumbers.AnchorPoint = Vector2.new(0.5, 1)
	fuelNumbers.Position = UDim2.new(0.5, 0, 1, -50)
	fuelNumbers.Size = UDim2.new(0, 520, 0, 20)
	fuelNumbers.Font = Enum.Font.GothamBold
	fuelNumbers.TextSize = 15
	fuelNumbers.TextColor3 = Color3.fromRGB(255,255,255)
	fuelNumbers.TextXAlignment = Enum.TextXAlignment.Center
	fuelNumbers.Text = "Fuel: --/--"
	fuelNumbers.Parent = gui

	local Modules = ReplicatedStorage:WaitForChild("Modules")
	local UI = Modules:WaitForChild("UI")
	local ClassUI = require(UI:WaitForChild("ClassSelectUI"))

	local changeBtn = Instance.new("TextButton")
	changeBtn.Size = UDim2.new(0, 160, 0, 28)
	changeBtn.Position = UDim2.new(1, -170, 0, 18)
	changeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	changeBtn.TextColor3 = Color3.new(1,1,1)
	changeBtn.Font = Enum.Font.GothamBold
	changeBtn.TextSize = 14
	changeBtn.Text = "Change Class (C)"
	changeBtn.Parent = gui

	changeBtn.MouseButton1Click:Connect(function()
		ClassUI.Show()
	end)

	if inputConn then inputConn:Disconnect() end
	inputConn = UserInputService.InputBegan:Connect(function(input, gpe)
		if gpe then return end
		if input.KeyCode == Enum.KeyCode.C then
			ClassUI.Show()
		end
	end)
end

function M.Show()
	if not gui then
		createUI()
	end

	local _, fuelChanged = getEvents()

	if fuelConn then fuelConn:Disconnect() end
	fuelConn = fuelChanged.Event:Connect(function(percent, className, fuel, maxFuel, burnRate, rechargeRate, airMaxSpeed)
		if fuelFill then
			local p = math.clamp(percent or 0, 0, 1)
			fuelFill.Size = UDim2.new(p, 0, 1, 0)
		end

		if classText and className then
			classText.Text = ("Classe actuelle : %s"):format(className)
		end

		if fuelNumbers then
			local f = math.floor(fuel or 0)
			local m = math.floor(maxFuel or 0)
			fuelNumbers.Text = ("Fuel: %d / %d"):format(f, m)
		end

		if classNumbers then
			local b = burnRate and string.format("%.0f", burnRate) or "--"
			local r = rechargeRate and string.format("%.0f", rechargeRate) or "--"
			local a = airMaxSpeed and string.format("%.0f", airMaxSpeed) or "--"
			classNumbers.Text = ("Burn: %s/s   Recharge: %s/s   AirMax: %s"):format(b, r, a)
		end
	end)
end

function M.Hide()
	if fuelConn then fuelConn:Disconnect() end
	if inputConn then inputConn:Disconnect() end
	if gui then
		gui:Destroy()
		gui = nil
		fuelFill = nil
		classText = nil
		fuelNumbers = nil
		classNumbers = nil
	end
end

return M
