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

			Middleware.ReadAbility:Fire(entityID, abilityName, toolIndex,...)
        end)

		-- Send Server 
		Middleware.SendAbility = util.signal.new()

		-- Replicate ability to other clients: Needs entity id to distinguish between entities
		Middleware.SendAbility:Connect(function(player, entityID, abilityName, toolIndex,...)
			checkAbilityNameAndToolIndex(abilityName, toolIndex)
			checkEntityID(entityID)

			util.remote:FireClient(player, entityID, abilityName, toolIndex,...)
		end)
    else
        -- Send Client
		Middleware.SendAbility = util.signal.new()

		Middleware.SendAbility:Connect(function(abilityName: string, toolIndex: number,...)
			checkAbilityNameAndToolIndex(abilityName, toolIndex)

			util.remote:FireServer(abilityName,toolIndex,...)
        end)

		-- Read Client
		local ReadClient = util.remote.OnClientEvent
		Middleware.ReadAbility = util.signal.new()

		-- Replicate ability to other clients
		ReadClient:Connect(function(entityID: number, abilityName: string, toolIndex: number,...)
			checkAbilityNameAndToolIndex(abilityName, toolIndex)
			checkEntityID(entityID)

			Middleware.ReadAbility:Fire(entityID, abilityName, toolIndex,...)
		end)
    end
end

return Middleware