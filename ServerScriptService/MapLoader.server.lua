local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Attend que le dossier Modules et Map soient bien créés
local Modules = ReplicatedStorage:WaitForChild("Modules")
local MapFolder = Modules:WaitForChild("Map")
local TerrainGenerator = require(MapFolder:WaitForChild("TerrainGenerator"))

print("[Server] Generating map...")
TerrainGenerator.GenerateMap()
print("[Server] Map generation complete.")
