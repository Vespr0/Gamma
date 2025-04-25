local Motor6DTilt = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Modules
local TypeRig = require(ReplicatedStorage.Types.TypeRig)
local Trove = require(ReplicatedStorage.Packages.trove)
local Lerp = require(ReplicatedStorage.Utility.Lerp)

-- Constants
local BIAS_NAME = "Leaning"
local SMOOTHNESS = 10
local VELOCITY_THRESHOLD = 0.1
local MAX_LEANING = math.rad(15)
local MAX_SPEED = 20

local function calculateMoveDirection(velocity: Vector3): (Vector3, number)
    local horizontalVelocity = Vector3.new(velocity.X, 0, velocity.Z)
    local speed = horizontalVelocity.Magnitude
    
    if speed > VELOCITY_THRESHOLD then
        return horizontalVelocity.Unit, speed
    end
    
    return Vector3.zero, 0
end

local function calculateTargetTilt(moveDirection: Vector3, speed: number, primaryPartCFrame: CFrame): number
    if moveDirection.Magnitude > 0 then
        -- Get the forward direction of the PrimaryPart
        local forwardDirection = primaryPartCFrame.LookVector

        -- Calculate the dot product between the move direction and the forward direction
        local dotProduct = moveDirection:Dot(forwardDirection)

        -- Determine the tilt direction based on the dot product
        local tiltDirection = dotProduct > 0 and 1 or -2

        -- Calculate the tilt based on the speed and direction
        local tilt = (speed / MAX_SPEED) * MAX_LEANING * tiltDirection
        return math.clamp(tilt, -MAX_LEANING, MAX_LEANING)
    end
    return 0
end

local function updateBias(utility, targetTilt: number, deltaTime: number)
    if not (utility.dualBiases.RootJoint and utility.dualBiases.RootJoint[BIAS_NAME]) then
        return
    end

    local bias = utility.dualBiases.RootJoint[BIAS_NAME].C0
    if not bias then return end

    local currentAngles = bias.angles
    local currentTilt = currentAngles:ToEulerAnglesXYZ()
    local smoothedTilt = Lerp(currentTilt, targetTilt, SMOOTHNESS * deltaTime)
    
    bias.angles = CFrame.Angles(smoothedTilt, 0, 0)
end

function Motor6DTilt.Connect(utility, rig: TypeRig.Rig)
    utility:checkMotors("RootJoint")

    local self = {}

    -- Initialize bias
    local initialBias = {
        offset = Vector3.zero,
        angles = CFrame.Angles(0, 0, 0)
    }
    utility:addBias("RootJoint", BIAS_NAME, "C0", initialBias, SMOOTHNESS)

    -- Get necessary components
    local humanoid = rig:FindFirstChild("Humanoid")
    local rootPart = rig:FindFirstChild("HumanoidRootPart")

    if not humanoid or not rootPart then
        warn("RunningSway: Missing Humanoid or RootPart in rig")
        return self
    end

    -- Main update loop
    self.connection = RunService.Heartbeat:Connect(function(deltaTime)
        local velocity = rootPart.Velocity
        local moveDirection, speed = calculateMoveDirection(velocity)
        local targetTilt = calculateTargetTilt(moveDirection, speed, rootPart.CFrame)
        
        updateBias(utility, targetTilt, deltaTime)
    end)

    return self
end

return Motor6DTilt