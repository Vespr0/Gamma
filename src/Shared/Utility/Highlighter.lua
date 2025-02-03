--!strict
local Highlighter = {}

local Colors = require(script.Parent.Colors)

Highlighter.mark = function(object, config)
    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.Adornee = object
    highlight.Parent = object
    -- Color
    highlight.FillColor = config.fillColor or Colors.Get("Missing")
    highlight.OutlineColor = config.outlineColor or Colors.Get("Missing")
    -- Transparency
    highlight.OutlineTransparency = config.outlineTransparency or 0.5
    highlight.FillTransparency = config.fillTransparency or 0 
    -- DepthMode
    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
end

return Highlighter