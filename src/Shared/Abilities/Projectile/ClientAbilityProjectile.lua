local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Constants
local ABILITY_NAME = "Projectile"

-- Dependencies
local Player = Players.LocalPlayer
local BaseClientAbility = require(Player.PlayerScripts.Main.Abilities.BaseClientAbility)
local AmmoComponent = require(ReplicatedStorage.Abilities.Projectile.AmmoComponent)
local TypeAbility = require(ReplicatedStorage.Types.TypeAbility)
local Inputs = require(Player.PlayerScripts.Main.Input.Inputs):get()
local SoundManager = require(Player.PlayerScripts.Main.Sound.SoundManager)
local BulletHoleVFX = require(Player.PlayerScripts.Main.Visual.VFXManager).GetModule("BulletHole")
local ClientProjectileVisuals = require(script.Parent.ClientProjectileVisuals)
local GammaCast = require(ReplicatedStorage.Abilities.Projectile.GammaCast)
local Simulation = require(ReplicatedStorage.Abilities.Projectile.GammaCast.Simulation)

local ClientAbilityProjectile = setmetatable({}, BaseClientAbility)
ClientAbilityProjectile.__index = ClientAbilityProjectile

function ClientAbilityProjectile.new(entity, tool, config)
	local self = setmetatable(
		BaseClientAbility.new(ABILITY_NAME, entity, tool, config) :: TypeAbility.BaseClientAbility,
		ClientAbilityProjectile
	)
	self.isServer = false
	self.ammoComponent = AmmoComponent.new(self, entity)
	self.visuals = ClientProjectileVisuals.new()
	self:setup()

	self.proceduralRecoil = self.entity.proceduralAnimationController:getComponent("ProceduralRecoil")

	self.lastFireTime = os.clock()
	self.lastEmptyClickTime = 0

	return self
end

function ClientAbilityProjectile:playFireSound()
	if self.abilityConfig.continuousFire then
		-- Looping weapon: ensure sound is playing
		if self.fireSound then
			self.fireSound:Play(0.4, true, 0.1)
		end
		return
	end

	-- One-shot weapon: play a new sound every time
	SoundManager.playSound({
		directory = self.abilityConfig.sound,
		parent = Players.LocalPlayer:WaitForChild("PlayerGui"),
		category = "Effects",
		volume = 0.4,
	})
end

function ClientAbilityProjectile:processHit(result)
	warn("Processing hit:", result)
	local position = result.Position
	local normal = result.Normal
	local instance = result.Instance

	if not instance then
		return
	end

	BulletHoleVFX:play(instance, position, normal)
end

function ClientAbilityProjectile:getBiasedDirection(direction: Vector3)
	direction = direction or workspace.CurrentCamera.CFrame.LookVector
	local cframe = self.entity.root.CFrame
	local spread = self.abilityConfig.spread

	-- Use a seed thats keeps spread consistent with other clients.
	local random = Random.new(workspace:GetServerTimeNow())

	local function getSpread()
		return random:NextInteger(-spread, spread) / 100
	end
	local horizontalBias = getSpread()
	local verticalBias = getSpread()

	return direction + cframe.RightVector * horizontalBias + cframe.UpVector * verticalBias
end

-- TODO: Use camera controller
function ClientAbilityProjectile:getOrigin()
	if self.entity.isLocalPlayerInstance then
		local camera = workspace.CurrentCamera
		return camera.CFrame.Position
	else
		return self.entity.rig.Head.Position
	end
end

function ClientAbilityProjectile:getDirection()
	if self.entity.isLocalPlayerInstance then
		return workspace.CurrentCamera.CFrame.LookVector
	else
		return self.entity.root.CFrame.LookVector
	end
end

