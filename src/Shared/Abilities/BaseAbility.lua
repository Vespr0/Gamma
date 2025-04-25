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

function BaseAbility:getCurrentFakeTool()
	if not self.entity then warn("Entity not found") return nil end
	if not self.entity.rig then warn("Entity rig not found") return nil end
	return self.entity.rig:FindFirstChildOfClass("Tool")
end

function BaseAbility:getCurrentFakeToolHandle()
	local tool = self:getCurrentFakeTool()
	if not tool then warn("Fake tool not found") return nil end
	if not tool.Model then warn("Fake tool model not found") return nil end
	return tool.Model.Handle
end

function BaseAbility:getCurrentFakeToolMuzzlePosition()
	local handle = self:getCurrentFakeToolHandle()
	if not handle then warn("Fake tool handle not found") return nil end
	local muzzle = handle:FindFirstChild("Muzzle")
	return muzzle.WorldPosition
end

function BaseAbility:readAction(func)
	if IS_SERVER then
		self.trove:Add(AbilitiesMiddleware.ReadAbility:Connect(function(entityID: number,abilityName: string, toolIndex: number,...)
			if self.entity.id ~= entityID then return end
			if abilityName ~= self.name then return end
			if toolIndex ~= self.tool:GetAttribute("Index") then return end
			
			func(...)
		end))
	else
		self.trove:Add(AbilitiesMiddleware.ReadAbility:Connect(function(entityID: number,abilityName: string, toolIndex: number,...)
			if self.entity.id ~= entityID then return end
			if abilityName ~= self.name then return end
			if toolIndex ~= self.tool:GetAttribute("Index") then return end

			func(...)
		end))
	end
end

function BaseAbility:sendAction(...)
	if IS_SERVER then
		--[[  
			Not the player that controls the entity associated with this instance, but rather the player
		    that needs to replicate the entity's ability in his client.
		]]
		local args = {...}
		local replicationPlayer = args[1]
		return AbilitiesMiddleware.SendAbility:Fire(replicationPlayer, self.entity.id, self.name, self.tool:GetAttribute("Index"), select(2, ...))
	else
		-- Client doesn't need to send entity id since only players initiate ability requests
		return AbilitiesMiddleware.SendAbility:Fire(self.name, self.tool:GetAttribute("Index"), ...)
	end
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
