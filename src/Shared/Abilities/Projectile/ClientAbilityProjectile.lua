local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Constants
local ABILITY_NAME = "Projectile"

-- Dependencies
local Player = Players.LocalPlayer
local BaseClientAbility = require(Player.PlayerScripts.Main.Abilities.BaseClientAbility)
local TypeAbility = require(ReplicatedStorage.Types.TypeAbility)
local Inputs = require(Player.PlayerScripts.Main.Input.Inputs):get()
-- local ProjectileManager = require(script.Parent.Parent.ProjectileManager)
local SoundManager = require(Player.PlayerScripts.Main.Sound.SoundManager)
local BulletHoleVFX = require(Player.PlayerScripts.Main.Visual.VFXManager).GetModule("BulletHole")
local AssetsDealer = require(ReplicatedStorage.AssetsDealer)

local ClientAbilityProjectile = setmetatable({}, { __index = BaseClientAbility })
ClientAbilityProjectile.__index = ClientAbilityProjectile

function ClientAbilityProjectile.new(entity, tool, config)
	local self = setmetatable(
		BaseClientAbility.new(ABILITY_NAME, entity, tool, config) :: TypeAbility.BaseClientAbility,
		ClientAbilityProjectile
	)

	self:setup()

	self.proceduralRecoil = self.entity.proceduralAnimationController:getComponent("ProceduralRecoil")

	self.lastFireTime = os.clock()
	print(self.entity)
	-- self.recoilMotor = self.entity.motor6DManager:getModule("Motor6DRecoil")

	return self
end

function ClientAbilityProjectile:playFireSound()
	-- Handle continuous and one-shot fire sounds
	if self.abilityConfig.continuousFire then
		-- Looping weapon
		if self.fireSound and self.fireSound.Playing then
			return
		end
		if self.fireSound then
			SoundManager.StopSound(self.fireSound)
		end
		self.fireSound = SoundManager.New(self.abilityConfig.sound, self:getCurrentFakeToolHandle(), "Effects")
		SoundManager.Play(self.fireSound, 0.4, true, 0.1)
		self.fireSound.RollOffMaxDistance = 100
		self.fireSound.RollOffMinDistance = 20
		return
	end

	-- One-shot weapon: play fresh sound in PlayerGui
	if self.fireSound then
		SoundManager.StopSound(self.fireSound)
		self.fireSound = nil
	end
	-- Create and play one-shot sound under PlayerGui
	local parent = Player:WaitForChild("PlayerGui")
	local newSound = SoundManager.New(self.abilityConfig.sound, parent, "Effects")
	SoundManager.Play(newSound, 0.4)
	newSound.RollOffMaxDistance = 100
	newSound.RollOffMinDistance = 20
	return
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
	-- local root = self.entity.root

	-- local muzzlePosition = self:getCurrentFakeToolMuzzlePosition()

	-- Step 1: Raycast from the camera to determine the aim point
	-- local rayOrigin = camera.CFrame.Position
	-- local rayDirection = camera.CFrame.LookVector * 1000 -- cast far
	-- local raycastParams = RaycastParams.new()
	-- raycastParams.FilterDescendantsInstances = {self.entity.rig}
	-- raycastParams.FilterType = Enum.RaycastFilterType.Exclude

	-- By default raycast to the camera direction to get the direction to shoot at whilist
	-- keeping the origin at the muzzle position (no need to shoot from the camera position)
	-- if not direction then
	--     local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	--     local targetPoint = raycastResult and raycastResult.Position or (rayOrigin + rayDirection)
	--     direction = (targetPoint - muzzlePosition).Unit
	-- end
	local position = self:getOrigin()
	local clientDirection = self:getBiasedDirection(self:getDirection())
	direction = direction or clientDirection

	local projectileConfig = self.abilityConfig.projectileConfig
	projectileConfig.origin = position
	projectileConfig.direction = direction
	projectileConfig.raycastBlacklist = { self.entity.rig }
	if self.entity.isLocalPlayerInstance then
		table.insert(projectileConfig.raycastBlacklist, workspace.CurrentCamera)
	end
	projectileConfig.sourceEntityID = self.entity.id
	projectileConfig.damage = self.abilityConfig.damage or 10
	projectileConfig.clientReplicationBlacklist = { Player.UserId }

	-- Fire using GammaCast
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local GammaCast = require(ReplicatedStorage.Abilities.Projectile.GammaCast)
	local typeName = self.abilityConfig.projectileType or "Bullet"
	local origin = position
	local modifiers = self.abilityConfig.projectileModifiers or nil
	GammaCast.CastClient(self.entity.id, typeName, origin, direction, modifiers)

	return direction
end

function ClientAbilityProjectile:setupInputs()
	self.isFiring = false
	self.fireSound = nil

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
	if self:isHot() then
		return
	end
	self:heat()
	local biasedDirection = self:fire(direction)
	if sendToServer then
		self:sendFire(biasedDirection)
	end
	self.lastFireTime = os.clock()
end

function ClientAbilityProjectile:setup()
	-- Setup inputs for the local player
	if self.entity.isLocalPlayerInstance then
		self:setupInputs()
	end

	-- Tool unequipped handler
	self.trove:Add(self.events.Unequipped:Connect(function()
		self.isFiring = false
		if self.fireSound then
			SoundManager.FadeOut(self.fireSound, 0.2)
		end
	end))

	-- Sound stop handler
	self.trove:Add(RunService.RenderStepped:Connect(function()
		if not self.fireSound then
			return
		end
		if not self.abilityConfig.continuousFire then
			return
		end
		if not self.fireSound.Playing then
			return
		end

		if os.clock() - self.lastFireTime > self.abilityConfig.cooldownDuration + 0.2 then
			-- Stop sound if it's not firing
			SoundManager.FadeOut(self.fireSound, 0.2)
		end
	end))

	-- Continuous fire handler
	self.trove:Add(RunService.RenderStepped:Connect(function()
		if not self.isFiring then
			return
		end
		self:trigger(true, nil)
	end))

	-- Setup replication
	self:readAction(function(actionName: string, arg1: any)
		if actionName == "Fire" then
			local direction = arg1
			self:trigger(false, direction)
		end
	end)
end

function ClientAbilityProjectile:destroy()
	if self.fireSound then
		self.fireSound:Destroy()
	end
	self:destroySub()
end

return ClientAbilityProjectile
