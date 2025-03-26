--!strict
local Middleware = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EntityUtility = require(ReplicatedStorage.Utility.Entity)

local function checkAbilityNameAndToolIndex(abilityName, toolIndex)
	assert(typeof(abilityName) == "string", "Invalid request, ability name must be a string.")
	assert(typeof(toolIndex) == "number", "Invalid request, tool index must be a number.")
end

local function checkEntityID(entityID)
	assert(typeof(entityID) == "number", "Invalid request, entity ID must be a number.")
end

function Middleware.Init(util)
    if util.isServer then
        -- Read Server
        local ReadServer = util.remote.OnServerEvent

		Middleware.ReadAbility = util.signal.new()

		ReadServer:Connect(function(player, abilityName, toolIndex,...)
			checkAbilityNameAndToolIndex(abilityName, toolIndex)
			
			local entityID = EntityUtility.GetEntityIDFromPlayer(player)
			print(player.Character)
			Middleware.ReadAbility:Fire(entityID, abilityName, toolIndex,...)
        end)

		-- Send Server 
		Middleware.ReplicateAbility = util.signal.new()

		-- Replicate ability to other clients
		Middleware.ReplicateAbility:Connect(function(entityID: number, abilityName, toolIndex,...)
			checkAbilityNameAndToolIndex(abilityName, toolIndex)
			checkEntityID(entityID)

			util.remote:FireClient(entityID, abilityName, toolIndex,...)
		end)
    else
        -- Send Client
		Middleware.SendAbility = util.signal.new()

		Middleware.SendAbility:Connect(function(abilityName: string, toolIndex: number,...)
			checkAbilityNameAndToolIndex(abilityName, toolIndex)

			util.remote:FireServer(abilityName,toolIndex,...)
        end)
    end
end

return Middleware