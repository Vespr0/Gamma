--!strict
-- Ragdoll.lua
-- Handles ragdolling of characters using SocketConstraints

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PhysicsService = game:GetService("PhysicsService")

-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local Trove = require(ReplicatedStorage.Packages.trove)
local TypeEntity = require(ReplicatedStorage.Types.TypeEntity)
local EntityUtility = require(ReplicatedStorage.Utility.Entity)

-- Class
local Ragdoll = {}
Ragdoll.__index = Ragdoll
Ragdoll.Instances = {}

function Ragdoll.new(entity: TypeEntity.ServerEntity)
    assert(entity, "No entity provided to Ragdoll")
    local self = setmetatable({}, Ragdoll)
    self.entity = entity
    self.rig = entity.rig
    self.trove = Trove.new()
    self.isRagdolled = false
    self._storedMotors = {}
    self._sockets = {}
    self.events = {
        Ragdolled = Signal.new(),
        Unragdolled = Signal.new(),
    }
    Ragdoll.Instances[entity.id] = self
    return self
end

-- Helper to get all Motor6Ds in the rig
local function getMotors(rig)
    local motors = {}
    for _,desc in ipairs(rig:GetDescendants()) do
        if desc:IsA("Motor6D") then
            motors[#motors+1] = desc
        end
    end
    return motors
end

-- Helper to create a BallSocketConstraint between two parts, with attachments matching Motor6D's C0 and C1
local function createBallSocket(part0, part1, c0, c1)
    local att0 = Instance.new("Attachment")
    att0.Name = "RagdollAttachment0"
    att0.CFrame = c0 or CFrame.new()
    att0.Parent = part0
    local att1 = Instance.new("Attachment")
    att1.Name = "RagdollAttachment1"
    att1.CFrame = c1 or CFrame.new()
    att1.Parent = part1
    local constraint = Instance.new("BallSocketConstraint")
    constraint.Attachment0 = att0
    constraint.Attachment1 = att1
    constraint.LimitsEnabled = true
    constraint.Parent = part0
    return constraint, att0, att1
end

--[[
    Creates a smaller clone of the bodypart for collisions (normal sized bodyparts would not 
    be able to move freely as they would get stuck)
]]
function Ragdoll:dummifyBodyPart(bodyPart:BasePart)
    bodyPart.CanCollide = false

    local dummifiedPart = bodyPart:Clone()
    dummifiedPart.Size = bodyPart.Size * 0.9
    dummifiedPart.Parent = bodyPart.Parent
    dummifiedPart.Transparency = 1
    dummifiedPart.Massless = true
    dummifiedPart.CanCollide = true
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = bodyPart
    weld.Part1 = dummifiedPart
    weld.Parent = bodyPart

    bodyPart:SetNetworkOwner(nil)
    dummifiedPart:SetNetworkOwner(nil)
    return dummifiedPart
end

function Ragdoll:EnableRagdoll()
    if self.isRagdolled then return end
    self.isRagdolled = true
    self._storedMotors = {}
    self._sockets = {}
    local rig = self.rig
    -- Replace each Motor6D with a SocketConstraint
    for _, motor in ipairs(getMotors(rig)) do
        local part0 = motor.Part0
        local part1 = motor.Part1
        if part0 and part1 then
            -- Store the motor for restoration
            self._storedMotors[#self._storedMotors+1] = {motor = motor, parent = motor.Parent}
            motor.Enabled = false
            motor.Parent = nil
            -- Create BallSocketConstraint at the same position as the Motor6D
            local constraint, att0, att1 = createBallSocket(part0, part1, motor.C0, motor.C1)
            self._sockets[#self._sockets+1] = {constraint = constraint, att0 = att0, att1 = att1}
        end
    end

    for _, part in ipairs(rig:GetDescendants()) do
        if part:IsA("BasePart") then
            self:dummifyBodyPart(part)
        end
    end

    self.events.Ragdolled:Fire()
end

function Ragdoll:DisableRagdoll()
    if not self.isRagdolled then return end
    self.isRagdolled = false
    -- Remove all SocketConstraints and attachments
    for _, s in ipairs(self._sockets) do
        if s.socket then s.socket:Destroy() end
        if s.att0 then s.att0:Destroy() end
        if s.att1 then s.att1:Destroy() end
    end
    self._sockets = {}
    -- Restore all Motor6Ds
    for _, data in ipairs(self._storedMotors) do
        local motor, parent = data.motor, data.parent
        motor.Parent = parent
        motor.Enabled = true
    end
    self._storedMotors = {}
    -- Optionally, reset physics
    for _, part in ipairs(self.rig:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.Massless = true
        end
    end
    self.events.Unragdolled:Fire()
end

function Ragdoll:Destroy()
    self:DisableRagdoll()
    self.trove:Destroy()
    Ragdoll.Instances[self.entity.id] = nil
end

return Ragdoll
