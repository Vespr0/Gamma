
Suphi's DataStore Module is the module choosen for handling persistent data in MiniTycoon, no need to use roblox's default datastore service...

Features

Session locking            "Prevents another object from opening the same datastore key while its opened by another object"
Cross Server Communication "Easily use MemoryStoreQueue to send data to the session owner"
Auto Save                  "Automatically saves cached data to the datastore based on the saveinterval property"
Bind To Close              "Automatically saves, closes and destroys all sessions when server starts to close"
Reconcile                  "Fills in missing values from the template into the value property"
Compression                "Compress data to reduce character count"
Multiple Script Support    "Safe to interact with the same datastore object from multiple scripts"
Task Batching              "Tasks will be batched together when possible"
Direct Value Access        "Access the datastore value directly, module will never tamper with your data and will never leave any data in your datastore or memorystore"
Easy To Use                "Simple and elegant"
Lightweight                "No RunService events and no while true do loops 100% event based"

Support My Work

If you liked my work and want to donate to me you can do so here
SourceCode
You can get the sourcecode to this module here

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted.
Common problems

Datastore locked when teleporting or migrating to latest update
    "simple rule to follow to make sure you dont have this problem"
        only use DataStoreModule.new() inside PlayerAdded and no where else

    "how to test if your breaking this rule"
        local function StateChanged(state, dataStore)
            if state == nil then print("Destroyed", dataStore.Id) end
            if state == false then print("Closed   ", dataStore.Id) end
            if state == true then print("Open     ", dataStore.Id) end
        end)

        game.Players.PlayerAdded:Connect(function(player)
            local dataStore = DataStoreModule.new("NAME", "KEY") -- edit this
            dataStore.StateChanged:Connect(StateChanged)
            if dataStore.StateChanged:Wait() == true then
                task.wait(math.random(10, 20))
                print(player.Name, "datastore is going to be destroyed")
                dataStore:Destroy()
                -- if the players datastore opens again
                -- then you are suffering from this problem
                -- once you destroy a players datastore
                -- it should never open again
            end
        end)

Documentation

CONSTRUCTOR

new(name: string, scope: string, key: string)
"Returns previously created datastore session else a new session"

new(name: string, key: string)
"Returns previously created datastore session else a new session"

hidden(name: string, scope: string, key: string)
"Returns a new session that cannot be returned by new or find"

hidden(name: string, key: string)
"Returns a new session that cannot be returned by new or find"

find(name: string, scope: string, key: string)
"Returns previously created datastore session else nil"

find(name: string, key: string)
"Returns previously created datastore session else nil"

Response Success Saved Locked State Error
"List of responses that acts like a enum"

PROPERTIES

Value  any  nil
"Value of datastore"

Metadata  table  {}
"Metadata associated with the key"

UserIds  table  {}
"An array of UserIds associated with the key"

SaveInterval  number  30
"Interval in seconds the datastore will automatically save (set to 0 to disable automatic saving)"

SaveDelay  number  0
"Delay between saves"

LockInterval  number  60
"Interval in seconds the memorystore will update the session lock"

LockAttempts  number  5
"How many times the memorystore needs to fail before the session closes"

SaveOnClose  boolean  true
"Automatically save the data when the session is closed or destroyed"

Id  string  "Name/Scope/Key"  READ ONLY
"Identifying string"

UniqueId  string  "8-4-4-4-12"  READ ONLY
"Unique identifying string"

Key  string  "Key"  READ ONLY
"Key used for the datastore"

State  boolean?  false  READ ONLY
"Current state of the session [nil = Destroyed] [false = Closed] [true = Open]"

Hidden  boolean  false/true  READ ONLY
"Set to true if this session was created by the hidden constructor"

AttemptsRemaining  number  0  READ ONLY
"How many memorystore attempts remaining before the session closes"

CreatedTime  number  0  READ ONLY
"Number of milliseconds from epoch to when the datastore was created"

UpdatedTime  number  0  READ ONLY
"Number of milliseconds from epoch to when the datastore was updated (not updated while session is open)"

Version  string  ""  READ ONLY
"Unique identifying string of the current datastore save"

CompressedValue  string  ""  READ ONLY
"Compressed string that is updated before every save if compression is enabled by setting dataStore.Metadata.Compress = {["Level"] = 2, ["Decimals"] = 3, ["Safety"] = true}
Level = 1 (allows mixed tables), Level = 2 (does not allow mixed tables but compresses arrays better), Decimals = amount of decimal places saved, Safety = replace delete character from strings"

EVENTS

StateChanged(state: boolean?, dataStore: DataStore)  Signal
"Fires when the State property has changed"

Saving(value: any, dataStore: DataStore)  Signal
"Fires just before the value is about to save"

Saved(response: string, responseData: any, dataStore: DataStore)  Signal
"Fires after a save attempt"

AttemptsChanged(attemptsRemaining: number, dataStore: DataStore)  Signal
"Fires when the AttemptsRemaining property has changed"

ProcessQueue(id: string, values: array, dataStore: DataStore)  Signal
"Fires when state = true and values detected inside the MemoryStoreQueue"

METHODS

Open(template: any)  string any
"Tries to open the session, optional template parameter will be reconciled onto the value"

Read(template: any)  string any
"Reads the datastore value without the need to open the session, optional template parameter will be reconciled onto the value"

Save()  string any
"Force save the current value to the datastore"

Close()  string any
"Closes the session"

Destroy()  string any
"Closes and destroys the session, destroyed sessions will be locked"

