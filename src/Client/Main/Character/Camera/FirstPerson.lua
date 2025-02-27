local FirstPerson = {}
FirstPerson.__index = FirstPerson

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
-- Modules
local Lerp = require(ReplicatedStorage.Utility.Lerp) 
-- Variables
local LocalPlayer = Players.LocalPlayer
-- Settings
local FIELD_OF_VIEW = 80
local HEAD_OFFSET = Vector3.new(0, 0, 0)

function FirstPerson.new(cameraController)
    local self = setmetatable({}, FirstPerson)

    self.controller = cameraController
    self.camera = self.controller.camera
    self.angles = CFrame.Angles(0, 0, 0);

    return self
end

function FirstPerson:set()
    self.camera.FieldOfView = FIELD_OF_VIEW
    LocalPlayer.CameraMinZoomDistance = 0.5
    LocalPlayer.CameraMaxZoomDistance = 0.5
end

function FirstPerson:step(deltaTime: number)
    local character = self.controller.anima.character

    local velocity = character.PrimaryPart.AssemblyLinearVelocity
    local velocityMagnitude = velocity.magnitude
    
    local FOV = FIELD_OF_VIEW+velocityMagnitude

    -- Lerp fov
    local alpha = deltaTime/5
    self.camera.FieldOfView = Lerp(self.camera.FieldOfView, FOV, alpha)

    for _, d in pairs(character:GetDescendants()) do
        if d:IsA("BasePart") then
            d.CastShadow = false
            d.LocalTransparencyModifier = 1
        end
    end
end

return FirstPerson
