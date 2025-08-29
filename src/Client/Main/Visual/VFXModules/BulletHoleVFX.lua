-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local BaseVFX = require(script.Parent.Parent.BaseVFX)
local AssetsDealer = require(ReplicatedStorage.AssetsDealer)
local Game = require(ReplicatedStorage.Utility.Game)

local BulletHole = setmetatable({}, BaseVFX)
BulletHole.__index = BulletHole

function BulletHole.new()
    local self = setmetatable(BaseVFX.new(), BulletHole)
    return self
end

function BulletHole:play(basePart: BasePart, position: Vector3, normal: Vector3)
    assert(basePart, "BasePart is nil")
    assert(position, "Position is nil")

    local node = AssetsDealer.GetDir("Meshes","Misc/Node","Clone")
    node.Parent = Game.Folders.Debug

    node.CFrame = CFrame.lookAt(position, position+normal)
end

return BulletHole