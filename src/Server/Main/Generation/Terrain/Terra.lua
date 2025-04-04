local Terra = {}
Terra.__index = Terra

-- Services
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Modules
local Noise = require(script.Parent.Parent.Noise)
local Game = require(ReplicatedStorage.Utility.Game)
local Parts = require(ReplicatedStorage.Utility.Parts)
local Vectors = require(ReplicatedStorage.Utility.Vectors)

-- Constants
local MAP_HEIGHT = 100
local TERRAIN_DENSITY_THRESHOLD = 0.4
local UNDERGROUND_DENSITY_THRESHOLD = TERRAIN_DENSITY_THRESHOLD - 0.05
local CAVE_DENSITY = 0.5
local DIRT_LAYER_THICKNESS = 0.1
local CRAZINESS = 0.7
local SEA_LEVEL = 30
local CHUNK_SIZE = 16
local BATCH_SIZE = 100

function Terra.new(origin: Vector3, terrain)
	local self = setmetatable({}, Terra)
	
    self.origin = origin or Vector3.zero
	self.noiseScale = 30
	self.seed = 1 -- TODO: workspace:GetAttribute("Seed") 

	self.terrain = terrain
	self.folder = terrain.folder
	
	-- Chunk tracking
	self.generatedChunks = {}
	self.pendingParts = {}

	return self
end

function Terra:getPositionStringKey(position)
	if typeof(position) ~= "Vector3" then error("Position is not a Vector3") return end

	return tostring(position.X)..","..tostring(position.Y)..","..tostring(position.Z)
end

function Terra:noiseCoordinateToWorldCoordinate(c)
	if typeof(c) ~= "number" then error("Coordinate is not a number") return end

	return c*Game.Generation.PART_WIDTH - Game.Generation.WORLD_SIZE/2
end

function Terra:generatePart(x,y,z)
	local info = {}

	local position = Vectors.snap(Vector3.new(x,y,z))
	local partsInfoKey = self:getPositionStringKey(position)

	-- Skip if already generated
	if self.partsInfo[partsInfoKey] then
		return self.partsInfo[partsInfoKey].part
	end

	-- Densities
	local terrainNoise = self:get3DNoise(x, y, z,self.seed,true)
	local heightBias = y / MAP_HEIGHT
	info.terrainDensity = ((terrainNoise * CRAZINESS) + heightBias) / (CRAZINESS + 1)
	local caveSeed = self.seed + 1
	local caveNoiseScale = self.noiseScale 
	info.caveDensity = self:get3DNoise(x, y*2, z, caveSeed, caveNoiseScale, 8)
	-- Terrain Type Info
	info.isBedrock = y == 1
	info.isLand = (info.terrainDensity > 0 and info.terrainDensity < TERRAIN_DENSITY_THRESHOLD)
	info.isUnderground = info.terrainDensity < UNDERGROUND_DENSITY_THRESHOLD
	info.isCave = info.isUnderground and info.caveDensity > CAVE_DENSITY --or info.terrainDensity > UNDERGROUND_DENSITY_THRESHOLD-DIRT_LAYER_THICKNESS
	info.isSand = not info.isBedrock and not info.isUnderground and y <= SEA_LEVEL
	info.isCrustHole = (info.caveDensity > 0.9 and info.terrainDensity > UNDERGROUND_DENSITY_THRESHOLD-DIRT_LAYER_THICKNESS) 
	info.isSurface = info.isLand and not info.isUnderground and not info.isCrustHole
	info.isWater = not info.isLand and y == SEA_LEVEL-1
	
	local function place()
		self.parts += 1
		local position = Vector3.new(self:noiseCoordinateToWorldCoordinate(x), y * Game.Generation.PART_HEIGHT, self:noiseCoordinateToWorldCoordinate(z))

		-- Create the part
		info.part = self.terrain:place(position)
		 
		-- Update surfaceHeight for (x, z)
		local surfaceKey = tostring(x) .. "," .. tostring(z)
		if not self.surfaceHeights[surfaceKey] or y > self.surfaceHeights[surfaceKey] then
			self.surfaceHeights[surfaceKey] = y
		end

		self.partsInfo[partsInfoKey] = info
		return info.part
	end

	-- Determine if the part should be placed
	if info.isBedrock or info.isWater or info.isSurface or info.isCave then 
		return place()  
	end
end

function Terra:decoratePart(part)
	local pos = part.Position
	local x = (pos.X + Game.Generation.WORLD_SIZE / 2) / Game.Generation.PART_WIDTH
	local y = pos.Y / Game.Generation.PART_HEIGHT
	local z = (pos.Z + Game.Generation.WORLD_SIZE / 2) / Game.Generation.PART_WIDTH
	local surfaceKey = tostring(x) .. "," .. tostring(z)

	local info = self.partsInfo[self:getPositionStringKey(Vector3.new(x,y,z))]

	if not info then warn(`No info for part at position [{pos}]`) return end

	local function getTerrainType()
		local surfacePart = self.surfaceHeights[surfaceKey] == y
		if info.isBedrock then
			return "Bedrock"
		end
		if info.isUndergound then
			return "Dirt"
		else
			if info.isWater then
				return "Water"
			end
			if info.isSand then
				return "Sand"
			end
			if surfacePart then 
				return "Grass"
			end
			if info.isCave then
				return "Stone"
			end
			return "Dirt"
		end
		--return "Missing","Terrain"
	end

	Parts.ApplyType(part, getTerrainType())
