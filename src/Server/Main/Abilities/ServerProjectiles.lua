local ServerProjectiles = {}
ServerProjectiles.__index = ServerProjectiles

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Folders
-- Modules
local GammaCast = require(ReplicatedStorage.Abilities.Projectile.GammaCast)
local EntityUtility = require(ReplicatedStorage.Utility.Entity)
local Snapshots = require(ReplicatedStorage.Utility.LagCompensation.Snapshots)

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
    Snapshots.Init()
end

function ServerProjectiles.Init()
    -- Call once per context
    if singleton then return end
    singleton = ServerProjectiles.new()
end

return ServerProjectiles