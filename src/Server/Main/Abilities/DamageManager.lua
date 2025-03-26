local DamageManager = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local EntityUtility = require(ReplicatedStorage.Utility.Entity)

local VALID_DAMAGE_SOURCES = {
    "Unknown"
}

function DamageManager.Init()
    DamageManager.Stacks = {}
end

function DamageManager.PrintStacks()
    for entityID,stack in pairs(DamageManager.Stacks) do
        print(entityID,stack)
    end
end

function DamageManager.Damage(entityID, authorID, damage, sourceID)
    sourceID = sourceID or "Unknown"
    assert(table.find(VALID_DAMAGE_SOURCES, sourceID), "Invalid damage source id")

    local rig = EntityUtility.GetEntityFromEntityID(entityID)
    assert(rig, "Rig is nil")

    -- Register damage
    if not DamageManager.Stacks[entityID] then DamageManager.Stacks[entityID] = {} end
    table.insert(DamageManager.Stacks[entityID],
        {authorID = authorID, damage = damage, sourceID = sourceID}
    )

    -- Apply damage
    local humanoid = rig:FindFirstChild("Humanoid")
    if humanoid then
        humanoid:TakeDamage(damage)
    end

    DamageManager.PrintStacks()
end
return DamageManager