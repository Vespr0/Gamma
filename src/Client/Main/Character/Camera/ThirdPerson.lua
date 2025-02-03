local ThirdPerson = {}
ThirdPerson.__index = ThirdPerson

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local FIELD_OF_VIEW = 70

function ThirdPerson.new(cameraController)
    local self = setmetatable({}, ThirdPerson)

    self.cameraController = cameraController
    self.camera = workspace.CurrentCamera

    return self
end

function ThirdPerson:set()
    self.camera.FieldOfView = FIELD_OF_VIEW
    LocalPlayer.CameraMinZoomDistance = 5
    LocalPlayer.CameraMaxZoomDistance = 20
end

function ThirdPerson:step()

end

return ThirdPerson
