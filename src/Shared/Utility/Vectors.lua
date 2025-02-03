--!strict
local Vectors = {}

local function snapAxis(num, alpha)
    if not alpha then
        return math.floor(num + 0.5)
    else
        return math.floor(num * alpha + 0.5) / alpha
    end
end

function Vectors.snap(position)
    if not position then error("Position is nil") return end
    if not (typeof(position) == "Vector3") then error("Position is not a Vector3") return end
    
    return Vector3.new(snapAxis(position.X), snapAxis(position.Y), snapAxis(position.Z))
end

return Vectors