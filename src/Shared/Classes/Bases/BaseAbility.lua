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

function BaseAbility.new(tool,name: string,config)
    local self = setmetatable({}, BaseAbility)

	if not tool then error("Item is missing") return end
	if not name then error("Ability name is missing") return end
	if not config then error("Ability configuration is missing") return end
	
	-- Basic info
	self.name = name
	self.config = config

    -- Variables 
	self.tool = tool
	
	-- Cooldown
	self.cooldownDuration = self.config.CooldownDuration
	self.cooldown = 0

    return self
end

function BaseAbility:readAction(func)
	AbilitiesMiddleware.ReadAbilityAction:Connect(function(player: Player,abilityName: string,...)
		local player = Players:GetPlayerByUserId(player.UserId)
		local toolPlayer = Players:GetPlayerByUserId(self.tool:GetAttribute("Owner"))
		if not toolPlayer then error(`Item has been used but has no owner.`) return end
		
		if not toolPlayer then return end
		
		-- Make sure the right player is requesting.
		if player ~= toolPlayer then return end
		
		if abilityName ~= self.name then return end
		func(player,...)
	end)
end

function BaseAbility:sendAction(...)
	return AbilitiesMiddleware.SendAbilityAction(self.name,...)
end

function BaseAbility:isToolEquip()
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
