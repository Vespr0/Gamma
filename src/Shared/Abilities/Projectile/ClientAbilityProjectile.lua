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
local ProjectileManager = require(script.Parent.Parent.ProjectileManager)
local SoundPlayer = require(Player.PlayerScripts.Main.Sound.SoundPlayer)

local ClientAbilityProjectile = setmetatable({}, {__index = BaseClientAbility})
ClientAbilityProjectile.__index = ClientAbilityProjectile

function ClientAbilityProjectile.new(entity, tool, config)
	local self = setmetatable(BaseClientAbility.new(ABILITY_NAME, entity, tool, config) :: TypeAbility.BaseClientAbility, ClientAbilityProjectile)

	self:setup()

    self.lastFireTime = os.clock()

	return self
end

function ClientAbilityProjectile:fire(direction: Vector3)
    direction = direction or workspace.CurrentCamera.CFrame.LookVector

    if not self.abilityConfig.continuousFire then
        SoundPlayer.PlaySound(self.abilityConfig.sound,self:getCurrentFakeToolHandle(), 0.5)
    end

    -- Apply recoil
    self.entity.recoil:applyRecoil(self.abilityConfig.recoil.vertical, self.abilityConfig.recoil.horizontal)

    local spread = self.abilityConfig.spread
    local root = self.entity.root
    local biasedDirection = direction +
        root.CFrame.RightVector * math.random(-spread, spread)/100 +
        root.CFrame.UpVector * math.random(-spread, spread)/100
    
    local projectileConfig = self.abilityConfig.projectileConfig
    projectileConfig.Origin = self:getCurrentFakeToolHandle().Position
    projectileConfig.Direction = biasedDirection
    projectileConfig.RaycastBlacklist = {self.entity.rig}

    if self.entity.isLocalPlayerInstance then
        table.insert(projectileConfig.RaycastBlacklist, workspace.CurrentCamera)
    end

    projectileConfig.SourceEntityID = self.entity.id
    projectileConfig.Damage = self.abilityConfig.damage or 10
    projectileConfig.ClientReplicationBlacklist = {Player.UserId}

    ProjectileManager.Dynamic(projectileConfig)
end

function ClientAbilityProjectile:setupInputs()
    self.isFiring = false
    self.currentSound = nil

    -- Input began handler
    self.trove:Add(Inputs.events.ProcessedInputBegan:Connect(function(input)
        if not self:checkInputConditions() then return end

        if Inputs.IsValidInput(self.abilityConfig.inputs.activate, input) then
            self.isFiring = true
            if self.abilityConfig.continuousFire then
                self.currentSound = SoundPlayer.PlaySound(self.abilityConfig.sound, self:getCurrentFakeToolHandle(), 0.5, true, 0.3)
            end
        end
    end))

    -- Input ended handler
    self.trove:Add(Inputs.events.ProcessedInputEnded:Connect(function(input)
        if not self:checkInputConditions() then return end

        if self.isFiring and Inputs.IsValidInput(self.abilityConfig.inputs.activate, input) then
            self.isFiring = false
            if self.abilityConfig.continuousFire and self.currentSound then
                SoundPlayer.FadeOut(self.currentSound, 0.2)
            end
        end
    end))
end

function ClientAbilityProjectile:trigger(replicate: boolean, direction: Vector3)
    if self:isHot() then return end
    self:heat()
    self:fire(direction)
    if replicate then
        self:sendAction("Fire", workspace.CurrentCamera.CFrame.LookVector)
    end
end


function ClientAbilityProjectile:setup()
	-- Setup inputs for the local player
	if self.entity.isLocalPlayerInstance then self:setupInputs() end

    -- Tool unequipped handler
    self.trove:Add(self.events.Unequipped:Connect(function()
        self.isFiring = false
        if self.currentSound then
            SoundPlayer.FadeOut(self.currentSound, 0.2)
        end
    end))

    -- Continuous fire handler
    self.trove:Add(RunService.RenderStepped:Connect(function()
        if not self.isFiring then return end
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
    if self.currentSound then
        self.currentSound:Destroy()
    end
	self:destroySub()
end

return ClientAbilityProjectile