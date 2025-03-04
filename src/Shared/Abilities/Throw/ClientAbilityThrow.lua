local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BaseAbility = require(ReplicatedStorage.Classes.Bases.BaseAbility)
local TypeAbility = require(ReplicatedStorage.Types.TypeAbility)
local Signal = require(ReplicatedStorage.Packages.signal)
local Highlighter = require(ReplicatedStorage.Utility.Highlighter)
local Inputs = require(game:GetService("Players").LocalPlayer.PlayerScripts.Main.Input.Inputs):get()

local ClientAbilityThrow = setmetatable({}, {__index = BaseAbility})
ClientAbilityThrow.__index = ClientAbilityThrow
-- Constants
local ABILITY_NAME = "Throw"

function ClientAbilityThrow.new(entity,tool,config)
	local self = setmetatable(BaseAbility.new(ABILITY_NAME,entity,tool,config) :: TypeAbility.BaseAbility, ClientAbilityThrow)

	self:setup()
	print("Throw instantiated from Client")
	return self
end

function ClientAbilityThrow:activate()
	print("Throw activated from Client")
	if self:isHot() then return end
	self:heat()

	Highlighter.mark(self.entity.backpack:getDummyTool()) -- Debug
end

function ClientAbilityThrow:setupInputs()
	Inputs.events.InputBegan:Connect(function(input)
		local dummyTool = self.entity.backpack:getDummyTool()
		if not dummyTool then return end
		
		if dummyTool:GetAttribute("ID") ~= self.tool:GetAttribute("ID") then return end

		local activationInputs = self.config.inputs.activate
		if Inputs.IsValidKey(activationInputs, input.KeyCode) then
			self:activate()
		end
	end)
end

function ClientAbilityThrow:setup()
	-- Setup inputs for the local player
	if self.entity.isLocalPlayer then self:setupInputs() end

	Highlighter.mark(self.entity.rig.Head) -- Debug
end

function ClientAbilityThrow:destroy()
	self:destroyBase()
	table.clear(self)
end

return ClientAbilityThrow