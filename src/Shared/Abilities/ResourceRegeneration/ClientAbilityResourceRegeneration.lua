local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BaseClientAbility = require(Players.LocalPlayer.PlayerScripts.Main.Abilities.BaseClientAbility)
local TypeAbility = require(ReplicatedStorage.Types.TypeAbility)
local Inputs = require(Players.LocalPlayer.PlayerScripts.Main.Input.Inputs):get()
local SoundManager = require(Players.LocalPlayer.PlayerScripts.Main.Sound.SoundManager)

local ABILITY_NAME = "ResourceRegeneration"

local ClientAbilityResourceRegeneration = setmetatable({}, BaseClientAbility)
ClientAbilityResourceRegeneration.__index = ClientAbilityResourceRegeneration

function ClientAbilityResourceRegeneration.new(entity, tool, config)
	local self = setmetatable(
		BaseClientAbility.new(ABILITY_NAME, entity, tool, config) :: TypeAbility.BaseClientAbility,
		ClientAbilityResourceRegeneration
	)
	self.isServer = false
	self:setup()
	return self
end

function ClientAbilityResourceRegeneration:setup()
	local resourceSuffix = self.abilityConfig.resource or "Ammo"
	self.resourceName = self.tool.Name .. resourceSuffix

	if self.entity.isLocalPlayerInstance then
		self:setupInputs()
	end

	self:readAction(function(actionName)
		if actionName == "Reload" then
			if self.entity.isLocalPlayerInstance then
				return
			end
			-- Play reload animation/sound
			self:playReloadEffects()
		end
	end)

	if self.abilityConfig.animation then
		self.entity.animator:load(self.tool.Name, "Reload", self.abilityConfig.animation, "Action")
	end
end

function ClientAbilityResourceRegeneration:setupInputs()
	self.trove:Add(Inputs.events.ProcessedInputBegan:Connect(function(input)
		if not self:checkInputConditions() then
			return
		end

		if Inputs.IsValidInput(self.abilityConfig.inputs.activate, input) then
			self:trigger()
		end
	end))
end

function ClientAbilityResourceRegeneration:trigger()
	if self:isHot() then
		return
	end

	-- Optimistic check for ammo
	local resource = self.entity.resources:getResource(self.resourceName)
	if not resource then
		return
	end

	if resource.amount >= resource.maxAmount then
		return
	end

	self:heat()
	self:sendAction("Reload")
	self:playReloadEffects()
end

function ClientAbilityResourceRegeneration:playReloadEffects()
	if self.abilityConfig.sound then
		SoundManager.playSound({
			directory = self.abilityConfig.sound,
			parent = self:getCurrentFakeToolHandle(),
			category = "Effects",
			volume = 0.4,
		})
	end
	
	if self.abilityConfig.animation then
		self.entity.animator:play(self.tool.Name, "Reload", 0.1)
	end
end

function ClientAbilityResourceRegeneration:destroy()
	self:destroyBase()
	table.clear(self)
end

return ClientAbilityResourceRegeneration
