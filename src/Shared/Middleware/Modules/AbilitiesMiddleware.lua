--!strict
local Middleware = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerUtility = require(ReplicatedStorage.Utility.Player)

local function checkActionParams(player,ability)
	if typeof(ability) ~= "string" then warn("Invalid request, ability must be a string.") return end
	
	local isAlive = PlayerUtility.IsAlive(player)

	-- Make sure the player's character is alive.
	if not isAlive then warn("Player's character must be alive.") return end
	
	return true
end

function Middleware.Init(util)
    if util.isServer then
        -- Read Server
        local ReadServer = util.remote.OnServerEvent
		Middleware.ReadAbilityAction = util.signal.new()

		ReadServer:Connect(function(player, ability, ...)
			if not checkActionParams(player,ability) then return end
			
			Middleware.ReadAbilityAction:Fire(player,ability, ...)
        end)
    else
        -- Send Client
		Middleware.SendAbilityAction = util.signal.new()

		Middleware.SendAbilityAction:Connect(function(ability,...)
			if not checkActionParams(Players.LocalPlayer,ability) then return end
			
			util.remote:FireServer(ability,...)
        end)
    end
end

return Middleware