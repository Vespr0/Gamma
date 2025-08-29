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

    local humanoid = rig:FindFirstChild("Humanoid")
    if humanoid then
        local actualDamage = math.min(damage, humanoid.Health)
        -- Register damage
        if not DamageManager.Stacks[entityID] then DamageManager.Stacks[entityID] = {} end
        table.insert(DamageManager.Stacks[entityID],
            {authorID = authorID, damage = actualDamage, sourceID = sourceID}
        )
        -- Check if this damage will kill the target
        if humanoid.Health - actualDamage <= 0 then
            DamageManager.OnKill(entityID, authorID, actualDamage)
        end
        humanoid:TakeDamage(actualDamage)
    end

    DamageManager.PrintStacks()
end
function DamageManager.OnKill(entityID, authorID, damage)
    -- Find the highest damage contributor
    local contributors = {}
    if DamageManager.Stacks[entityID] then
        for _, entry in ipairs(DamageManager.Stacks[entityID]) do
            contributors[entry.authorID] = (contributors[entry.authorID] or 0) + entry.damage
        end
    end

    -- Include the current damage
    contributors[authorID] = (contributors[authorID] or 0) + damage

    -- Find the highest contributor
    local topContributor = nil
    local topDamage = -math.huge
    for id, total in pairs(contributors) do
        if total > topDamage then
            topDamage = total
            topContributor = id
        end
    end

    print(string.format(
        "[Death Detected] %s was killed by %s. Highest damage contributor: %s (%d damage)",
        tostring(entityID),
        tostring(authorID),
        tostring(topContributor),
        topDamage
    ))
end

return DamageManager