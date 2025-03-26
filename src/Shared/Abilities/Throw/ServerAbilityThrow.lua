-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BaseAbility = require(ReplicatedStorage.Abilities.BaseAbility)
-- Types
local TypeAbility = require(ReplicatedStorage.Types.TypeAbility)
-- Class
local ServerAbilityThrow = setmetatable({}, {__index = BaseAbility})
ServerAbilityThrow.__index = ServerAbilityThrow
-- Constants
local ABILITY_NAME = "Throw"

function ServerAbilityThrow.new(entity,tool,config)
	local self = setmetatable(BaseAbility.new(ABILITY_NAME,entity,tool,config) :: TypeAbility.BaseAbility, ServerAbilityThrow)

	self:setup()
	
	return self
end

function ServerAbilityThrow:setup()
	self:readAction(function()
		if self:isHot() then return end
		self:heat()
		print(`My man {self.entity.rig.Name} used throw.`)
	
		self.entity.backpack:removeTool(self.tool)
	end)
end

function ServerAbilityThrow:destroy()
	self:destroyBase()
	table.clear(self)
end

return ServerAbilityThrow