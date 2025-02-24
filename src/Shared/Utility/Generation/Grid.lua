local Grid = {}
Grid.__index = Grid
    
function Grid.new()
    local self = setmetatable({}, Grid)

    self.data = {}

    -- Track min/max indices for each axis
    self.minX = math.huge
    self.minY = math.huge
    self.minZ = math.huge
    self.maxX = -math.huge
    self.maxY = -math.huge
    self.maxZ = -math.huge

    return self
end

function Grid:get(x,y,z)
    if self.data[x] and self.data[x][y] then
        return self.data[x][y][z]
    end
    return nil
end

function Grid:set(x, y, z, val)
    if not self.data[x] then 
        self.data[x] = {}
    end
    if not self.data[x][y] then
        self.data[x][y] = {}
    end

    self.data[x][y][z] = val

    -- Update min/max indices
    self.minX = math.min(self.minX, x)
    self.minY = math.min(self.minY, y)
    self.minZ = math.min(self.minZ, z)
    self.maxX = math.max(self.maxX, x)
    self.maxY = math.max(self.maxY, y)
    self.maxZ = math.max(self.maxZ, z)
end

function Grid:remove(x, y, z)
    local entry = self.data[x][y][z] 
    if entry then entry:Destroy() end
    self.data[x][y][z] = nil
end

function Grid:clearY(x, y)
    self.data[x][y] = nil
end

function Grid:clearX(x)
    self.data[x] = nil
end

function Grid:clearAll()
    self.data = {}
end


return Grid