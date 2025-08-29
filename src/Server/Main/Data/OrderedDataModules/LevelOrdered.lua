local TokensOrdered = {}

-- Services --
local Players = game:GetService("Players")

-- Modules --
local PlayerOrderedDataManager = require(script.Parent.Parent.PlayerOrderedDataManager)

-- Constants --
TokensOrdered.DatastoreName = "Tokens"

-- Functions --

function TokensOrdered.UpdatePlayerTokens(...)
	local player, level = PlayerOrderedDataManager.GetParameters(...)
	if not (player and level) then
		return
	end

	PlayerOrderedDataManager.UpdatePlayerData(TokensOrdered.DatastoreName, player, level)
end

function TokensOrdered.Init()
	-- Initialize any setup logic if needed
	TokensOrdered.UpdatePlayerTokens(Players:GetPlayers()[1],8)
end

return TokensOrdered
