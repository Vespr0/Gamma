--!strict
local Middleware = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EntityUtility = require(ReplicatedStorage.Utility.Entity)

local function checkParams(rig,ability)
	if typeof(ability) ~= "string" then warn("Invalid request, ability must be a string.") return end
	
	local isAlive = EntityUtility.IsAlive(rig)

	-- Make sure the player's character is alive.
	if not isAlive then warn("Player's character must be alive.") return end
	
	return true
end

-- function Middleware.Init(util)
--     if util.isServer then
--         -- Read Server
--         local ReadServer = util.remote.OnServerEvent

-- 		Middleware.ReadAbility = util.signal.new()

-- 		ReadServerRemote:Connect(function(player, ability, ...)
-- 			if not checkParams(player,ability) then return end
			
-- 			Middleware.ReadAbility:Fire(player,ability, ...)
--         end)
-- 		-- Send Server 
-- 		Middleware.SendAbility = util.signal.new() -- (Used by NPCs)

-- 		Middleware.SendAbility:Connect(function(player, ability, ...)
-- 			if not checkParams(player,ability) then return end
			
-- 			util.remote:FireClient(player,ability,...)
-- 		end)

--     else
--         -- Send Client
-- 		Middleware.SendAbility = util.signal.new()

-- 		Middleware.SendAbility:Connect(function(ability,...)
-- 			if not checkActionParams(Players.LocalPlayer,ability) then return end
			
-- 			util.remote:FireServer(ability,...)
--         end)
--     end
-- end

return Middleware