end

function Terra:generateChunk(chunkX, chunkZ)
	local chunkKey = string.format("%d,%d", chunkX, chunkZ)
	if self.generatedChunks[chunkKey] then return end
	
	local startX = chunkX * CHUNK_SIZE
	local startZ = chunkZ * CHUNK_SIZE
	
	for x = startX, startX + CHUNK_SIZE - 1 do
		for y = 1, MAP_HEIGHT do
			for z = startZ, startZ + CHUNK_SIZE - 1 do
				self:generatePart(x, y, z)
			end
		end
	end
	
	self.generatedChunks[chunkKey] = true
end

function Terra:processBatch()
	if #self.pendingParts == 0 then return end
	
	local batch = {}
	for i = 1, math.min(BATCH_SIZE, #self.pendingParts) do
		table.insert(batch, table.remove(self.pendingParts))
	end
	
	for _, part in ipairs(batch) do
		self:decoratePart(part)
	end
	
	if #self.pendingParts > 0 then
		task.spawn(function()
			task.wait(0.1) -- Prevent overwhelming the server
			self:processBatch()
		end)
	end
end

function Terra:generate()
	self.partsPerSide = Game.Generation.WORLD_SIZE / Game.Generation.PART_WIDTH
	self.parts = 0
	self.partsInfo = {}
	self.surfaceHeights = {}
	self.pendingParts = {}

	print("Generating geometry...")

	-- Generate chunks in a spiral pattern from center
	local numChunks = math.ceil(self.partsPerSide / CHUNK_SIZE)
	local centerChunk = math.floor(numChunks / 2)
	
	for radius = 0, centerChunk do
		for x = -radius, radius do
			for z = -radius, radius do
				if math.abs(x) == radius or math.abs(z) == radius then
					self:generateChunk(centerChunk + x, centerChunk + z)
					if radius > 0 then
						RunService.Heartbeat:Wait()
					end
				end
			end
		end
	end
	
	print("Geometry generated")

	print("Decorating geometry...")
	-- Queue all parts for decoration
	for _, part in pairs(self.folder:GetChildren()) do
		table.insert(self.pendingParts, part)
	end
	
	-- Process decoration in batches
	self:processBatch()
	print("Geometry decorated")
end

function Terra:generateBounds()
    local halfLength = Game.Generation.WORLD_SIZE / 2
    local halfPartLength = Game.Generation.PART_WIDTH / 2
    local height = 100 -- Height of the bounds; can be adjusted as needed
    local thickness = 10 -- Thickness of the bounds

    local boundsPositions = {
        CFrame.new(halfLength + halfPartLength, height / 2, 0) * CFrame.Angles(0, math.rad(90), 0),
        CFrame.new(-(halfLength + halfPartLength), height / 2, 0) * CFrame.Angles(0, math.rad(90), 0),
        CFrame.new(0, height / 2, halfLength + halfPartLength) * CFrame.Angles(0, math.rad(0), 0),
        CFrame.new(0, height / 2, -(halfLength + halfPartLength)) * CFrame.Angles(0, math.rad(0), 0)
    }

    for _, cframe in ipairs(boundsPositions) do
        local size = Vector3.new(Game.Generation.WORLD_SIZE + 2 * Game.Generation.PART_WIDTH, height, thickness)
        self:createPart(cframe, size, "Pure Black", "Void")
    end
end

function Terra:getOriginBias(x,z)
	local originDistance = (self.origin-Vector3.new(self:noiseCoordinateToWorldCoordinate(x),0,self:noiseCoordinateToWorldCoordinate(z))).Magnitude
	local bias = originDistance/Game.Generation.WORLD_SIZE

	local THRESHOLD = 0.7
	if bias > THRESHOLD then
		bias = (bias-THRESHOLD)*3
	end

	return math.clamp(bias^2,0,1)
end

function Terra:get3DNoise(x, y, z, seed, originBiased, size, octaves)
	local xNoise = self:getNoise(y,z,seed,size,octaves)
	local yNoise = self:getNoise(x,z,seed,size,octaves)
	local zNoise = self:getNoise(x,y,seed,size,octaves)

	local finalNoise = (xNoise+yNoise+zNoise)/3

	if originBiased then finalNoise = finalNoise+self:getOriginBias(x, z) end

	return math.clamp(finalNoise, 0, 1), xNoise, yNoise, zNoise
end

function Terra:getNoise(x, y, seed, scale, octaves)
    -- Generate terrain noise
    local noise = Noise.GenerateFractal(x, y, seed or self.seed, scale or self.noiseScale, octaves or 5) 
	
    return math.clamp(noise, 0, 1)
end

return Terra