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
local ServerAbilityMelee = setmetatable({}, {__index = BaseServerAbility})
ServerAbilityMelee.__index = ServerAbilityMelee
-- Constants
local ABILITY_NAME = "Melee"

function ServerAbilityMelee.new(entity,tool,config)
	local self = setmetatable(BaseServerAbility.new(ABILITY_NAME,entity,tool,config) :: TypeAbility.BaseServerAbility, ServerAbilityMelee)

	self:setup()
	
	return self
end

function ServerAbilityMelee:setup()
	self:readAction(function(actionName: string, entityID: number, hitPartName: string)
		if self:isHot() then return end
		self:heat()
        warn(actionName, entityID, hitPartName)
		DamageManager.Damage(entityID, self.entity.id, 10, nil)
	end)
end

function ServerAbilityMelee:destroy()
	self:destroyBase()
	table.clear(self)
end

return ServerAbilityMelee