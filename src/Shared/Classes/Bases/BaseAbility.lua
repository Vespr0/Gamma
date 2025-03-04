local BaseAbility = {}
BaseAbility.__index = BaseAbility

-- Services 
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local TypeEntity = require(ReplicatedStorage.Types.TypeEntity)
-- Network
local AbilitiesMiddleware = require(ReplicatedStorage.Middleware.MiddlewareManager).Get("Abilities")
-- Constants
local IS_SERVER = RunService:IsServer()

function BaseAbility.new(name: string,entity: TypeEntity.BaseEntity,tool,config)
    local self = setmetatable({}, BaseAbility)

	if not name then error("Ability name is missing"); return end
	if not entity then error("Entity is missing"); return end
	if not tool then error("Tool is missing"); return end
	if not config then error("Ability configuration is missing"); return end
	
	-- Basic info
	self.entity = entity
	self.name = name
	self.config = config

    -- Variables 
	self.tool = tool
	
	-- Cooldown
	self.cooldownDuration = self.config.CooldownDuration
	self.cooldown = 0

	self.events = {
		Destroyed = Signal.new(),
	}

    return self
end

function BaseAbility:setup()
	self.tool.Destroyed:Connect(function() -- TODO: Potentially insufficent garbage collection
		self.events.Destroyed:Fire() 
	end)
end

function BaseAbility:readAction(func)
	AbilitiesMiddleware.ReadAbilityAction:Connect(function(abilityName: string,entityID: number,...)
		if self.entity.id ~= entityID then return end
		if abilityName ~= self.name then return end

		func(...)
	end)
end

function BaseAbility:getFakeTool()
	return self.tool
end

function BaseAbility:sendAction(...)
	return AbilitiesMiddleware.SendAbilityAction(self.name,self.entity.id,self.tool:GetAttribute("Index"),...)
end

function BaseAbility:isToolEquipped()
	return self.tool:GetAttribute("Equipped")
end

function BaseAbility:heat()
	self.cooldown = workspace:GetServerTimeNow() + self.cooldownDuration
end

function BaseAbility:isHot()
	return self.cooldown <= workspace:GetServerTimeNow()
end

function BaseAbility:destroyBase()
    table.clear(self)
end

return BaseAbility
