--!strict
local types = {}

-- Extends type model
export type Rig = Model & {
    Humanoid : Humanoid,
    Head : BasePart,
    Torso : BasePart,
    ["Right Arm"] : BasePart,
    ["Left Arm"] : BasePart,
    ["Right Leg"] : BasePart,
    ["Left Leg"] : BasePart
}

return types