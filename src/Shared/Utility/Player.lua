--!strict
local Player = {}

local EntityUtility = require(script.Parent.Entity)

function Player.IsValidPlayerValue(value: any)
	return typeof(value) == "Instance" and value.ClassName == "Player"
end

function Player.IsAlive(player: Player)
	if not player then return end
	
	return EntityUtility.IsAlive(player.Character)
end

return Player
