local PlayerData = {}

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Folders --
local Packages = ReplicatedStorage.Packages
local PlayerDataModules = script.Parent.PlayerDataModules

-- Modules --
local DataAccess = require(script.Parent.DataAccess)
local PlayerDataManager = require(script.Parent.PlayerDataManager)

function PlayerData.Get(player, key)
    local data = DataAccess.GetFull(player)
    if data and data[key] then
        return data[key]
    end
    return nil
end

function PlayerData.GetFull(player)
    return DataAccess.GetFull(player)
end

function PlayerData.Set(player, key, value)
    local dataStore = DataAccess.AccessDataStore(nil, player.UserId)
    if not dataStore then
        return
    end
    dataStore.Value[key] = value
end

function PlayerData.Increment(player, key, delta)
    local dataStore = DataAccess.AccessDataStore(nil, player.UserId)
    if not dataStore then
        return
    end
    dataStore.Value[key] = (dataStore.Value[key] or 0) + delta
end

function PlayerData.WipePlayerData(player)
    if not player then
        return false, "Player not provided"
    end
    return PlayerDataManager.WipeUserData(player.UserId)
end

function PlayerData.GetFullByUserId(userId)
    -- For offline players, access data store directly
    local DataAccess = require(script.Parent.DataAccess)
    local dataStore = DataAccess.AccessDataStore(nil, tostring(userId))
    if dataStore then
        return dataStore.Value
    end
    return nil
end

function PlayerData.AccessDataStoreByUserId(userId)
    -- Direct access to data store for offline operations
    local DataAccess = require(script.Parent.DataAccess)
    return DataAccess.AccessDataStore(nil, tostring(userId))
end

function PlayerData.WipePlayerDataByUserId(userId)
    -- Wipe data for offline player by userId
    return PlayerDataManager.WipeUserData(userId)
end

function PlayerData.GetNested(player, ...)
    -- Get nested data using dot notation or multiple keys
    local keys = {...}
    local data = PlayerData.GetFull(player) or {}
    
    for _, key in ipairs(keys) do
        if type(data) ~= "table" then
            return nil
        end
        data = data[key]
    end
    
    return data
end

function PlayerData.SetNested(player, value, ...)
    -- Set nested data using dot notation or multiple keys
    local keys = {...}
    if #keys == 0 then
        return false
    end
    
    local data = PlayerData.GetFull(player) or {}
    local current = data
    
    -- Navigate to the parent of the target key
    for i = 1, #keys - 1 do
        local key = keys[i]
        if current[key] == nil then
            current[key] = {}
        elseif type(current[key]) ~= "table" then
            -- Cannot set nested value on non-table
            return false
        end
        current = current[key]
    end
    
    -- Set the final value
    current[keys[#keys]] = value
    
    -- Save the entire structure
    local dataStore = DataAccess.AccessDataStore(nil, player.UserId)
    if dataStore then
        dataStore.Value = data
        return true
    end
    
    return false
end

function PlayerData.IncrementNested(player, delta, ...)
    -- Increment nested numeric value
    local keys = {...}
    if #keys == 0 then
        return false
    end
    
    local currentValue = PlayerData.GetNested(player, unpack(keys)) or 0
    if type(currentValue) ~= "number" then
        return false
    end
    
    return PlayerData.SetNested(player, currentValue + delta, unpack(keys))
end

function PlayerData.EnsureDataStructure(player, template)
    -- Ensure player data has the required structure from template
    local data = PlayerData.GetFull(player) or {}
    local changed = false
    
    local function reconcile(target, source)
        for key, value in pairs(source) do
            if target[key] == nil then
                target[key] = type(value) == "table" and {} or value
                changed = true
            elseif type(target[key]) == "table" and type(value) == "table" then
                changed = reconcile(target[key], value) or changed
            end
        end
        return changed
    end
    
    if reconcile(data, template) then
        local dataStore = DataAccess.AccessDataStore(nil, player.UserId)
        if dataStore then
            dataStore.Value = data
            return true
        end
    end
    
    return false
end

function PlayerData.Init()
    for _, dataModule in pairs(PlayerDataModules:GetChildren()) do
        if dataModule:IsA("ModuleScript") then
            local module = require(dataModule)
            if module.Init then
                module.Init()
            end
        end
    end
end

return PlayerData