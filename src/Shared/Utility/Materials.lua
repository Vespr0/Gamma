--!strict
local Materials = {}

local Info = {
    ["Metal"] = {material = "Glacier", variant = "Weld",transparency = 0},
    ["Wood"] = {material = "Glacier", variant = "Stud",transparency = 0},
    ["Plastic"] = {material = "Glacier", variant = "Stud",transparency = 0},
    ["Glass"] = {material = "Plastic",transparency = 0.5},
    ["Grass"] = {material = "Glacier", variant = "Universal",transparency = 0},
    ["Rock"] = {material = "Plastic",transparency = 0};
    ["Terracotta"] = {material = "Glacier",variant = "Small Stud",transparency = 0},
    ["Mineral"] = {material = "Glacier",variant = "Inlet",transparency = 0},
    ["Void"] = {material = "Neon",transparency = 0.5},
    ["Water"] = {material = "Plastic",transparency = 0.5}
}

Materials.Apply = function(instance,name)
    if not instance or not instance.Parent then
        error("Instance cannot be nil")
    end
    if not instance:IsA("BasePart") then
        error("BasePart expected, got " .. instance.ClassName)
    end
    local info = Info[name]
    if info then
        if info.material then instance.Material = info.material end
        if info.variant then instance.MaterialVariant = info.variant end
        instance.Transparency = info.transparency
        instance:SetAttribute("Material", name)
    end
end

return Materials