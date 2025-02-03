--!strict
local Middleware = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerUtility = require(ReplicatedStorage.Utility.Player)

local MovementActions = {
    "Crouching",
    "Sprinting"
}

function Middleware.Init(util)
    if util.isServer then
        -- Read Server
        local ReadServer = util.remote.OnServerEvent
		Middleware.ReadMovementAction = util.signal.new()

		ReadServer:Connect(function(player, action, mode)
			if not table.find(MovementActions,action) then return end
            if typeof(mode) ~= "boolean" then return end

            local character = player.Character
            character:SetAttribute("Synced"..action,mode)
        end)
    else
        -- Send Client
		Middleware.SendMovementAction = util.signal.new()

		Middleware.SendMovementAction:Connect(function(action,mode)
			if not table.find(MovementActions,action) then return end
			if typeof(mode) ~= "boolean" then return end

			util.remote:FireServer(action,mode)
        end)
    end
end

return Middleware