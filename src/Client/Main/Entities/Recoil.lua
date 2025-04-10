local Recoil = {}
Recoil.__index = Recoil

-- Services
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local Trove = require(ReplicatedStorage.Packages.trove)
local Signal = require(ReplicatedStorage.Packages.signal)
local Spring = require(ReplicatedStorage.Packages.spring)

-- Constants
local CAMERA = workspace.CurrentCamera
local SPRING_CONFIG = {
    frequency = 15,  -- Higher = faster initial movement
    damping = 0.8,  -- Lower = more responsive, higher = more rigid
}
local RANDOM_SPREAD_FACTOR = 0.1 -- Reduced for more consistent recoil
local ANGLE_MULTIPLIER = 8 -- Increased for more noticeable recoil
local SPRING_DECAY = 0.7 -- Increased for faster recovery
local KICK_MULTIPLIER = 1.2 -- Added for initial kick effect

function Recoil.new(entity)
    assert(entity, "Entity is nil!")

    local self = setmetatable({}, Recoil)
    
    self.entity = entity
    self.trove = Trove.new()
    self.random = Random.new()
    self.events = {
        RecoilApplied = Signal.new()
    }

    -- Create springs for vertical and horizontal recoil
    self.verticalSpring = Spring.new(SPRING_CONFIG.damping, SPRING_CONFIG.frequency, 0)
    self.horizontalSpring = Spring.new(SPRING_CONFIG.damping, SPRING_CONFIG.frequency, 0)

    -- Store original camera CFrame
    self.originalCFrame = CAMERA.CFrame

    -- Motor6DRecoil instance
    self.motor6DRecoil = self.entity.Motor6DManager.modules["Motor6DRecoil"]

    -- Connect to entity death
    self.trove:Connect(self.entity.events.Died, function()
        self:destroy()
    end)

    -- Connect to render stepped for spring updates
    self.trove:Connect(RunService.RenderStepped, function(deltaTime)
        self:update(deltaTime)
    end)

    return self
end

function Recoil:applyRecoil(vertical, horizontal)
    local randomVertical = vertical * self.random:NextNumber(0, RANDOM_SPREAD_FACTOR)
    local randomHorizontal = horizontal * self.random:NextNumber(-RANDOM_SPREAD_FACTOR, RANDOM_SPREAD_FACTOR)
    
    -- Apply initial kick effect
    local kickVertical = randomVertical * KICK_MULTIPLIER
    local kickHorizontal = randomHorizontal * KICK_MULTIPLIER
    
    -- Add force to springs by setting their goals
    self.verticalSpring:Set(self.verticalSpring:Get() + kickVertical * ANGLE_MULTIPLIER)
    self.horizontalSpring:Set(self.horizontalSpring:Get() + kickHorizontal * ANGLE_MULTIPLIER)
    
    -- Fire event for other systems to use
    self.events.RecoilApplied:Fire(randomVertical, randomHorizontal)

    -- print("Recoil: Found Recoil module, applying recoil", randomVertical)
    self.motor6DRecoil:applyRecoil(randomVertical)
end

function Recoil:update(deltaTime)
    -- Update springs
    self.verticalSpring:Step(deltaTime)
    self.horizontalSpring:Step(deltaTime)
    
    -- Get spring positions
    local verticalOffset = self.verticalSpring:Get()
    local horizontalOffset = self.horizontalSpring:Get()
    
    -- Apply camera recoil only for local player
    if self.entity.isLocalPlayerInstance then
        local currentCFrame = CAMERA.CFrame
        local newCFrame = currentCFrame * CFrame.Angles(
            math.rad(verticalOffset),  
            math.rad(horizontalOffset), 
            0
        )
        CAMERA.CFrame = newCFrame
    end
    
    -- Decay the springs over time
    self.verticalSpring:Set(self.verticalSpring:Get() * SPRING_DECAY)
    self.horizontalSpring:Set(self.horizontalSpring:Get() * SPRING_DECAY)
end

function Recoil:getCurrentRecoil()
    return {
        vertical = self.verticalSpring:Get(),
        horizontal = self.horizontalSpring:Get()
    }
end

function Recoil:destroy()
    if self.trove then
        self.trove:Destroy()
    end
    if self.events then
        self.events.RecoilApplied:Destroy()
    end
end

return Recoil 