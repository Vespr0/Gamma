local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BaseAbility = require(ReplicatedStorage.Abilities.BaseAbility)
local TypeAbility = require(ReplicatedStorage.Types.TypeAbility)
local Signal = require(ReplicatedStorage.Packages.signal)
local Highlighter = require(ReplicatedStorage.Utility.Highlighter)
local Inputs = require(game:GetService("Players").LocalPlayer.PlayerScripts.Main.Input.Inputs)
local ItemInput = Inputs.GetModule("Item")

local ClientAbilityThrow = setmetatable({}, {__index = BaseAbility})
ClientAbilityThrow.__index = ClientAbilityThrow
-- Constants
local ABILITY_NAME = "Throw"

function ClientAbilityThrow.new(entity,tool,config)
	local self = setmetatable(BaseAbility.new(ABILITY_NAME,entity,tool,config) :: TypeAbility.BaseAbility, ClientAbilityThrow)

	self:setup()
	return self
end

function ClientAbilityThrow:activate()
	if self:isHot() then return end
	self:heat()

	self.entity.backpack:unequipTool()

	self:sendAction()
end

function ClientAbilityThrow:setupInputs()
	ItemInput.BeganEvent:Connect(function(action)
		if not self:checkInputConditions() then return end
		if action == "THROW" then
			self:activate()
		end
	end)
end

function ClientAbilityThrow:setup()
	-- Setup inputs for the local player
	if self.entity.isLocalPlayerInstance then self:setupInputs() end
end

function ClientAbilityThrow:destroy()
	self:destroyBase()
	table.clear(self)
end

return ClientAbilityThrow