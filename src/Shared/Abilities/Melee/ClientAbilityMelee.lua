local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer
local BaseClientAbility = require(Player.PlayerScripts.Main.Abilities.BaseClientAbility)

local TypeAbility = require(ReplicatedStorage.Types.TypeAbility)
local Signal = require(ReplicatedStorage.Packages.signal)
local Highlighter = require(ReplicatedStorage.Utility.Highlighter)
local Inputs = require(game:GetService("Players").LocalPlayer.PlayerScripts.Main.Input.Inputs):get()
local MeleeUtility = require(script.Parent.Parent.MeleeUtility)
local SoundPlayer = require(Player.PlayerScripts.Main.Sound.SoundPlayer)

local ClientAbilityThrow = setmetatable({}, {__index = BaseClientAbility})
ClientAbilityThrow.__index = ClientAbilityThrow
-- Constants
local ABILITY_NAME = "Melee"

function ClientAbilityThrow.new(entity,tool,config)
	local self = setmetatable(BaseClientAbility.new(ABILITY_NAME,entity,tool,config) :: TypeAbility.BaseClientAbility, ClientAbilityThrow)

	print(self.loadAnimation)

	self:setup()

	return self
end

function ClientAbilityThrow:activate()
	if self:isHot() then return end
	self:heat()

	if self.hitbox then self.hitbox:Destroy() end

	self.hitbox = MeleeUtility.CreateHitbox(self.entity.rig)

	self.hitbox.Hit:Connect(function(entityID, hitPartName)
		SoundPlayer.PlaySound("Tools/Sword/FleshSlash",0.5)
		self:sendAction("Damage",entityID, hitPartName)
	end)

	self:playAnimation("Activation")

	print(self.hitbox)
	task.spawn(function()
		task.wait(0.2)
		SoundPlayer.PlaySound("Tools/Sword/Swing",0.5)
		self.hitbox:HitStart()
		task.wait(0.4)
		self.hitbox:HitStop()
	end)
end

function ClientAbilityThrow:setupInputs()
	self.trove:Add(Inputs.events.InputBegan:Connect(function(input)
		if not self:checkInputConditions() then return end

		local activationInputs = self.abilityConfig.inputs.activate
		if Inputs.IsValidInput(activationInputs, input) then
			self:activate()
		end
	end))
end

function ClientAbilityThrow:setup()
	-- Setup animation
	self:loadAnimation("Activation", self.abilityConfig.animation)	
	-- Setup inputs for the local player
	if self.entity.isLocalPlayerInstance then self:setupInputs() end
end

function ClientAbilityThrow:destroy()
	self:destroySub()
end

return ClientAbilityThrow