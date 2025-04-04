local Noise = {}

-- Cache for noise values
local noiseCache = {}
local CACHE_SIZE = 1000

local function noise(x, y, seed)
    -- Check cache first
    local key = string.format("%d,%d,%d", x, y, seed)
    if noiseCache[key] then
        return noiseCache[key]
    end
    
    -- Generate new noise value
    local value = math.clamp(math.noise(x, y, seed)+0.5, 0, 1)
    
    -- Cache the result
    if #noiseCache > CACHE_SIZE then
        table.remove(noiseCache, 1)
    end
    noiseCache[key] = value
    
    return value
end

function Noise.GenerateFractal(x, y, seed, scale, octaves, persistence, lacunarity)
    persistence = persistence or 0.4
    lacunarity = lacunarity or 2
    octaves = octaves or 8

    -- Reduce octaves for distant terrain
    local distance = math.sqrt(x*x + y*y)
    if distance > scale * 2 then
        octaves = math.max(4, octaves - 2)
    end

    local total = 0
    local frequency = 1
    local amplitude = 1
    local maxValue = 0

    for i = 1, octaves do
        total = total + noise(x/(scale/frequency), y/(scale/frequency), seed) * amplitude
        maxValue = maxValue + amplitude

        amplitude = amplitude * persistence
        frequency = frequency * lacunarity
    end

    return total / maxValue
end

function Noise.ClearCache()
    noiseCache = {}
end

function Noise.Debug(lenght,width)
	for x = 1, lenght do
		if x % 4 == 1 then
			game:GetService("RunService").PreSimulation:Wait()
		end
		for z = 1, width do
            local noiseY = Noise.GenerateFractal(x, z, 1, 50)
            local debugPart = Instance.new("Part")
            debugPart.Anchored = true
            debugPart.Parent = workspace
            debugPart.Position = Vector3.new(x,noiseY*20,z)
            debugPart.Size = Vector3.new(1, 1, 1)
            local color = noiseY * 255
            debugPart.Color = Color3.fromRGB(color,color,color)
        end
    end
end

function Noise.Init()
    --Noise.Debug(100,100)
end

return Noise
