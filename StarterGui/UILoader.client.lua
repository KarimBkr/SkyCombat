local ReplicatedStorage = game:GetService("ReplicatedStorage")

local parentGui = script.Parent
local hudModule = parentGui:FindFirstChild("ClassSelection") or parentGui:FindFirstChild("ClassSelection.screen")
if not hudModule then
	hudModule = parentGui:WaitForChild("ClassSelection.screen")
end

local HUD = require(hudModule)

local Modules = ReplicatedStorage:WaitForChild("Modules")
local UI = Modules:WaitForChild("UI")
local ClassUI = require(UI:WaitForChild("ClassSelectUI"))

print("[Client] UILoader starting...")
HUD.Show()
ClassUI.Show()
