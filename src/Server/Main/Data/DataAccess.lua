local DataAccess = {}

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Folders --
local Packages = ReplicatedStorage.Packages
local DataAccessModules = script.Parent.PlayerDataModules

-- Modules --
local DataStoreModule = require(Packages.suphisdatastoremodule)
local DataUtility = require(ReplicatedStorage.Data.DataUtility)
local Signal = require(Packages.signal)
local PlayerDataStore = require(script.Parent.PlayerDataStore)

-- Signals --
DataAccess.PlayerDataChanged = Signal.new()

-- Error Constants --
local ERRORS = {
    ACCESS_ATTEMPT_FAILED_NIL = "📋 Trying to access datastore, but it is nil.",
    ACCESS_ATTEMPT_FAILED_CLOSED = "📋 Trying to access datastore, but it is closed.",
    ACCESS_FAILED = "📋 Failed to access datastore.",
    INVALID_PARAMETERS = "📋 Invalid parameter, %q is nil",
    TIMEOUT = "📋 Operation timed out for key: %s",
    DESTROYED = "📋 Datastore was destroyed for key: %s"
}

DataAccess.Errors = ERRORS

-- Variables --
DataAccess.DataUtility = DataUtility

-- Local Utility Functions --

local function createPromise()
    return {
        completed = false,
        result = nil,
        error = nil
    }
end

local function cleanupConnections(...)
    for _, connection in ipairs({...}) do
        if connection then
            connection:Disconnect()
        end
    end
end

local function isDataStoreAccessible(dataStore)
    if dataStore == nil then
        return false, ERRORS.ACCESS_ATTEMPT_FAILED_NIL
    end
    if dataStore.State ~= true then
        return false, ERRORS.ACCESS_ATTEMPT_FAILED_CLOSED
    end
    return true
end

local function handleDataStoreTimeout(promise, key, timeout, startTime)
    return game:GetService("RunService").Heartbeat:Connect(function()
        if tick() - startTime > timeout then
            promise.completed = true
            promise.result = false
            promise.error = string.format(ERRORS.TIMEOUT, key)
        end
    end)
end

local function handleStateChanged(dataStore, promise, cleanupFunc)
    return dataStore.StateChanged:Connect(function(state)
        if promise.completed then return end
        
        if state == true then
            cleanupFunc()
            promise.completed = true
            promise.result = dataStore
        elseif state == false then
            local response = dataStore:Open(PlayerDataStore.DataTemplate or {})
            if response ~= "Success" then
                warn("Failed to open datastore: " .. response)
            end
        elseif state == nil then
            cleanupFunc()
            promise.completed = true
            promise.result = false
            promise.error = string.format(ERRORS.DESTROYED, dataStore.Key or "unknown")
        end
    end)
end

-- Parameter Validation --
function DataAccess.GetParameters(...)
    local args = {...}
    local validatedArgs = {}
    
    for i, v in ipairs(args) do
        if v == nil then
            error(string.format(ERRORS.INVALID_PARAMETERS, i))
        end
        validatedArgs[i] = v
    end
    
    if #validatedArgs > 0 then
        return table.unpack(validatedArgs)
    end
    
    return nil
end

-- Data Store Access Core --
function DataAccess.AccessDataStore(name, key, maxRetries, timeout)
    maxRetries = maxRetries or 5
    timeout = timeout or 6
    local scope = name or DataUtility.GetDataScope("Player")
    
    for attempt = 1, maxRetries do
        local startTime = tick()
        local dataStore = DataStoreModule.find(scope, key)
        
        -- Check if datastore is immediately accessible
        local accessible, errorMsg = isDataStoreAccessible(dataStore)
        if accessible then
            return dataStore
        end
        
        -- Create new datastore if not found
        if dataStore == nil then
            dataStore = DataStoreModule.new(scope, key)
        end
        
        -- Try to open directly first
        local response = dataStore:Open(PlayerDataStore.DataTemplate or {})
        if response == "Success" then
            return dataStore
        end
        
        -- Use async waiting with timeout
        local promise = createPromise()
        local timeoutConnection
        local stateChangedConnection
        
        local function cleanup()
            cleanupConnections(timeoutConnection, stateChangedConnection)
        end
        
        timeoutConnection = handleDataStoreTimeout(promise, key, timeout, startTime)
        stateChangedConnection = handleStateChanged(dataStore, promise, cleanup)
        
        -- Wait for completion with timeout
        local waitStart = tick()
        while not promise.completed and tick() - waitStart < timeout do
            task.wait(0.1)
        end
        
        cleanup()
        
        if promise.result then
            return promise.result
        end
        
        -- Retry after delay if not successful
        if attempt < maxRetries then
            warn(errorMsg .. " ...Retrying attempt #" .. tostring(attempt))
            task.wait(1)
        end
    end
    
    return false, string.format(ERRORS.ACCESS_FAILED, key)
end

-- Asynchronous Data Store Access --
function DataAccess.AccessDataStoreAsync(name, key, timeout)
    timeout = timeout or 6
    local scope = name or DataUtility.GetDataScope("Player")
    
    local dataStore = DataStoreModule.find(scope, key)
    
    -- Check immediate accessibility
    local accessible = isDataStoreAccessible(dataStore)
    if accessible then
        return dataStore
    end
    
    -- Create new datastore if not found
    if dataStore == nil then
        dataStore = DataStoreModule.new(scope, key)
    end
    
    local promise = createPromise()
    local timeoutConnection
    local stateChangedConnection
    
    local function cleanup()
        cleanupConnections(timeoutConnection, stateChangedConnection)
    end
    
    local startTime = tick()
    timeoutConnection = handleDataStoreTimeout(promise, key, timeout, startTime)
    stateChangedConnection = handleStateChanged(dataStore, promise, cleanup)
    
    -- Trigger initial state check and opening if needed
    local initialState = dataStore.State
    if initialState == true then
        cleanup()
        return dataStore
    elseif initialState == false then
        local response = dataStore:Open(PlayerDataStore.DataTemplate or {})
        if response ~= "Success" then
            warn("Failed to open datastore: " .. response)
        end
    elseif initialState == nil then
        cleanup()
        return false, string.format(ERRORS.DESTROYED, key)
    end
    
    -- Wait for completion with timeout
    while not promise.completed and tick() - startTime < timeout do
        task.wait(0.1)
    end
    
    cleanup()
    
    return promise.result, promise.error
end

-- Data Retrieval Functions --
function DataAccess.GetFull(...)
    local player = DataAccess.GetParameters(...)
    if not player then return nil end

    local dataStore = DataAccess.AccessDataStore(nil, player.UserId)
    if not dataStore then return nil end
    
    return dataStore.Value
end

function DataAccess.GetPlayerData(player, dataKey)
    if not player then return nil end
    
    local dataStore = DataAccess.AccessDataStore(nil, player.UserId)
    if not dataStore or not dataStore.Value then return nil end
    
    return dataStore.Value[dataKey]
end

function DataAccess.SetPlayerData(player, dataKey, value)
    if not player then return false end
    
    local dataStore = DataAccess.AccessDataStore(nil, player.UserId)
    if not dataStore then return false end
    
    dataStore.Value[dataKey] = value
    return true
end

-- Module Initialization --
function DataAccess.Init()
    for _, moduleScript in ipairs(DataAccessModules:GetChildren()) do
        if moduleScript:IsA("ModuleScript") then
            local module = require(moduleScript)
            if type(module.Init) == "function" then
                module.Init()
            end
        end
    end
end

return DataAccess