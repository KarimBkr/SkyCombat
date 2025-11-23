local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Cleanup anti-doublons StarterGui
local oldHud = playerGui:FindFirstChild("SkyCombatHUD")
if oldHud then oldHud:Destroy() end

local oldClassUI = playerGui:FindFirstChild("ClassSelectionUI")
if oldClassUI then oldClassUI:Destroy() end

-- ✅ HUD module : supporte les 2 noms possibles
local parentGui = script.Parent
local hudModule =
	parentGui:FindFirstChild("ClassSelection")
	or parentGui:FindFirstChild("ClassSelection.screen")

if not hudModule then
	warn("[UILoader] HUD module not found in StarterGui")
	return
end

local HUD = require(hudModule)

-- Class UI
local Modules = ReplicatedStorage:WaitForChild("Modules")
local UI = Modules:WaitForChild("UI")
local ClassUI = require(UI:WaitForChild("ClassSelectUI"))

print("[Client] UILoader starting...")
HUD.Show()

-- N’auto-ouvre la sélection qu’une seule fois par session
if not player:GetAttribute("HasSeenClassSelect") then
	player:SetAttribute("HasSeenClassSelect", true)
	ClassUI.Show()
end
