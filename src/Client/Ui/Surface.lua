--!strict
local Surface = {}

local Text = require(script.Parent.Text)

function Surface.Create(instance,side)
    local surface = {}

    local surfaceGui = Instance.new("SurfaceGui")
    surfaceGui.Parent = instance
    surfaceGui.Face = Enum.NormalId[side]

    surface.Gui = surfaceGui

    surface.AddText = function(text)
        Text.CreateLabel(surfaceGui, text, "Auto", "Bold")
    end

    return surface
end

return Surface