local ClientLiquids = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

local Grid = require(ReplicatedStorage.Utility.Generation.Grid)
local Liquids = require(ReplicatedStorage.Liquids.Liquids)
local Game = require(ReplicatedStorage.Utility.Game)

local grid = Grid.new()
local CELL_SIZE = 1

local function convertGridPositionToWorldPosition(x, y, z)
    return Vector3.new(
        (x + 0.5) * CELL_SIZE,  -- Center in cell
        (y + 0.5) * CELL_SIZE,
        (z + 0.5) * CELL_SIZE
    )
end

function ClientLiquids.BreakIntoCells(part: BasePart)
    local liquidType = part:GetAttribute("LiquidType")
    local partCFrame = part.CFrame
    local partSize = part.Size

    -- Calculate the part's bounds in world space
    local minWorld = partCFrame.Position - (partSize / 2)
    local maxWorld = partCFrame.Position + (partSize / 2)

    -- Convert to grid cell indices
    local minX = math.floor(minWorld.X / CELL_SIZE)
    local minY = math.floor(minWorld.Y / CELL_SIZE)
    local minZ = math.floor(minWorld.Z / CELL_SIZE)
    local maxX = math.ceil(maxWorld.X / CELL_SIZE) - 1
    local maxY = math.ceil(maxWorld.Y / CELL_SIZE) - 1
    local maxZ = math.ceil(maxWorld.Z / CELL_SIZE) - 1

    -- Fill the grid cells covered by the part
    for x = minX, maxX do
        for y = minY, maxY do
            for z = minZ, maxZ do
                grid:set(x, y, z, liquidType)
            end
        end
    end

    part:Destroy()
end

function ClientLiquids.Connect(part: BasePart)
    ClientLiquids.BreakIntoCells(part)
end

local function createPart(liquidType, x, y, z)
    local liquidInfo = Liquids[liquidType]

    local part = Instance.new("Part")
    part.Parent = Game.Folders.Liquids
    part.Size = Vector3.new(CELL_SIZE, CELL_SIZE, CELL_SIZE)
    part.Position = convertGridPositionToWorldPosition(x, y, z)
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = liquidInfo.Transparency
    part.Material = liquidInfo.Material
    part.Color = liquidInfo.Color
end

local function render()
    -- Clear previous parts
    for _, part in pairs(Game.Folders.Liquids:GetChildren()) do
        part:Destroy()
    end

    -- Get grid bounds
    local minX, maxX = grid.minX, grid.maxX
    local minY, maxY = grid.minY, grid.maxY
    local minZ, maxZ = grid.minZ, grid.maxZ

    -- Iterate through all possible grid cells
    for x = minX, maxX do
        for y = minY, maxY do
            for z = minZ, maxZ do
                local liquidType = grid:get(x, y, z)
                if liquidType then
                    createPart(liquidType, x, y, z)
                end
            end
        end
    end
end

local function raycastDown(x, y, z)
    local worldPosition = convertGridPositionToWorldPosition(x, y, z)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Include
    raycastParams.FilterDescendantsInstances = { Game.Folders.Map }
    local result = workspace:Raycast(worldPosition, Vector3.new(0, -1, 0), raycastParams)
    if result then
        return result
    end
end

local function raycastSide(x, y, z, direction)
    local worldPosition = convertGridPositionToWorldPosition(x, y, z)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Include
    raycastParams.FilterDescendantsInstances = { Game.Folders.Map }
    local result = workspace:Raycast(worldPosition, direction, raycastParams)
    if result then
        return result
    end
end

-- Moves liquid
local function simulate()
    for x = grid.minX, grid.maxX do
        for y = grid.minY, grid.maxY do
            for z = grid.minZ, grid.maxZ do
                local liquidType = grid:get(x, y, z)
                if liquidType then
                    -- Check if below is empty
                    if grid:get(x, y - 1, z) == nil and not raycastDown(x, y, z) then
                        -- Move down
                        grid:set(x, y - 1, z, liquidType)
                        grid:set(x, y, z, nil)
                    else
                        -- Try moving in all 4 directions (left, right, forward, backward)
                        local directions = {
                            Vector3.new(-CELL_SIZE, 0, 0),  -- Left
                            Vector3.new(CELL_SIZE, 0, 0),    -- Right
                            Vector3.new(0, 0, -CELL_SIZE),   -- Backward
                            Vector3.new(0, 0, CELL_SIZE)     -- Forward
                        }
                        for _, direction in ipairs(directions) do
                            local sideX = x + direction.X / CELL_SIZE
                            local sideZ = z + direction.Z / CELL_SIZE
                            if grid:get(sideX, y, sideZ) == nil and not raycastSide(x, y, z, direction) then
                                -- Move to the side
                                grid:set(sideX, y, sideZ, liquidType)
                                grid:set(x, y, z, nil)
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

function ClientLiquids.Step()
    simulate()
    render()
end

function ClientLiquids.Init()
    -- Process existing liquid parts
    -- local parts = CollectionService:GetTagged("Liquid")
    -- for _, part in pairs(parts) do
    --     ClientLiquids.Connect(part)
    -- end

    -- -- Listen for new parts
    -- CollectionService:GetInstanceAddedSignal("Liquid"):Connect(function(part: BasePart)
    --     ClientLiquids.Connect(part)
    -- end)

    -- -- Simulation loop
    -- while true do
    --     ClientLiquids.Step()
    --     RunService.RenderStepped:Wait()
    -- end
end

return ClientLiquids