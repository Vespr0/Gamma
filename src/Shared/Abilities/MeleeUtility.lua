local MeleeUtility = {}

-- Services
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local RaycastHitbox = require(ReplicatedStorage.Packages.raycasthitbox)
local Signal = require(ReplicatedStorage.Packages.signal)

function MeleeUtility.CreateHitbox(rig)
    local tool = rig:FindFirstChildOfClass("Tool")
    local model = tool:FindFirstChild("Model")
    local handle = model:FindFirstChild("Handle")
    local hitbox = RaycastHitbox.new(handle)

    hitbox.DebugMode = RunService:IsStudio()

    hitbox.Hit = Signal.new()
    hitbox.OnHit:Connect(function(hit, humanoid)
        if humanoid == rig.Humanoid then return end

        local entityID = humanoid.Parent:GetAttribute("ID")

        if not entityID then error("EntityID not found") return end

        local hitPartName = hit.Name
        hitbox.Hit:Fire(entityID,hitPartName)
    end)

    return hitbox
end

return MeleeUtility