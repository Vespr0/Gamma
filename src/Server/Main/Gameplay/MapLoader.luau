--!native
--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local AssetsDealer = require(ReplicatedStorage.AssetsDealer)

local MapLoader = {}
MapLoader.__index = MapLoader

--[[
    A simple map loader class that gets a map from the Maps folder in
    Shared/AssetsDealer.luau as a clone and parents it to the workspace.
--]]

function MapLoader.new()
	local self = setmetatable({}, MapLoader)
	self.currentMap = nil :: Instance?
	return self
end

--[[
    Loads a map from the Maps folder in Shared/AssetsDealer.luau as a clone and
    parents it to the workspace. When a map is loaded the previous one is
    deleted.
--]]
function MapLoader:load(mapName: string): Instance?
	if self.currentMap then
		self.currentMap:Destroy()
		self.currentMap = nil
	end

	local mapAsset = AssetsDealer.Get("Maps", mapName, true)
	if mapAsset then
		mapAsset.Name = "Map"
		mapAsset.Parent = Workspace
		self.currentMap = mapAsset
		return mapAsset
	else
		warn(`Could not load map: {mapName}`)
		return nil
	end
end

--[[
    Unloads the current map.
--]]
function MapLoader:unload()
	if self.currentMap then
		self.currentMap:Destroy()
		self.currentMap = nil
	end
end

return MapLoader
