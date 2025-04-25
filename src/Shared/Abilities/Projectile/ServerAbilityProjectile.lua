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
-- local ProjectileManager = require(ReplicatedStorage.Abilities.ProjectileManager)
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

function ServerAbilityProjectile:verifyOrigin(origin: Vector3): boolean
	local distance = (origin - self.entity.rig.Head.Position).Magnitude
	if distance > 3 then
		warn("Origin is too far from the player.")
		return false
	end

	return true
end


function ServerAbilityProjectile:fire(direction: Vector3, origin: Vector3,clientTimestamp: number)

	-- TODO: Verify Origin

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local GammaCast = require(ReplicatedStorage.Abilities.Projectile.GammaCast)
    local entityID = self.entity.id
    local player = self.entity.player
    local typeName = self.abilityConfig.projectileType or "Bullet"
    local modifiers = self.abilityConfig.projectileModifiers or nil

    local result = GammaCast.CastServer(player, typeName, origin, direction, clientTimestamp, modifiers)
    -- Apply damage using DamageManager if SimulationResult indicates a hit
    if result and result.Rig then
        local hitInstance = result.Rig
        local hitRig = hitInstance
        while hitRig and not hitRig:GetAttribute("ID") do
            hitRig = hitRig.Parent
        end
        if hitRig then
            local targetEntityID = hitRig:GetAttribute("ID")
            local damageAmount = self.abilityConfig.damage or 0
            DamageManager.Damage(targetEntityID, entityID, damageAmount)
        end
    end
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player then
            GammaCast.RemoteEvent:FireClient(other, entityID, typeName, origin, direction, modifiers)
        end
    end
end

function ServerAbilityProjectile:processAction(actionName: string, arg1: any, arg2: any, arg3: any)
	if actionName == "Fire" then
		local direction = arg1
		local origin = arg2
		local clientTimestamp = arg3
		self:fire(direction, origin, clientTimestamp)
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