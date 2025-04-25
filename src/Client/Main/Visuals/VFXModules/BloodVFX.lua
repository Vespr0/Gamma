local BaseVFX = require(script.Parent.Parent.BaseVFX)

local BloodVFX = setmetatable({}, BaseVFX)
BloodVFX.__index = BloodVFX

function BloodVFX.new()
    local self = setmetatable(BaseVFX.new(), BloodVFX)
    return self
end

function BloodVFX:play(BasePart,worldPosition)
    assert(BasePart,"BasePart is required")
    assert(worldPosition,"WorldPosition is required")

    local temporaryAttachment = self:createTemporaryAttachment(BasePart,worldPosition)
end

return BloodVFX