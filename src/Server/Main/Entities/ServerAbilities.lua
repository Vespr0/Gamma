local ServerAbilities = {}
ServerAbilities.__index = ServerAbilities

-- Services 
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local TypeEntity = require(ReplicatedStorage.Types.TypeEntity)
local AssetsDealer = require(ReplicatedStorage.AssetsDealer)
-- Folders
local AbiltiesFolder = ReplicatedStorage.Abilities
-- Network
local AbilitiesMiddleware = require(ReplicatedStorage.Middleware.MiddlewareManager).Get("Abilities")

function ServerAbilities.new(serverBackpack)
    local self = setmetatable({}, ServerAbilities)

	if not serverBackpack then error("ClientBackpack is missing"); return end

    self.backpack = serverBackpack

    self:setup()

    return self
end

-- TODO: Add error handling
function ServerAbilities:setupTool(tool)
    local name = tool.Name
    local asset = AssetsDealer.Get("Tools", name)
    local config = require(asset.Config)

    self.abilities = {}
    for _, abilityConfig in config.abilities do
        local abilityName = abilityConfig.name
        local folder = AbiltiesFolder[abilityName]
        local serverAbility = folder:FindFirstChild("ServerAbility"..abilityName)
        if not serverAbility then return end
        serverAbility = require(serverAbility)
        self.abilities[abilityName] = serverAbility.new(self.backpack.entity,tool,abilityConfig)
    end
end

function ServerAbilities:setup()
    -- For each tool get it's abilities
    for _, tool in self.backpack.tools:GetChildren() do
        self:setupTool(tool)
    end
end

return ServerAbilities
