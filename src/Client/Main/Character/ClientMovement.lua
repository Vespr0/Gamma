local Movement = {}
Movement.__index = Movement

-- Services
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
-- Modules
local AssetsDealer = require(ReplicatedStorage.AssetsDealer)
local Trove = require(ReplicatedStorage.Packages.trove)
local Game = require(ReplicatedStorage.Utility.Game)
local Lerp = require(ReplicatedStorage.Utility.Lerp)
local MovementMiddleware = require(ReplicatedStorage.Middleware.MiddlewareManager).Get("Movement")
-- Inputs
local SprintingInput = require(script.Parent.Parent.Input.Inputs).GetModule("Sprinting")
local CrouchingInput = require(script.Parent.Parent.Input.Inputs).GetModule("Crouching")
-- Variables
local singleton = nil

local SPRINTING_BOOST = 5
local CROUCHING_PENALTY = 8
local TRANSITION_SPEED = 3

function Movement.new()
    local self = setmetatable({}, Movement)

    -- Components
    self.anima = require(script.Parent.Parent.Player.ClientAnima):get()
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

    self:setup()

    return self
end

function Movement:setupSprinting()
    self.isSprinting = false

    SprintingInput.Event:Connect(function(mode)
        if self.isCrouching then return end

        self.isSprinting = mode
        self.anima.character:SetAttribute("Sprinting",mode)
        --[[ 
            The sprinting attribute is set by the server to ensure synchronization, however, in the case of the local player
            we can set it directly to avoid the delay of the server.
        ]]
        MovementMiddleware.SendMovementAction:Fire("Sprinting",mode)
    end)

    CrouchingInput.Event:Connect(function(mode)
        if self.isSprinting then return end
        --[[ 
            The same condition applies to the croching attribute.
        ]]
        self.isCrouching = mode
        self.anima.character:SetAttribute("Crouching",mode)
        -- Add camera offsetr
        self.anima.camera.offsets.Crouching = mode and Vector3.new(0, 0.5, 0) or Vector3.zero
        -- Set the crouching attribute on the server and consequently on all the other clients
        MovementMiddleware.SendMovementAction:Fire("Crouching",mode) 
    end)

    self.boosts.WalkSpeed.Sprinting = 0
    self.boosts.WalkSpeed.Crouching = 0
    
    RunService.RenderStepped:Connect(function(deltaTime: number)
        if not self.anima.character then return end
         
        -- Smooth sprinting transition
        local goal = self.isSprinting and SPRINTING_BOOST or 0
        self.boosts.WalkSpeed.Sprinting = Lerp(self.boosts.WalkSpeed.Sprinting,goal,deltaTime*TRANSITION_SPEED)
        -- Smooth crouching transition
        goal = self.isCrouching and -CROUCHING_PENALTY or 0
        self.boosts.WalkSpeed.Crouching = Lerp(self.boosts.WalkSpeed.Sprinting,goal,deltaTime*TRANSITION_SPEED)

        self.currentSpeed = self.anima.root.AssemblyLinearVelocity.Magnitude
    end)
end

function Movement:updateBoostCategory(category)
    local value = 0 
    for _,boost in self.boosts[category] do
        value += boost
    end
	self.anima.humanoid[category] = self.presets[category] + value
end

function Movement:setup() 
    -- Humanoid should use jump height
    self.anima.humanoid.UseJumpPower = false

    RunService.RenderStepped:Connect(function()
        for category,_ in self.boosts do
            self:updateBoostCategory(category)
        end
    end)

    self:setupSprinting()
end

function Movement:get()
	if not singleton then
		singleton = Movement.new()
	end
	return singleton
end

function Movement.Init() Movement:get() end

return Movement