local ServerProjectiles = {}
ServerProjectiles.__index = ServerProjectiles

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Folders
-- Modules
local GammaCast = require(ReplicatedStorage.Abilities.Projectile.GammaCast)
local EntityUtility = require(ReplicatedStorage.Utility.Entity)
local Snapshots = require(ReplicatedStorage.Abilities.Projectile.GammaCast.Utility.Snapshots)

-- Variables
local singleton = nil

function ServerProjectiles.new()
    if singleton then error("ServerProjectiles: Singleton already exists.") end

    local self = setmetatable({}, ServerProjectiles)
    singleton = self

    self:setup()

    return self
end

function ServerProjectiles:setup()
    -- Listen for client requests via GammaCast's RemoteEvent
    -- GammaCast.RemoteEvent.OnServerEvent:Connect(function(player, typeName, origin, direction, clientTimestamp, modifiers)
    --     local entityID = EntityUtility.GetEntityIDFromPlayer(player)

    --     task.spawn(function()
    --         GammaCast.CastServer(player, typeName, origin, direction, clientTimestamp, modifiers)
    --     end)

    --     -- Replicate to OTHER clients
    --     for _, clientPlayer in Players:GetPlayers() do
    --         if clientPlayer ~= player then
    --             GammaCast.RemoteEvent:FireClient(clientPlayer, entityID, typeName, origin, direction, modifiers)
    --         end
    --     end
    -- end)

    Snapshots.Init()
end

function ServerProjectiles.Init()
    -- Call once per context
    if singleton then return end
    singleton = ServerProjectiles.new()
end

return ServerProjectiles