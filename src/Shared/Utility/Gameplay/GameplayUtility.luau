local Workspace = game:GetService("Workspace")

local GameplayUtility = {}

--- Returns a list of spawn point CFrames from the given map, or the current map in Workspace.
-- @param map An optional map instance to get spawns from. If nil, it will search for a "Map" in Workspace.
-- @return An array of CFrames.
function GameplayUtility.getSpawnPoints(map: Instance?): { CFrame }
	local mapToSearch = map
	if not mapToSearch then
		mapToSearch = workspace:FindFirstChild("Map")
	end

	if not mapToSearch then
		warn("Could not find map.")
		return {}
	end

	local spawns = mapToSearch:FindFirstChild("Spawns")
	if not spawns then
		warn("Could not find spawns in map:", mapToSearch.Name)
		return {}
	end

	local spawnInstances = spawns:GetChildren()
	if #spawnInstances == 0 then
		warn("No spawn points found in map:", mapToSearch.Name)
		return {}
	end

	local spawnCFrames = {}
	for _, spawnPoint in ipairs(spawnInstances) do
		table.insert(spawnCFrames, spawnPoint.CFrame)
	end

	return spawnCFrames
end

return GameplayUtility