Queue(value: any, expiration: number?, priority: number?)  string any
"Adds a value to the MemoryStoreQueue expiration default (604800 seconds / 7 days), max (3888000 seconds / 45 days)"

Remove(id: string)  string any
"Remove values from the MemoryStoreQueue"

Clone()  any
"Clones the value property"

Reconcile(template: any) nil
"Fills in missing values from the template into the value property"

Usage()  number number
"How much datastore has been used, returns the character count and the second number is a number scaled from 0 to 1 [0 = 0% , 0.5 = 50%, 1 = 100%, 1.5 = 150%]"

Examples

SIMPLE EXAMPLE

-- Require the ModuleScript
local DataStoreModule = require(11671168253)

-- Find or create a datastore object
local dataStore = DataStoreModule.new("Name", "Key")

-- Connect a function to the StateChanged event and print to the output when the state changes
dataStore.StateChanged:Connect(function(state)
    if state == nil then print("Destroyed", dataStore.Id) end
    if state == false then print("Closed   ", dataStore.Id) end
    if state == true then print("Open     ", dataStore.Id) end
end)

-- Open the datastore session
local response, responseData = dataStore:Open()

-- If the session fails to open lets print why and return
if response ~= "Success" then print(dataStore.Id, response, responseData) return end

-- Set the datastore value
dataStore.Value = "Hello World!"

-- Save, close and destroy the session
dataStore:Destroy()

PLAYER DATA EXAMPLE

local DataStoreModule = require(11671168253)

local template = {
    Level = 0,
    Coins = 0,
    Inventory = {},
    DeveloperProducts = {},
}

local function StateChanged(state, dataStore)
    while dataStore.State == false do -- Keep trying to re-open if the state is closed
        if dataStore:Open(template) ~= "Success" then task.wait(6) end
    end
end

game.Players.PlayerAdded:Connect(function(player)
    local dataStore = DataStoreModule.new("Player", player.UserId)
    dataStore.StateChanged:Connect(StateChanged)
    StateChanged(dataStore.State, dataStore)
end)

game.Players.PlayerRemoving:Connect(function(player)
    local dataStore = DataStoreModule.find("Player", player.UserId)
    if dataStore ~= nil then dataStore:Destroy() end -- If the player leaves datastore object is destroyed allowing the retry loop to stop
end)

SET DATA EXAMPLE

local dataStore = DataStoreModule.find("Player", player.UserId)
if dataStore == nil then return end
if dataStore.State ~= true then return end -- make sure the session is open or the value will never get saved
dataStore.Value.Level += 1

DEVELOPER PRODUCTS EXAMPLE

local MarketplaceService = game:GetService("MarketplaceService")
local DataStoreModule = require(11671168253)

MarketplaceService.ProcessReceipt = function(receiptInfo)
    local dataStore = DataStoreModule.new("Player", receiptInfo.PlayerId)
    if dataStore:Open(template) ~= "Success" then return Enum.ProductPurchaseDecision.NotProcessedYet end

    -- convert the ProductId to a string as we are not allowed empty slots for numeric indexes
    local productId = tostring(receiptInfo.ProductId)

    -- Add 1 to to the productId in the DeveloperProducts table
    dataStore.Value.DeveloperProducts[productId] = (dataStore.Value.DeveloperProducts[productId] or 0) + 1

    if dataStore:Save() == "Saved" then
        -- there was no errors lets grant the purchase
        return Enum.ProductPurchaseDecision.PurchaseGranted
    else
        -- the save failed lets make sure to remove the product or it might get saved in the next save interval
        dataStore.Value.DeveloperProducts[productId] -= 1
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end
end

QUEUE EXAMPLE

-- Server A
local dataStore = DataStoreModule.new("Name", "Key")

if dataStore:Queue("Some random data")  ~= "Success" then print("Failed to queue") end
if dataStore:Queue({1, 6, 3, 8})  ~= "Success" then print("Failed to queue") end

dataStore:Destroy()

-- Server B
local dataStore = DataStoreModule.new("Name", "Key")

dataStore.ProcessQueue:Connect(function(id, values, dataStore)
    if dataStore:Remove(id) ~= "Success" then return end
    for index, value in values do print(value) end
end)

dataStore:Open() -- must be open to ProcessQueue

CUSTOM FUNCTIONS

local DataStoreModule = require(11671168253)

local function Set(dataStore, key, value)
    if dataStore.State ~= true then return false end 
    dataStore.Value[key] = value
    return true
end

local function Increment(dataStore, key, delta)
    if dataStore.State ~= true then return false end 
    dataStore.Value[key] += delta
    return true
end

game.Players.PlayerAdded:Connect(function(player)
    local dataStore = DataStoreModule.new("Player", player.UserId)
    dataStore.Set = Set
    dataStore.Increment = Increment
end)

local dataStore = DataStoreModule.find("Player", player.UserId)
if dataStore == nil then error("DataStore not found") end
local success = dataStore:Set("Key", 100)
local success = dataStore:Increment("Key", 2)

ORDERED DATASTORE EXAMPLE

local DataStoreModule = require(11671168253)
local orderedDataStore = game:GetService("DataStoreService"):GetOrderedDataStore("Coins")

local function Saving(value, dataStore)
    orderedDataStore:SetAsync(dataStore.Key, value.Coins)
end

game.Players.ChildAdded:Connect(function(player)
    local dataStore = DataStoreModule.new("Player", player.UserId)
    dataStore.Saving:Connect(Saving)
end)