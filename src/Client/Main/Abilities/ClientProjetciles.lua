local ClientProjectiles = {}
ClientProjectiles.__index = ClientProjectiles

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Folders
-- Removed Remotes folder as it's not used anymore

-- Modules
local GammaCast = require(ReplicatedStorage.Abilities.Projectile.GammaCast)
local ClientEntity = require(script.Parent.Parent.Entities.ClientEntity)

-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local singleton = nil

function ClientProjectiles.new()
    if singleton then error("ClientProjectiles: Singleton already exists.") end

    local self = setmetatable({}, ClientProjectiles)    
    singleton = self

    self:setup()

    return self
end

function ClientProjectiles:setup()
    -- GammaCast.RemoteEvent.OnClientEvent:Connect(function(entityID, typeName, origin, direction, modifiers)
    --     GammaCast.CastClient(entityID, typeName, origin, direction, modifiers)
    -- end)
end

function ClientProjectiles.Init()
    -- Call once per context
    return ClientProjectiles.new()
end

return ClientProjectiles