local PlayerDataReplication = {}

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- Folders --
-- local Server = ServerScriptService.Main
local Packages = ReplicatedStorage.Packages

-- Modules --
-- local DataUtility = require(ReplicatedStorage.Data.DataUtility)
-- local Trove = require(Packages.trove)
local BridgeNet2 = require(Packages.BridgeNet2)
-- local Signal = require(Packages.signal)
local DataAccess = require(script.Parent.DataAccess)

-- Bridge.
local PlayerDataUpdateBridge = BridgeNet2.ServerBridge("PlayerDataUpdate")
PlayerDataUpdateBridge.Logging = false

-- Functions --
function PlayerDataReplication.InitPlayer(player)
    -- TODO: This might be problematic, i dont know but i cant put  a timeout since client loading could be very long based on specs
    --local start = os.clock()
    --local timeout
    repeat 
        task.wait(.1) 
       -- timeout = os.clock() - start > 10
    until player:GetAttribute("ClientLoaded") --or timeout

    -- assert(not timeout, `Timeout waiting for player's client data to load`)

    -- Send Full.
    local allData = DataAccess.GetFull(player)
    -- warn(allData)
	PlayerDataUpdateBridge:Fire(player,{type="Full",arg1=allData})
end

function PlayerDataReplication.Init()
    DataAccess.PlayerDataChanged:Connect(function(player,type,...)
        PlayerDataUpdateBridge:Fire(player,{type=type,args = ...})
    end)
end

return PlayerDataReplication