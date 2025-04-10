-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local BaseServerAbility = require(ServerScriptService.Main.Abilities.BaseServerAbility)
local Remotes = ReplicatedStorage.Remotes
-- Types
local TypeAbility = require(ReplicatedStorage.Types.TypeAbility)
-- Modules
local DamageManager = require(ServerScriptService.Main.Abilities.DamageManager)
local ProjectileManager = require(ReplicatedStorage.Abilities.ProjectileManager)
-- Class
local ServerAbilityProjectile = setmetatable({}, {__index = BaseServerAbility})
ServerAbilityProjectile.__index = ServerAbilityProjectile
-- Constants
local ABILITY_NAME = "Projectile"

function ServerAbilityProjectile.new(entity,tool,config)
	local self = setmetatable(BaseServerAbility.new(ABILITY_NAME,entity,tool,config) :: TypeAbility.BaseServerAbility, ServerAbilityProjectile)

	self:setup()
	
	return self
end


function ServerAbilityProjectile:fire(direction: Vector3)
	for _, player in Players:GetChildren() do
		if player == self.entity.player then continue end -- Skip the player that controls this entity
		self:sendAction(player, "Fire", direction)
	end
end

function ServerAbilityProjectile:processAction(actionName: string, arg1: any)
	if actionName == "Fire" then
		local direction = arg1
		self:fire(direction)
	end
end

function ServerAbilityProjectile:setup()
	-- Setup MindController for NPCs
	if self.mindController then
		self.mindController:Connect(function(actionName: string, ...)
			self:processAction(actionName, ...)
		end)
	end

	self:readAction(function(actionName: string, ...)
		self:processAction(actionName, ...)
	end)
end

function ServerAbilityProjectile:destroy()
	self:destroyBase()
	table.clear(self)
end

return ServerAbilityProjectile