local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EntityUtility = require(ReplicatedStorage.Utility.Entity)
local Tilting = {}
Tilting.__index = Tilting

local Trove = require(ReplicatedStorage.Packages.trove)

-- Constants for default CFrames
local NECKC0 = CFrame.new(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)
local ROOTC0 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)
local RIGHTSHOULDERC0 = CFrame.new(1, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0)
local LEFTSHOULDERC0 = CFrame.new(-1, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
local RIGHTHIP0 = CFrame.new(1, -1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0)
local LEFTHIP0 = CFrame.new(-1, -1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)

function Tilting.new(clientEntity)
    local self = setmetatable({}, Tilting)
    self.entity = clientEntity
    self.motor6DManager = clientEntity.Motor6DManager
    self.currentDirection = nil
    self.trove = Trove.new()
    self:setup()
    return self
end

function Tilting:GetBiases(referenceCFrame)
    local rig = self.entity.rig
    local root = self.entity.root

    -- Convert camera CFrame to root's object space and get LookVector
    local thetaY = math.asin(self.currentDirection.Y) / 2 -- Calculate tilt angle
    local thetaX = math.asin(self.currentDirection.X)

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
            angles = CFrame.Angles(0, 0, -thetaY * 0.8)
        },
        LeftHip = {
            offset = Vector3.new(),
            angles = CFrame.Angles(0, 0, thetaY * 0.8)
        }
    }

    return biases
end

function Tilting:SetBiases(biases)
    -- Apply biases to all relevant joints
    self.motor6DManager:addBias("RootJoint", "Tilt", "C0", biases.Waist)
    self.motor6DManager:addBias("Neck", "Tilt", "C0", biases.Neck)
    self.motor6DManager:addBias("Right Shoulder", "Tilt", "C0", biases.RightShoulder)
    self.motor6DManager:addBias("Left Shoulder", "Tilt", "C0", biases.LeftShoulder)
    self.motor6DManager:addBias("Right Hip", "Tilt", "C0", biases.RightHip)
    self.motor6DManager:addBias("Left Hip", "Tilt", "C0", biases.LeftHip)
end

function Tilting:setup()
    self.trove:Add(RunService.RenderStepped:Connect(function(dt)
        if not EntityUtility.IsAlive(self.entity.rig) then return end

        -- Update reference CFrame for local player
        if self.entity.isLocalPlayerInstance then
            self.currentDirection = workspace.CurrentCamera.CFrame.LookVector
        end

        -- Calculate and apply biases
        if self.currentDirection then
            local biases = self:GetBiases(self.currentDirection)
            self:SetBiases(biases)
        end
    end))
end

function Tilting:Destroy()
    if self.trove then
        self.trove:Destroy()
    end
end

return Tilting