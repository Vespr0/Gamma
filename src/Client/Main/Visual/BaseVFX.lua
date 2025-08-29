-- BaseFX.lua
-- Base class for visual effects

local TweenService = game:GetService("TweenService")

local BaseFX = {}
BaseFX.__index = BaseFX

function BaseFX.new()
    local self = setmetatable({}, BaseFX)
    return self
end

function BaseFX:createTemporaryAttachment(basePart,worldPosition)
    local Attachment = Instance.new("Attachment")
    Attachment.WorldPosition = worldPosition
    Attachment.Parent = basePart
    return Attachment
end

-- Function to check if the effect is far from the camera
function BaseFX:isFarFromCamera(effectPosition, maxDistance)
    local camera = workspace.CurrentCamera
    if not camera then return false end

    local distance = (camera.CFrame.Position - effectPosition).Magnitude
    return distance > maxDistance
end

return BaseFX