local ClientAbilities = {}
ClientAbilities.__index = ClientAbilities

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local TypeEntity = require(ReplicatedStorage.Types.TypeEntity)
local AssetsDealer = require(ReplicatedStorage.AssetsDealer)
local ConfigUtility = require(ReplicatedStorage.Configs.ConfigUtility)
-- Folders
local AbiltiesFolder = ReplicatedStorage.Abilities
-- Network
local AbilitiesMiddleware = require(ReplicatedStorage.Middleware.MiddlewareManager).Get("Abilities")

function ClientAbilities.new(clientBackpack)
	local self = setmetatable({}, ClientAbilities)

	if not clientBackpack then
		error("ClientBackpack is missing")
		return
	end

	self.backpack = clientBackpack

	self:setup()

	return self
end

-- TODO: Add error handling
function ClientAbilities:setupTool(tool)
	local name = tool.Name
	local asset = AssetsDealer.Get("Tools", name)
	local config = ConfigUtility.GetConfig("Tools", name)

	self.abilities = {}
	for _, abilityConfig in config.abilities do
		local abilityName = abilityConfig.name
		local clientAbility = require(AbiltiesFolder[abilityName]["ClientAbility" .. abilityName])
		self.abilities[abilityName] = clientAbility.new(self.backpack.entity, tool, abilityConfig)
	end
end

function ClientAbilities:setup()
	-- For each tool get it's abilities
	for _, tool in self.backpack.tools:GetChildren() do
		self:setupTool(tool)
	end
end

return ClientAbilities
