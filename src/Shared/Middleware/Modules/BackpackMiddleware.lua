local Middleware = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerUtility = require(ReplicatedStorage.Utility.Player)

function Middleware.Init(util)
    if util.isServer then
        -- Send Server
        Middleware.SendToolAdded = util.signal.new()
        Middleware.SendToolRemoved = util.signal.new()
    else
        -- Read Client
        local ReadClient = util.remote.OnClientEvent
        Middleware.ReadToolAdded = util.signal.new()
        Middleware.ReadToolRemoved = util.signal.new()
        
        ReadClient:Connect(function(type: "ToolAdded" | "ToolRemoved",index: number)
            --if not PlayerUtility.IsAlive(Players.LocalPlayer) then return end TODO
            
            if type == "ToolAdded" then
                Middleware.ReadToolAdded:Fire(index)
            elseif type == "ToolRemoved" then
                Middleware.ReadToolRemoved:Fire(index)
            end
        end)
    end
end

return Middleware