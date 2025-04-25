local Movement = {}
Movement.__index = Movement

-- Services
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _TweenService = game:GetService("TweenService")
-- Modules
local Trove = require(ReplicatedStorage.Packages.trove)
local Lerp = require(ReplicatedStorage.Utility.Lerp)
local MovementMiddleware = require(ReplicatedStorage.Middleware.MiddlewareManager).Get("Movement")
local EntityUtility = require(ReplicatedStorage.Utility.Entity)
local Inputs = require(script.Parent.Parent.Input.Inputs)
local SprintingInput = Inputs.GetModule("Sprinting")
local CrouchingInput = Inputs.GetModule("Crouching")

local SPRINTING_BOOST = 5
local CROUCHING_PENALTY = 8
local AIRBORNE_PUSH = 30
local TRANSITION_SPEED = 3

function Movement.new(entity,isLocalPlayerInstance)
    local self = setmetatable({}, Movement)

    -- Components
    self.entity = entity
    self.trove = Trove.new()
    -- Variables
    self.boosts = {
        WalkSpeed = {},
        JumpHeight = {}
    }
    self.presets = {
        WalkSpeed = 12,
        JumpHeight = 4
    }
    self.currentSpeed = 0
    self.isLocalPlayerInstance = isLocalPlayerInstance

    self:setup()

    return self
end

function Movement:setup() 
    self:setupBoosts()

    self:setupSprinting()

    self.entity.events.Died:Connect(function()
        self:destroy()
    end)
end

function Movement:setupSprinting()
    self.isSprinting = false

    if self.isLocalPlayerInstance then
        self.trove:Add(SprintingInput.Event:Connect(function(mode)
            if self.isCrouching then return end

            self.isSprinting = mode
            self.entity.rig:SetAttribute("Sprinting",mode)
            --[[ 
                The sprinting attribute is set by the server to ensure synchronization, however, in the case of the local player
                we can set it directly to avoid the delay of the server.
            ]]
            MovementMiddleware.SendMovementAction:Fire("Sprinting",mode)
        end))

        self.trove:Add(CrouchingInput.Event:Connect(function(mode)
            if self.isSprinting then return end
            --[[ 
                The same condition applies to the croching attribute.
            ]]
            self.isCrouching = mode
            self.entity.rig:SetAttribute("Crouching",mode)
            -- Add camera offsetr
            -- ClientAnima.camera.offsets.Crouching = mode and Vector3.new(0, 0.5, 0) or Vector3.zero TODO
            -- Set the crouching attribute on the server and consequently on all the other clients
            MovementMiddleware.SendMovementAction:Fire("Crouching",mode) 
        end))
    end

    self.boosts.WalkSpeed.Sprinting = 0
    self.boosts.WalkSpeed.Crouching = 0
    
    self.trove:Add(RunService.RenderStepped:Connect(function(deltaTime: number)
        if not EntityUtility.IsAlive(self.entity.rig) then return end
        -- Smooth sprinting transition
        local sprintGoal = self.isSprinting and SPRINTING_BOOST or 0
        local sprintLerp = Lerp(self.boosts.WalkSpeed.Sprinting, sprintGoal, deltaTime * TRANSITION_SPEED)
        self.boosts.WalkSpeed.Sprinting = math.clamp(sprintLerp,0,SPRINTING_BOOST)
    
        -- Smooth crouching transition
        local crouchGoal = self.isCrouching and -CROUCHING_PENALTY or 0
        local crouchLerp = Lerp(self.boosts.WalkSpeed.Crouching, crouchGoal, deltaTime * TRANSITION_SPEED)
        self.boosts.WalkSpeed.Crouching = math.clamp(crouchLerp,-CROUCHING_PENALTY,0)
        
        -- Airborne upward push
        local state = self.entity.humanoid:GetState()
        if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then
            local root = self.entity.rig:FindFirstChild("HumanoidRootPart")
            if root then
                local vel = root.AssemblyLinearVelocity
                -- apply push per second to avoid exponential growth
                local newY = vel.Y + AIRBORNE_PUSH * deltaTime
                root.AssemblyLinearVelocity = Vector3.new(vel.X, newY, vel.Z)
            end
        end
    end))
end

function Movement:setupBoosts()
    self.trove:Add(RunService.RenderStepped:Connect(function()
        for category,_ in self.boosts do
            self:updateBoostCategory(category)
        end
    end))
end

function Movement:updateBoostCategory(category)
    local value = 0 
    for _,boost in self.boosts[category] do
        value += boost
    end
	self.entity.humanoid[category] = self.presets[category] + value
end

function Movement:destroy()
    self.trove:Destroy()
end

return Movement