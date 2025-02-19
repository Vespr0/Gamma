local Grid = {}
Grid.__index = Grid
    
function Grid.new()
    local self = setmetatable({}, Grid)

	self.data = {};

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
        self.data[x] = {
            [y] = {}
        }
    elseif not self.data[x][y] then
        self.data[x][y] = {}
    end

    self.data[x][y][z] = val
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