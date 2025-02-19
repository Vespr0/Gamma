local Terrain = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Modules
local Materials = require(ReplicatedStorage.Utility.Materials)
local Colors = require(ReplicatedStorage.Utility.Colors)

local Types = {
    ["Grass"] = {Color = "Grass Green", Material = "Grass"},
    ["Dirt"] = {Color = "Dirt Brown", Material = "Dirt"},
    ["Water"] = {Color = "Cyan", Material = "Water"},
    ["Sand"] = {Color = "Sandy Yellow", Material = "Sand"},
    ["Missing"] = {Color = "Missing", Material = "Stud"},
}

Terrain.GetTypeInfo = function(name)
	return Types[name] or Types.Missing
end

Terrain.ApplyType = function(part, name)
    local typeInfo = Terrain.GetTypeInfo(name)
    Materials.Apply(part, typeInfo.Material)
	Colors.Apply(part, typeInfo.Color)
    part:SetAttribute("TerrainType", name)
end

return Terrain