-- Services & Dependencies
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EntityUtility = require(ReplicatedStorage.Utility.Entity)
local Trove = require(ReplicatedStorage.Packages.trove)

-- Class Declaration
local LookAt = {}
LookAt.__index = LookAt

-- Constructor
-- Create a new LookAt controller for a client entity
function LookAt.new(clientEntity)
    local self = setmetatable({}, LookAt)
    self.entity = clientEntity
    self.motor6DManager = clientEntity.Motor6DManager
    self.currentDirection = nil
    self._lastRootCFrame = nil -- Private field for lerping
    self._trove = Trove.new()

    self:setup() -- Initialize the update loop
    return self
end

-- Calculate joint angle biases for upper body parts based on look direction
function LookAt:GetBiases(referenceCFrame)
    local thetaY = math.asin(self.currentDirection.Y) / 2 -- Tilt angle
    local biases = {
        Neck = {
            offset = Vector3.new(),
            angles = CFrame.Angles(-thetaY, 0, 0)
        },
        Waist = {
            offset = Vector3.new(),
            angles = CFrame.Angles(-thetaY, 0, 0)
        },
        RightShoulder = {
            offset = Vector3.new(),
            angles = CFrame.Angles(0, 0, thetaY * 0.6)
        },
        LeftShoulder = {
            offset = Vector3.new(),
            angles = CFrame.Angles(0, 0, -thetaY * 0.6)
        },
        RightHip = {
            offset = Vector3.new(),
            angles = CFrame.Angles(0, 0, -thetaY * 1.4)
        },
        LeftHip = {
            offset = Vector3.new(),
            angles = CFrame.Angles(0, 0, thetaY * 1.4)
        }
    }
    return biases
end

-- Apply calculated biases to all relevant joints
function LookAt:SetBiases(biases)
    self.motor6DManager:addBias("RootJoint", "Tilt", "C0", biases.Waist)
    self.motor6DManager:addBias("Neck", "Tilt", "C0", biases.Neck)
    self.motor6DManager:addBias("Right Shoulder", "Tilt", "C0", biases.RightShoulder)
    self.motor6DManager:addBias("Left Shoulder", "Tilt", "C0", biases.LeftShoulder)
    self.motor6DManager:addBias("Right Hip", "Tilt", "C0", biases.RightHip)
    self.motor6DManager:addBias("Left Hip", "Tilt", "C0", biases.LeftHip)
end

-- Smoothly turn the NPC root towards the look direction (with lerping)
function LookAt:StepNPCTurn()
    local root = self.entity.root
    local targetCFrame = CFrame.lookAlong(root.Position, Vector3.new(self.currentDirection.X, 0, self.currentDirection.Z))
    local alpha = 0.25 -- Lerp factor, adjust for smoothness
    self._lastRootCFrame = self._lastRootCFrame or root.CFrame
    local newCFrame = self._lastRootCFrame:Lerp(targetCFrame, alpha)
    root.CFrame = newCFrame
    self._lastRootCFrame = newCFrame
end

-- Setup update loop
function LookAt:setup()
    self._trove:Add(RunService.RenderStepped:Connect(function(dt)
        if not EntityUtility.IsAlive(self.entity.rig) then return end
        -- Update reference CFrame for local player
        if self.entity.isLocalPlayerInstance then
            self.currentDirection = workspace.CurrentCamera.CFrame.LookVector
        else
            self.currentDirection = self.entity.rig:GetAttribute("LookDirection")
            if self.currentDirection then
                self:StepNPCTurn()
            end
        end
        -- Calculate and apply biases
        if self.currentDirection then
            local biases = self:GetBiases(self.currentDirection)
            self:SetBiases(biases)
        end
    end))
end

-- Clean up all connections and resources
function LookAt:Destroy()
    if self._trove then
        self._trove:Destroy()
    end
end

return LookAt