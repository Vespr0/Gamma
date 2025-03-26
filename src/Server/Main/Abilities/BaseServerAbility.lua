-- Services 
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BaseAbility = require(ReplicatedStorage.Abilities.BaseAbility)
local BaseClientAbility = setmetatable({}, {__index = BaseAbility})
BaseClientAbility.__index = BaseClientAbility

-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local Trove = require(ReplicatedStorage.Packages.trove)
local TypeEntity = require(ReplicatedStorage.Types.TypeEntity)
-- Network
local AbilitiesMiddleware = require(ReplicatedStorage.Middleware.MiddlewareManager).Get("Abilities")
-- Constants
local IS_SERVER = RunService:IsServer()

function BaseClientAbility.new(name: string, entity: TypeEntity.BaseEntity, tool: Tool, config)
    assert(typeof(name) == "string", "Invalid call, ability name must be a string.")

    local self = setmetatable(BaseAbility.new(name,entity,tool,config) :: TypeAbility.BaseAbility, BaseClientAbility)

	self:setup()

    return self
end

function BaseClientAbility:checkInputConditions()
	local dummyTool = self.entity.backpack:getDummyTool()
	if not dummyTool then return false end
		
	if dummyTool:GetAttribute("ID") ~= self.tool:GetAttribute("ID") then return false end

	return true
end

function BaseClientAbility:setup()

end

function BaseClientAbility:destroySub()
	self:destroyBase()
end

return BaseClientAbility
