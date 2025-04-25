--!strict
local Colors = {}

local function adjustColor(color, factor)
    -- Ensure the factor is within the correct range
    factor = math.clamp(factor, -1, 1)
    
    -- Lighten or darken each component
    local function adjustComponent(component)
        if factor > 0 then
            -- Lighten component
            return component + (1 - component) * factor
        else
            -- Darken component
            return component * (1 + factor)
        end
    end
    
    local newR = adjustComponent(color.R)
    local newG = adjustComponent(color.G)
    local newB = adjustComponent(color.B)
    
    return Color3.new(newR, newG, newB)
end

Colors.Darken = function(color, factor)
	return adjustColor(color, factor or -0.2)
end

Colors.Lighten = function(color, factor)
	return adjustColor(color, factor or 0.2)
end

return Colors