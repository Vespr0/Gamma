local Middleware = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerUtility = require(ReplicatedStorage.Utility.Player)

local function validateIndex(index: number?)
    if not index then error("Index is missing") return end
    if typeof(index) ~= "number" then error("Index is not a number") return end
    if index < 1 then error("Index is less than 1") return end
    
    return true        
end

function Middleware.Init(util)
    if util.isServer then
        -- Send Server
        Middleware.SendToolAdded = util.signal.new()
        Middleware.SendToolRemoved = util.signal.new()
        Middleware.NewBackpack = util.signal.new()
        -- Read Server
        local ReadServer = util.remote.OnServerEvent
        Middleware.ReadToolEquip = util.signal.new()
        Middleware.ReadToolUnequip = util.signal.new()

        ReadServer:Connect(function(player, type: "ToolEquip" | "ToolUnequip",index: number)
            validateIndex(index)

            if type == "ToolEquip" then
                Middleware.ReadToolEquip:Fire(player,index)
            elseif type == "ToolUnequip" then
                Middleware.ReadToolUnequip:Fire(player,index)
            end 
        end)
    else
        -- Send Client
        local SendClient = util.remote.OnClientEvent
        Middleware.SendToolEquip = util.signal.new()
        Middleware.SendToolUnequip = util.signal.new()

        SendClient:Connect(function(type: "ToolEquip" | "ToolUnequip",index: number)
            validateIndex(index)

            if type == "ToolEquip" then
                util.remote:FireServer("ToolEquip",index)
            elseif type == "ToolUnequip" then
                util.remote:FireServer("ToolUnequip",index)
            end
        end)
        
        -- Read Client
        local ReadClient = util.remote.OnClientEvent
        Middleware.ReadToolAdded = util.signal.new()
        Middleware.ReadToolRemoved = util.signal.new()
        Middleware.NewBackpack = util.signal.new()

        ReadClient:Connect(function(type: "ToolAdded" | "ToolRemoved",index: number)
            --if not PlayerUtility.IsAlive(Players.LocalPlayer) then return end TODO
            
            if type == "ToolAdded" then
                Middleware.ReadToolAdded:Fire(index)
            elseif type == "ToolRemoved" then
                Middleware.ReadToolRemoved:Fire(index)
            end
        end)
        
        ReadClient:Connect(function(type: "NewBackpack",entityID: number)
            if type == "NewBackpack" then
                Middleware.NewBackpack:Fire(entityID)
            end
        end)
    end
end

return Middleware