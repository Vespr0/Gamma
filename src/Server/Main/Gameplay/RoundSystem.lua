-- -- RoundSystem.lua
-- -- Handles round loop, intermission, player loading, and round timing
-- local Players = game:GetService("Players")
-- local MapLoader = require(script.Parent.MapLoader)

-- local INTERMISSION_TIME = 15
-- local Gamemodes = require(script.Parent.Gamemodes)

local RoundSystem = {}

-- function RoundSystem.TeleportPlayers(spawnPoints)
--     local players = Players:GetPlayers()
--     for i, player in ipairs(players) do
--         local spawn = spawnPoints[(i - 1) % #spawnPoints + 1]
--         if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
--             player.Character.HumanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0, 3, 0)
--         end
--     end
-- end

-- function RoundSystem.Start(gamemodeName)
--     local selectedGamemode = nil
--     for _, gm in ipairs(Gamemodes) do
--         if gm.Name == gamemodeName then
--             selectedGamemode = gm
--             break
--         end
--     end
--     if not selectedGamemode then
--         error("Gamemode '" .. tostring(gamemodeName) .. "' not found!")
--     end
--     local roundTime = selectedGamemode.RoundTime or 120
--     print("Starting rounds with gamemode:", selectedGamemode.Name)
--     while true do
--         -- Intermission
--         print("Intermission...")
--         for i = INTERMISSION_TIME, 1, -1 do
--             -- Could fire remote event for UI here
--             task.wait(1)
--         end

--         -- Map selection and loading
--         local mapTemplate = MapLoader.GetRandomMap()
--         local map = MapLoader.LoadMap(mapTemplate)
--         local spawnPoints = MapLoader.GetSpawnPoints(map)

--         -- Player loading
--         RoundSystem.TeleportPlayers(spawnPoints)

--         -- Start round
--         print("Round started! Gamemode:", selectedGamemode.Name)
--         for i = roundTime, 1, -1 do
--             -- (Round logic here)
--             task.wait(1)
--         end

--         -- Cleanup
--         MapLoader.ClearMap()
--         print("Round ended!")
--     end
-- end

return RoundSystem
