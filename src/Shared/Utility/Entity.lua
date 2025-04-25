local Entity = {}

-- TODO: Typechecking

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Game = require(ReplicatedStorage.Utility.Game)

-- TODO: The function names here are pretty confusing, it gets the "Entity" which is actually a rig.

-- Healthy means with a humanoid and health above 0
function Entity.IsHealthy(rig)
	if not rig:FindFirstChild("Humanoid") then return false end
	if rig.Humanoid.Health <= 0 then return false end

	return true
end

-- Alive means not destroyed and healthy
function Entity.IsAlive(rig)
	if not rig or not rig.Parent then return false end
	if not Entity.IsHealthy(rig) then return false end
	
	return true
end

function Entity.GetEntityFromEntityID(entityID: number)
	for _,entity in Game.Folders.Entities:GetChildren() do
		if entity:GetAttribute("ID") == entityID then
			return entity
		end
	end

	return nil
end

function Entity.GetPlayerFromEntityID(entityID: number)
	for _,player in game:GetService("Players"):GetPlayers() do
		if tonumber(player:GetAttribute("EntityID")) == entityID then
			return player
		end
	end

	return nil
end

function Entity.GetEntityIDFromPlayer(player)
	local character = player.Character

	if character then
		return character:GetAttribute("ID")
	end

	return nil
end

return Entity
