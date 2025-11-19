-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local BaseAbilityManager = require(ReplicatedStorage.Classes.Bases.BaseAbilityManager)

-- Folders
local AbiltiesFolder = ReplicatedStorage.Abilities

local ServerAbilityManager = setmetatable({}, BaseAbilityManager)
ServerAbilityManager.__index = ServerAbilityManager

function ServerAbilityManager.new(serverBackpack)
	local self = setmetatable(BaseAbilityManager.new(serverBackpack), ServerAbilityManager)
	self.player = self.entity.player
	self:setup()
	return self
end

function ServerAbilityManager:getMindController(toolName: string, abilityName: string, index: number)
	local identifier = toolName .. "-" .. abilityName .. "-" .. index
	local ability = self.abilities[identifier]

	if not ability then
		warn("Ability not found for getMindController:", identifier)
		return
	end

	if not self.player then
		return ability.mindController
	else
		warn(`Cannot get mind controller for a player controlled entity.`)
		return nil
	end
end

function ServerAbilityManager:setupAbility(tool, abilityConfig)
	local abilityName = abilityConfig.name
	local abilityFolder = AbiltiesFolder:FindFirstChild(abilityName)
	if not abilityFolder then
		warn(`Ability folder for "{abilityName}" not found`)
		return
	end

	local abilityModule = abilityFolder:FindFirstChild("ServerAbility" .. abilityName)
	if not abilityModule then
		-- Not all abilities have a server side
		return
	end

	local abilityClass = require(abilityModule)
	local identifier = tool.Name .. "-" .. abilityName .. "-" .. tool:GetAttribute("Index")
	self.abilities[identifier] = abilityClass.new(self.entity, tool, abilityConfig)
end

return ServerAbilityManager