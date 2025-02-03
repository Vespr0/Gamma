--!strict
local Colors = {}

local Palette = {
    -- Greens
    ["Strong Green"] = Color3.fromRGB(20, 255, 30),
    ["Soft Green"] = Color3.fromRGB(80, 255, 80),
    ["Water Green"] = Color3.fromRGB(20, 255, 160),
	["Grass Green"] = Color3.fromRGB(115, 179, 76),
    -- Reds 
    ["Strong Red"] = Color3.fromRGB(255, 20, 40),
    -- Blues
    ["Strong Blue"] = Color3.fromRGB(20, 20, 255),
    ["Cyan"] = Color3.fromRGB(56, 133, 255),
    -- Grays
    ["Gray"] = Color3.fromRGB(126, 126, 127),
    ["Light Gray"] = Color3.fromRGB(162, 162, 162),
    ["Silver"] = Color3.fromRGB(215, 216, 224),
    -- Yellows
    ["Strong Yellow"] = Color3.fromRGB(255, 255, 0),
    ["Sandy Yellow"] = Color3.fromRGB(243, 227, 174),
    -- Browns
    ["Dirt Brown"] = Color3.fromRGB(87, 72, 64),
    -- Blacks
    ["Pure Black"] = Color3.fromRGB(0, 0, 0),
    -- Others
    ["Missing"] = Color3.fromRGB(255, 0, 255),
}

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

Colors.Get = function(name)
	return Palette[name] or Palette.Missing
end

Colors.Darken = function(color, factor)
	return adjustColor(color, factor or -0.2)
end

Colors.Lighten = function(color, factor)
	return adjustColor(color, factor or 0.2)
end

Colors.Apply = function(part, color)
    part.Color = Colors.Get(color)
    part:SetAttribute("Color", color)
end

return Colors