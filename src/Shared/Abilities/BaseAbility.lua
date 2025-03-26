local BaseAbility = {}
BaseAbility.__index = BaseAbility

-- Services 
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local Trove = require(ReplicatedStorage.Packages.trove)
local TypeEntity = require(ReplicatedStorage.Types.TypeEntity)
local ToolUtility = require(ReplicatedStorage.Utility.ToolUtility)
-- Network
local AbilitiesMiddleware = require(ReplicatedStorage.Middleware.MiddlewareManager).Get("Abilities")
-- Constants
local IS_SERVER = RunService:IsServer()

function BaseAbility.new(name: string, entity: TypeEntity.BaseEntity, tool, abilityConfig)
    local self = setmetatable({}, BaseAbility)

	if not name then error("Ability name is missing"); return end
	if not entity then error("Entity is missing"); return end
	if not tool then error("Tool is missing"); return end
	if not abilityConfig then error("Ability configuration is missing"); return end
	
	-- Basic info
	self.entity = entity
	self.name = name
	self.abilityConfig = abilityConfig
	self.toolConfig = require(ToolUtility.GetAsset(tool.Name):FindFirstChild("Config"))

    -- Variables 
	self.tool = tool
	
	-- Cooldown
	self.cooldownDuration = self.abilityConfig.cooldownDuration
	self.cooldown = 0

	self.trove = Trove.new()
	self.events = {
		Destroyed = Signal.new(),
		Equipped = Signal.new(),
		Unequipped = Signal.new(),
	}

	self:setup()

    return self
end

function BaseAbility:setup()
	-- Garbage collection
	self.trove:Add(self.entity.events.Died:Connect(function()
		self.events.Destroyed:Fire()
	end))
	self.trove:Add(self.tool.Destroying:Connect(function()
		self.events.Destroyed:Fire() 
	end))
	self.trove:Add(self.events.Destroyed:Connect(function()
		if self.destroy then self:destroy() end
	end))
end

function BaseAbility:readAction(func)
	print(AbilitiesMiddleware)
	self.trove:Add(AbilitiesMiddleware.ReadAbility:Connect(function(entityID: number,abilityName: string, toolIndex: number,...)
		print(entityID,abilityName,toolIndex,...)
		if self.entity.id ~= entityID then return end
		if abilityName ~= self.name then return end
		if toolIndex ~= self.tool:GetAttribute("Index") then return end

		func(...)
	end))
end

function BaseAbility:getFakeTool()
	return self.tool
end

function BaseAbility:sendAction(...)
	return AbilitiesMiddleware.SendAbility:Fire(self.name,self.tool:GetAttribute("Index"),...)
end

function BaseAbility:isToolEquipped()
	return self.tool:GetAttribute("Equipped")
end

function BaseAbility:heat()
	self.cooldown = workspace:GetServerTimeNow() + self.cooldownDuration
end

function BaseAbility:isHot()
	return self.cooldown > workspace:GetServerTimeNow()
end

function BaseAbility:destroyBase()
	self.trove:Destroy()
end

return BaseAbility
