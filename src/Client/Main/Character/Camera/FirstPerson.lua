local FirstPerson = {}
FirstPerson.__index = FirstPerson

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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

function FirstPerson:step()
    -- local character = self.controller.clientAnima.character
    -- self.camera.CameraSubject = character.Humanoid
    -- character.PrimaryPart.CFrame *= self.angles
    -- self.camera.CFrame = character.Head.CFrame * self.angles + HEAD_OFFSET
end

return FirstPerson
