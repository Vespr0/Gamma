-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local BaseServerAbility = require(ServerScriptService.Main.Abilities.BaseServerAbility)
local TypeAbility = require(ReplicatedStorage.Types.TypeAbility)

-- Class
local ServerAbilityResourceRegeneration = setmetatable({}, BaseServerAbility)
ServerAbilityResourceRegeneration.__index = ServerAbilityResourceRegeneration

local ABILITY_NAME = "ResourceRegeneration"

function ServerAbilityResourceRegeneration.new(entity, tool, config)
	local self = setmetatable(
		BaseServerAbility.new(ABILITY_NAME, entity, tool, config) :: TypeAbility.BaseServerAbility,
		ServerAbilityResourceRegeneration
	)
	self.isServer = true
	self:setup()
	return self
end

function ServerAbilityResourceRegeneration:setup()
	-- Determine resource name
	-- Matches AmmoComponent pattern: ToolName + ResourceSuffix
	local resourceSuffix = self.abilityConfig.resource or "Ammo"
	self.resourceName = self.tool.Name .. resourceSuffix

	self:readAction(function(actionName)
		if actionName == "Reload" then
			self:reload()
		end
	end)
end

function ServerAbilityResourceRegeneration:reload()
	if self:isHot() then
		return
	end

	-- Check if resource exists and needs reloading
	local resource = self.entity.resources:getResource(self.resourceName)
	if not resource then
		warn("Resource not found: " .. tostring(self.resourceName))
		return
	end

	if resource.amount >= resource.maxAmount then
		return
	end

	self:heat() -- Starts cooldown

	-- Replicate start of reload to other clients (for animation)
	self:sendAction(nil, "Reload")

	-- Wait for the duration (reload time)
	local duration = self.abilityConfig.reloadDuration or self.cooldownDuration or 1

	task.delay(duration, function()
		if self.entity and self.entity.resources then
			if self.abilityConfig.regenerationType == "Incremental" then
				local amount = self.abilityConfig.amount or 1
				self.entity.resources:incrementResource(self.resourceName, amount)
			else
				-- Default to Full
				self.entity.resources:restoreResource(self.resourceName)
			end
		end
	end)
end

function ServerAbilityResourceRegeneration:destroy()
	self:destroyBase()
	table.clear(self)
end

return ServerAbilityResourceRegeneration
