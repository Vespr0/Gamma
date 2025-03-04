-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BaseAbility = require(ReplicatedStorage.Classes.Bases.BaseAbility)

local ServerAbilityThrow = setmetatable({}, {__index = BaseAbility})
ServerAbilityThrow.__index = ServerAbilityThrow

-- Variables
local singleton = nil
-- Constants
local ABILITY_NAME = "Throw"

-- function ServerAbilityThrow.new(entity,tool,config)
-- 	local self = setmetatable(BaseAbility.new(entity,tool,ABILITY_NAME,config), ServerAbilityThrow)

-- 	self:setup()

-- 	-- Events
-- 	warn(item)
	
-- 	return self
-- end

-- function ServerAbilityThrow:setup()
-- 	self:readAction(function(player: Player,chargeDuration: number)
-- 		print(`My man {player.DisplayName} used throw.`)
-- 	end)
-- end

-- function ServerAbilityThrow:destroy()
-- 	self:destroyBase()
-- 	table.clear(self)
-- end

-- function ServerAbilityThrow.Init()
-- 	singleton = ServerAbilityThrow.new()
-- end

return ServerAbilityThrow