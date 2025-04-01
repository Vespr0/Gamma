local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer
local BaseClientAbility = require(Player.PlayerScripts.Main.Abilities.BaseClientAbility)

local TypeAbility = require(ReplicatedStorage.Types.TypeAbility)
local Inputs = require(game:GetService("Players").LocalPlayer.PlayerScripts.Main.Input.Inputs):get()
local ProjectileManager = require(script.Parent.Parent.ProjectileManager)
local SoundPlayer = require(Player.PlayerScripts.Main.Sound.SoundPlayer)
local RunService = game:GetService("RunService")

local ClientAbilityThrow = setmetatable({}, {__index = BaseClientAbility})
ClientAbilityThrow.__index = ClientAbilityThrow
-- Instances
local Camera = workspace.CurrentCamera
-- Constants
local ABILITY_NAME = "Projectile"

function ClientAbilityThrow.new(entity,tool,config)
	local self = setmetatable(BaseClientAbility.new(ABILITY_NAME,entity,tool,config) :: TypeAbility.BaseClientAbility, ClientAbilityThrow)

	self:setup()

    self.continuousFire = self.cooldownDuration < 0.4

	return self
end

function ClientAbilityThrow:fire()
    if not self.abilityConfig.continuousFire then
        SoundPlayer.PlaySound(self.abilityConfig.sound,0.5)
    end

    local spread = self.abilityConfig.spread
    local direction = Camera.CFrame.LookVector + Camera.CFrame.RightVector * math.random(-spread,spread)/100 + Camera.CFrame.UpVector * math.random(-spread,spread)/100
    
    local projectileConfig = self.abilityConfig.projectileConfig
    projectileConfig.Origin = self:getFireEndPosition();
    projectileConfig.Direction = direction
    projectileConfig.RaycastBlacklist = {self.entity.rig,Camera:FindFirstChild("Viewmodel")}
    
    ProjectileManager.Dynamic(projectileConfig)
end

function ClientAbilityThrow:setupInputs()
    local inputDown = false
    self.currentSound = nil

	self.trove:Add(Inputs.events.ProcessedInputBegan:Connect(function(input)
		if not self:checkInputConditions() then return end

		if Inputs.IsValidInput(self.abilityConfig.inputs.activate, input) then
			inputDown = true
            if self.abilityConfig.continuousFire then
                self.currentSound = SoundPlayer.PlaySound(self.abilityConfig.sound,0.5,true,.3)
            end
		end
	end))

    self.trove:Add(Inputs.events.ProcessedInputEnded:Connect(function(input)
        if not self:checkInputConditions() then return end
        
        if inputDown and Inputs.IsValidInput(self.abilityConfig.inputs.activate, input) then
            inputDown = false
            if self.abilityConfig.continuousFire and self.currentSound then
                SoundPlayer.FadeOut(self.currentSound, .2)
            end
        end
    end))

    -- Tool unequipped
    self.trove:Add(self.events.Unequipped:Connect(function()
        inputDown = false
        if self.currentSound then
            SoundPlayer.FadeOut(self.currentSound, .2)
        end
    end))

    self.trove:Add(RunService.RenderStepped:Connect(function()
        if not inputDown then return end
        if self:isHot() then return end
        self:heat()

        self:fire()
    end))
end

function ClientAbilityThrow:setup()
	-- Setup inputs for the local player
	if self.entity.isLocalPlayer then self:setupInputs() end
end

function ClientAbilityThrow:destroy()
    if self.currentSound then
        self.currentSound:Destroy()
    end
	self:destroySub()
end

return ClientAbilityThrow