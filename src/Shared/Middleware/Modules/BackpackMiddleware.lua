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
        Middleware.SendToolEquip = util.signal.new()
        Middleware.SendToolUnequip = util.signal.new()
        Middleware.NewBackpack = util.signal.new()

        Middleware.SendToolAdded:Connect(function(entityID: number,index: number)
            validateIndex(index)
            
            util.remote:FireAllClients(entityID,"ToolAdded",index)
        end)
        
        Middleware.SendToolRemoved:Connect(function(entityID: number,index: number)
            validateIndex(index)

            util.remote:FireAllClients(entityID,"ToolRemoved",index)
        end)
        
        Middleware.SendToolEquip:Connect(function(entityID: number,index: number, blacklistedUserId: number)
            validateIndex(index)

            for _, player in Players:GetPlayers() do
                if player.UserId == blacklistedUserId then continue end
                util.remote:FireClient(player,entityID,"ToolEquip",index)
            end
        end)
        
        Middleware.SendToolUnequip:Connect(function(entityID: number, blacklistedUserId: number)
            for _, player in Players:GetPlayers() do
                if player.UserId == blacklistedUserId then continue end
                util.remote:FireClient(player,entityID,"ToolUnequip")
            end
        end)
        
        Middleware.NewBackpack:Connect(function(entityID: number)
            util.remote:FireClient(entityID,"NewBackpack")
        end)
        
        -- Read Server
        local ReadServer = util.remote.OnServerEvent
        Middleware.ReadToolEquip = util.signal.new()
        Middleware.ReadToolUnequip = util.signal.new()

        ReadServer:Connect(function(player, type: "ToolEquip" | "ToolUnequip",index: number)
            if type == "ToolEquip" then
                validateIndex(index)
                Middleware.ReadToolEquip:Fire(player,index)
            elseif type == "ToolUnequip" then
                Middleware.ReadToolUnequip:Fire(player)
            end 
        end)
    else
        -- Send Client
        Middleware.SendToolEquip = util.signal.new()
        Middleware.SendToolUnequip = util.signal.new()

        Middleware.SendToolEquip:Connect(function(index: number)
            validateIndex(index)

            util.remote:FireServer("ToolEquip",index)
        end)

        Middleware.SendToolUnequip:Connect(function()
            util.remote:FireServer("ToolUnequip")
        end)

        -- Read Client
        local ReadClient = util.remote.OnClientEvent
        Middleware.ReadToolAdded = util.signal.new()
        Middleware.ReadToolRemoved = util.signal.new()
        Middleware.NewBackpack = util.signal.new()
        Middleware.ReadToolEquip = util.signal.new()
        Middleware.ReadToolUnequip = util.signal.new()

        ReadClient:Connect(function(entityID: number,type: "ToolAdded" | "ToolRemoved" | "ToolEquip" | "ToolUnequip",index: number)
            --if not PlayerUtility.IsAlive(Players.LocalPlayer) then return end -- TODO: figure out if it's necessary or not
            
            if type == "ToolAdded" then
                Middleware.ReadToolAdded:Fire(entityID, index)
            elseif type == "ToolRemoved" then
                Middleware.ReadToolRemoved:Fire(entityID, index)
            elseif type == "ToolEquip" then
                Middleware.ReadToolEquip:Fire(entityID, index)
            elseif type == "ToolUnequip" then
                Middleware.ReadToolUnequip:Fire(entityID)
            end
        end)
        
        ReadClient:Connect(function(entityID: number, type: "NewBackpack")
            if type == "NewBackpack" then
                Middleware.NewBackpack:Fire(entityID)
            end
        end)
    end
end

return Middleware