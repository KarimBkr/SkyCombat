local MainMenu = {}

function MainMenu.Show()
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainMenu"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 100)
title.Position = UDim2.new(0, 0, 0, 50)
title.Text = "?? SkyCombat"
title.TextScaled = true
title.Font = Enum.Font.FredokaOne
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Parent = screenGui

local playButton = Instance.new("TextButton")
playButton.Size = UDim2.new(0, 300, 0, 80)
playButton.Position = UDim2.new(0.5, -150, 0.5, -40)
playButton.Text = "PLAY"
playButton.TextScaled = true
playButton.Font = Enum.Font.FredokaOne
playButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
playButton.TextColor3 = Color3.fromRGB(255, 255, 255)
playButton.Parent = screenGui

playButton.MouseButton1Click:Connect(function()
print("Play clicked")
playButton.Text = "Loading..."
task.wait(0.5)
MainMenu.Hide()
end)
end

function MainMenu.Hide()
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mainMenu = playerGui:FindFirstChild("MainMenu")
if mainMenu then mainMenu:Destroy() end
end

return MainMenu
