local ThirdPerson = {}
ThirdPerson.__index = ThirdPerson

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local FIELD_OF_VIEW = 70

function ThirdPerson.new(cameraController)
    local self = setmetatable({}, ThirdPerson)

    self.controller = cameraController
    self.camera = workspace.CurrentCamera

    return self
end

function ThirdPerson:set()
    self.camera.FieldOfView = FIELD_OF_VIEW
    LocalPlayer.CameraMinZoomDistance = 5
    LocalPlayer.CameraMaxZoomDistance = 20

    local character = self.controller.anima.character

    for _, d in pairs(character:GetDescendants()) do
        if d:IsA("BasePart") then
            d.CastShadow = true -- TODO: Not a good solution, it will enable shadows on parts that should have it off
            d.LocalTransparencyModifier = 0
        end
    end
end

function ThirdPerson:step()

end

return ThirdPerson
