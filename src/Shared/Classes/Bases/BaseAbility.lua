local BaseAbility = {}
BaseAbility.__index = BaseAbility

-- Services 
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local Item = require(ReplicatedStorage.Classes.Item)
local AbilitiesMiddleware = require(ReplicatedStorage.Middleware.MiddlewareManager).Get("Abilities")
-- Constants
local IS_SERVER = RunService:IsServer()

function BaseAbility.new(item,name: string,config)
    local self = setmetatable({}, BaseAbility)

	if not item then error("Item is missing") return end
	if not name then error("Ability name is missing") return end
	if not config then error("Ability configuration is missing") return end
	
	-- Basic info
	self.name = name
	self.config = config

    -- Variables 
	self.item = item
	
	-- Cooldown
	self.cooldownDuration = self.config.CooldownDuration
	self.cooldown = 0

    return self
end

function BaseAbility:readAction(func)
	AbilitiesMiddleware.ReadAbilityAction:Connect(function(player: Player,abilityName: string,...)
		if not self.item.owner then error(`Item has been used but has no owner.`) return end
		
		if not self.item.owner.player then return end
		
		-- Make sure the right player is requesting.
		if player ~= self.item.owner.player then return end
		
		if abilityName ~= self.name then return end
		func(player,...)
	end)
end

function BaseAbility:sendAction(...)
	return AbilitiesMiddleware.SendAbilityAction(self.name,...)
end

function BaseAbility:isToolEquipped()
	return self.item.equipped
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
