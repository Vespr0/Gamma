-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local ConfigUtility = require(ReplicatedStorage.Configs.ConfigUtility)

-- Folders
local AbiltiesFolder = ReplicatedStorage.Abilities

local BaseAbilityManager = {}
BaseAbilityManager.__index = BaseAbilityManager

function BaseAbilityManager.new(backpack)
	local self = setmetatable({}, BaseAbilityManager)

	if not backpack then
		error("Backpack is missing")
	end

	self.abilities = {}
	self.backpack = backpack
	self.entity = backpack.entity

	return self
end

function BaseAbilityManager:setup()
	-- For each tool get it's abilities
	for _, tool in self.backpack.tools:GetChildren() do
		self:setupTool(tool)
	end

	self.backpack.events.ToolAdded:Connect(function(tool)
		self:setupTool(tool)
	end)

	self.backpack.events.ToolEquip:Connect(function(tool, index)
		for _, ability in pairs(self.abilities) do
			if ability.tool:GetAttribute("Index") == index then
				if ability.onToolEquip then
					ability:onToolEquip(tool, index)
				end
			end
		end
	end)

	self.backpack.events.ToolUnequip:Connect(function(tool, index)
		for _, ability in pairs(self.abilities) do
			if ability.tool:GetAttribute("Index") == index then
				if ability.onToolUnequip then
					ability:onToolUnequip(tool, index)
				end
			end
		end
	end)
end

function BaseAbilityManager:setupTool(tool)
	local name = tool.Name
	local config = ConfigUtility.GetConfig("Tools", name)

	if not config or not config.abilities then
		return
	end

	for _, abilityConfig in config.abilities do
		-- This will be implemented by child classes
		self:setupAbility(tool, abilityConfig)
	end
end

-- function BaseAbilityManager:setupAbility(tool, abilityConfig)

return BaseAbilityManager
