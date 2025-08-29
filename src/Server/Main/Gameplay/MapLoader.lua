-- -- MapLoader.lua
-- -- Responsible for selecting and cloning maps into the workspace
-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local Workspace = game:GetService("Workspace")

-- local MapFolder = ReplicatedStorage:WaitForChild("Maps")
-- local ActiveMapFolder = Workspace:FindFirstChild("ActiveMap") or Instance.new("Folder", Workspace)
-- ActiveMapFolder.Name = "ActiveMap"

local MapLoader = {}

-- function MapLoader.GetRandomMap()
--     local maps = MapFolder:GetChildren()
--     if #maps == 0 then
--         error("No maps found in ReplicatedStorage.Maps!")
--     end
--     return maps[math.random(1, #maps)]
-- end

-- function MapLoader.LoadMap(mapTemplate)
--     MapLoader.ClearMap()
--     local mapClone = mapTemplate:Clone()
--     mapClone.Parent = ActiveMapFolder

--     -- Position the map at the origin (this is to avoid issues with far away positions es: Snapshots voxel grid has a limited size)
--     mapClone:PivotTo(CFrame.new())

--     return mapClone
-- end

-- function MapLoader.GetSpawnPoints(map)
--     local spawns = {}
--     for _, obj in ipairs(map:GetDescendants()) do
--         if obj:IsA("BasePart") and obj.Name == "Spawn" then
--             table.insert(spawns, obj)
--         end
--     end
--     return spawns
-- end

-- function MapLoader.ClearMap()
--     ActiveMapFolder:ClearAllChildren()
-- end

return MapLoader
