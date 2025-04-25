local RecoilMotor = {}
RecoilMotor.__index = RecoilMotor

-- Services
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local Spring = require(ReplicatedStorage.Packages.spring)

-- Constants
local SPRING_CONFIG = {
    damping = 0.8,
    frequency = 15
}
local ARM_RECOIL_MULTIPLIER = 2 -- Increased for more noticeable movement

function RecoilMotor.Connect(manager, rig, motors)
    local self = setmetatable({}, RecoilMotor)
    
    self.manager = manager
    self.rig = rig
    self.root = rig:FindFirstChild("HumanoidRootPart")
    self.motors = motors
    self.random = Random.new()
    
    -- Create springs for vertical recoil
    self.verticalSpring = Spring.new(SPRING_CONFIG.damping, SPRING_CONFIG.frequency, 0)

    -- Get shoulder motors
    self.rightShoulder = motors["Right Shoulder"]
    self.leftShoulder = motors["Left Shoulder"]
    
    if not self.rightShoulder or not self.leftShoulder then
        warn("RecoilMotor: Could not find shoulder motors")
        return function() end
    end
    
    -- Store default C0 values
    self.defaultRightC0 = self.rightShoulder.C0
    self.defaultLeftC0 = self.leftShoulder.C0
    
    -- Connect to recoil events
    local connection = RunService.RenderStepped:Connect(function(deltaTime)
        self:update(deltaTime)
    end)
   
    self.connection = connection
    
    return self
end

function RecoilMotor:update(deltaTime)
    if not self.verticalSpring then return end
    
    -- Update spring
    self.verticalSpring:Step(deltaTime)
    
    local verticalOffset = self.verticalSpring:Get()
    
    local armVertical = verticalOffset * ARM_RECOIL_MULTIPLIER
    
    local lookVector = self.root.CFrame.LookVector
    local armTransform = lookVector * armVertical
    
    self.manager:addBias("Right Shoulder", "Recoil", "C0", {
        offset = armTransform
    })
    
    self.manager:addBias("Left Shoulder", "Recoil", "C0", {
        offset = armTransform
    })
end

function RecoilMotor:applyRecoil(vertical)
    -- Add force to spring by setting its goal
    self.verticalSpring:Set(self.verticalSpring:Get() + vertical) -- Increased multiplier for more noticeable recoil
end

return RecoilMotor