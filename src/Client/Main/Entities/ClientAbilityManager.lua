-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Modules
local BaseAbilityManager = require(ReplicatedStorage.Classes.Bases.BaseAbilityManager)

-- Folders
local AbiltiesFolder = ReplicatedStorage.Abilities

local ClientAbilityManager = setmetatable({}, BaseAbilityManager)
ClientAbilityManager.__index = ClientAbilityManager

function ClientAbilityManager.new(clientBackpack)
	local self = setmetatable(BaseAbilityManager.new(clientBackpack), ClientAbilityManager)

	local RunService = game:GetService("RunService")
	RunService.RenderStepped:Connect(function(dt)
		for _, ability in pairs(self.abilities) do
			if ability.onRenderStepped then
				ability:onRenderStepped(dt)
			end
		end
	end)

	self:setup()
	return self
end

function ClientAbilityManager:setupAbility(tool, abilityConfig)
	local abilityName = abilityConfig.name
	local abilityFolder = AbiltiesFolder:FindFirstChild(abilityName)
	if not abilityFolder then
		warn(`Ability folder for "{abilityName}" not found`)
		return
	end

	local abilityModule = abilityFolder:FindFirstChild("ClientAbility" .. abilityName)
	if not abilityModule then
		warn(`ClientAbility module for "{abilityName}" not found`)
		return
	end

	local abilityClass = require(abilityModule)
	local identifier = tool.Name .. "-" .. abilityName .. "-" .. tool:GetAttribute("Index")
	self.abilities[identifier] = abilityClass.new(self.entity, tool, abilityConfig)
end

return ClientAbilityManager