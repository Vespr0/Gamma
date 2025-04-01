-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local BaseServerAbility = require(ServerScriptService.Main.Abilities.BaseServerAbility)
-- Types
local TypeAbility = require(ReplicatedStorage.Types.TypeAbility)
-- Modules
local DamageManager = require(ServerScriptService.Main.Abilities.DamageManager)
-- Class
local ServerAbilityProjectile = setmetatable({}, {__index = BaseServerAbility})
ServerAbilityProjectile.__index = ServerAbilityProjectile
-- Constants
local ABILITY_NAME = "Melee"

function ServerAbilityProjectile.new(entity,tool,config)
	local self = setmetatable(BaseServerAbility.new(ABILITY_NAME,entity,tool,config) :: TypeAbility.BaseServerAbility, ServerAbilityProjectile)

	self:setup()
	
	return self
end

function ServerAbilityProjectile:setup()
	self:readAction(function(actionName: string, entityID: number, hitPartName: string)
		if self:isHot() then return end
		self:heat()
        warn(actionName, entityID, hitPartName)
		DamageManager.Damage(entityID, self.entity.id, 10, nil)
	end)
end

function ServerAbilityProjectile:destroy()
	self:destroyBase()
	table.clear(self)
end

return ServerAbilityProjectile