function ClientAbilityProjectile:fire(direction)
	self:playFireSound()

	if self.abilityConfig.recoil and self.entity.isLocalPlayerInstance then
		self.proceduralRecoil:applyRecoil(self.abilityConfig.recoil.vertical, self.abilityConfig.recoil.horizontal)
	end

	local position = self:getOrigin()
	local clientDirection = self:getBiasedDirection(self:getDirection())
	direction = direction or clientDirection

	local typeName = self.abilityConfig.projectileType or "Bullet"
	local modifiers = self.abilityConfig.projectileModifiers or nil

	-- Create the simulation object
	local simulation = Simulation.new(self.entity.id, typeName, position, direction, nil, modifiers, true)

	-- Delegate the simulation and visual playback to the visual component
	self.visuals:play(simulation)

	-- Fire to server WITH the client's current time for lag compensation
	local clientTimestamp = workspace:GetServerTimeNow()
	GammaCast.RemoteEvent:FireServer(typeName, position, direction, clientTimestamp, modifiers)

	return direction
end

function ClientAbilityProjectile:setupInputs()
	self.isFiring = false

	-- Input began handler
	self.trove:Add(Inputs.events.ProcessedInputBegan:Connect(function(input)
		if not self:checkInputConditions() then
			return
		end

		if Inputs.IsValidInput(self.abilityConfig.inputs.activate, input) then
			self.isFiring = true
		end
	end))

	-- Input ended handler
	self.trove:Add(Inputs.events.ProcessedInputEnded:Connect(function(input)
		if not self:checkInputConditions() then
			return
		end

		if self.isFiring and Inputs.IsValidInput(self.abilityConfig.inputs.activate, input) then
			self.isFiring = false
		end
	end))
end

function ClientAbilityProjectile:sendFire(biasedDirection: Vector3)
	local origin = self:getOrigin()
	local clientTimestamp = workspace:GetServerTimeNow()
	self:sendAction("Fire", biasedDirection, origin, clientTimestamp)
end

function ClientAbilityProjectile:trigger(sendToServer: boolean, direction: Vector3)
	if sendToServer then
		if self:isHot() then
			return
		end
	end

	if self.ammoComponent:isOutOfAmmo() then
		if os.clock() - self.lastEmptyClickTime > 0.3 then
			SoundManager.playSound({
				directory = "Tools/Generic/EmptyGun",
				parent = self:getCurrentFakeToolHandle(),
				category = "Effects",
				volume = 0.1,
			})
			self.lastEmptyClickTime = os.clock()
		end
		return
	end

	self:heat()

	-- Get the biased direction *before* spawning a new thread
	local biasedDirection = self:getBiasedDirection(self:getDirection())

	-- Send the notification to the server immediately
	if sendToServer then
		self:sendFire(biasedDirection)
	end

	-- Run the client-side simulation in a separate, non-blocking thread
	task.spawn(function()
		self:fire(biasedDirection)
	end)

	self.lastFireTime = os.clock()
end

function ClientAbilityProjectile:onRenderStepped(dt)
	-- Sound stop handler
	if self.fireSound and self.abilityConfig.continuousFire and not self.isFiring then
		if os.clock() - self.lastFireTime > self.abilityConfig.cooldownDuration + 0.2 then
			-- Stop sound if it's not firing
			self.fireSound:FadeOut(0.2)
			self.fireSound = nil
		end
	end

	-- Continuous fire handler
	if self.isFiring then
		self:trigger(true, nil)
	end
end

function ClientAbilityProjectile:onToolEquip(tool, index)
	self.isFiring = false

	-- Create looping fire sound if needed
	if self.abilityConfig.continuousFire then
		task.spawn(function()
			self:waitForFakeTool()
			self.fireSound = SoundManager.createSound({
				directory = self.abilityConfig.sound,
				parent = self:getCurrentFakeToolHandle(),
				category = "Effects",
			})
		end)
	end
end

-- function ClientAbilityProjectile:onToolUnequip(tool, index)
-- 	self.isFiring = false
-- end

function ClientAbilityProjectile:setup()
	self.ammoComponent:setupResource()

	-- Setup inputs for the local player
	if self.entity.isLocalPlayerInstance then
		self:setupInputs()
	end

	-- Setup replication
	self:readAction(function(actionName: string, arg1: any)
		if actionName == "Fire" then
			if self.entity.isLocalPlayerInstance then
				return
			end
			local direction = arg1
			self:trigger(false, direction)
		end
	end)
end

function ClientAbilityProjectile:destroy()
	if self.fireSound then
		self.fireSound:Destroy()
		self.fireSound = nil
	end
	self.visuals:destroy()
	self:destroySub()
end

return ClientAbilityProjectile
