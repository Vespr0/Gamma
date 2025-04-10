-- Services 
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BaseAbility = require(ReplicatedStorage.Abilities.BaseAbility)
local BaseServerAbility = setmetatable({}, {__index = BaseAbility})
BaseServerAbility.__index = BaseServerAbility

-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local Trove = require(ReplicatedStorage.Packages.trove)
local TypeEntity = require(ReplicatedStorage.Types.TypeEntity)
-- Network
local AbilitiesMiddleware = require(ReplicatedStorage.Middleware.MiddlewareManager).Get("Abilities")
-- Constants
local IS_SERVER = RunService:IsServer()

function BaseServerAbility.new(name: string, entity: TypeEntity.BaseEntity, tool: Tool, config)
    assert(typeof(name) == "string", "Invalid call, ability name must be a string.")

    local self = setmetatable(BaseAbility.new(name,entity,tool,config) :: TypeAbility.BaseServerAbility, BaseServerAbility)

	self.player = entity.player
	
	-- Add MindController event for NPCs
	if not entity.player then
		self.mindController = Signal.new()
	end

	self:setup()

    return self
end 

function BaseServerAbility:setup()

end

function BaseServerAbility:destroySub()
	if self.mindController then
		self.mindController:Destroy()
	end
	self:destroyBase()
end

return BaseServerAbility
