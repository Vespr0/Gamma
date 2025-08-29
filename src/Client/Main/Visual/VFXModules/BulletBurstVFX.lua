local BaseVFX = require(script.Parent.Parent.BaseVFX)

local BulletBurst = setmetatable({}, BaseVFX)
BulletBurst.__index = BulletBurst

function BulletBurst.new()
    local self = setmetatable(BaseVFX.new(), BulletBurst)
    return self
end

function BulletBurst:play(attachment)
    if not attachment then return end

end

return BulletBurst