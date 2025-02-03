--!strict
local Parts = {}

local Colors = require(script.Parent.Colors)
local Materials = require(script.Parent.Materials)

local Types = {
    ["Grass"] = {Color = "Grass Green", Material = "Grass"},
    ["Dirt"] = {Color = "Dirt Brown", Material = "Dirt"},
    ["Water"] = {Color = "Cyan", Material = "Water"},
    ["Sand"] = {Color = "Sandy Yellow", Material = "Sand"},
    ["Stone"] = {Color = "Gray", Material = "Stone"},
    ["Bedrock"] = {Color = "Black", Material = "Plastic"},
    ["Missing"] = {Color = "Missing", Material = "Stud"},
}

Parts.ApplyType = function(part,type)
    local typeInfo = Types[type]
    if not typeInfo then warn("Part type info not found") return end  
    
    part:SetAttribute("PartType", type)
    Colors.Apply(part, typeInfo.Color)
    Materials.Apply(part, typeInfo.Material)
end

Parts.NewCustom = function(cframe,size,color,material,parent)
    if not cframe or typeof(cframe) ~= "CFrame" then warn("Invalid CFrame") return end
    if not size or typeof(size) ~= "Vector3" then warn("Invalid size") return end
    if not color or typeof(color) ~= "string" then warn("Invalid color") return end
    if not material or typeof(material) ~= "string" then warn("Invalid material") return end
    if not parent then error("Parent cannot be nil") end

    local part = Instance.new("Part")
    part.Parent = parent
    part.Anchored = true
    part.CFrame = cframe or CFrame.new(Vector3.zero)
    part.Size = size or Vector3.one
    -- Color
    Colors.Apply(part, color or "Gray")
    -- Material
    Materials.Apply(part, material or "Plastic")
    return part
end

Parts.New = function(cframe,size,type,parent)
    local typeInfo = Types[type]
    if not typeInfo then error("Part type info not found") end

    local part = Parts.NewCustom(cframe, size, typeInfo.Color, typeInfo.Material, parent)
    part:SetAttribute("PartType", type)
    return part
end

return Parts