local TerrainGenerator = {}

function TerrainGenerator.GenerateMap()
    print("[Server] Generating map...")

    local mapFolder = workspace:FindFirstChild("GeneratedMap")
    if mapFolder then mapFolder:Destroy() end

    mapFolder = Instance.new("Folder")
    mapFolder.Name = "GeneratedMap"
    mapFolder.Parent = workspace

    local base = Instance.new("Part")
    base.Name = "Baseplate"
    base.Size = Vector3.new(500, 5, 500)
    base.Position = Vector3.new(0, -2.5, 0)
    base.Anchored = true
    base.Color = Color3.fromRGB(50, 150, 50)
    base.Parent = mapFolder

    print("[Server] Baseplate generated!")
end

return TerrainGenerator
