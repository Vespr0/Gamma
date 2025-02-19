local World = {}
World.__index = World

-- Services 
local RunService = game:GetService("RunService")
-- Folders
local Terrain = script.Parent.Terrain
-- Modules
local Terra = require(Terrain.Terra)
local Voxels = require(Terrain.Voxels)

function World.new()
    local self = setmetatable({}, World)

    -- Terrain
    self.origin = Vector3.zero
    self.terrain = Voxels.new("Terrain")
    self.terra = Terra.new(self.origin,self.terrain)

    return self
end

function World:generate()
    self.terra:generate()
end

function World:optimize()
    self.terrain:mergeAll()
end

-- Setup 

function World.SetSeed()
    -- TODO: workspace:SetAttribute("Seed", not RunService:IsStudio() and Teleporter.GetPositionFromPrivateServerId(game.PrivateServerId) or 1)    
    return 1
end

function World.Setup()
    World.SetSeed()
end

function World.Init()
    -- World.Setup()

	-- local start = os.clock()

	-- local world = World.new()
	-- world:generate()
	-- world:optimize()

	-- print(`World generated in [{os.clock() - start}] seconds.`)
end

return World