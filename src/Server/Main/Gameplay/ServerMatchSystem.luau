local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local BridgeNet2 = require(ReplicatedStorage.Packages.BridgeNet2)
local MapLoader = require(script.Parent.MapLoader).new()
local ConfigUtility = require(ReplicatedStorage.Configs.ConfigUtility)
local GameplayUtility = require(ReplicatedStorage.Utility.Gameplay.GameplayUtility)

local ServerMatchSystem = {}

local matchStateBridge = BridgeNet2.ServerBridge("MatchState")

local function teleportPlayersToSpawns(players, map)
	local spawnPoints = GameplayUtility.getSpawnPoints(map)
	if #spawnPoints == 0 then
		error("No spawn points found in map:" .. map.Name)
		return
	end

	for i, player in players do
		local character = player.Character
		if character then
			local spawnPoint = spawnPoints[(i - 1) % #spawnPoints + 1]
			character.PrimaryPart.CFrame = spawnPoint
		end
	end
end

function ServerMatchSystem.Init()
	ServerMatchSystem.enterLobby("Classic")
end

function ServerMatchSystem.enterLobby(configName: string)
	local config = ConfigUtility.GetConfig("Modes", configName)
	if not config then
		warn("Could not find match config:", configName)
		return
	end

	local map = MapLoader:load(config.LobbyMap)
	teleportPlayersToSpawns(Players:GetPlayers(), map)

	local intermissionDuration = 10
	matchStateBridge:Fire(BridgeNet2.AllPlayers(), {
		phase = "Lobby",
		event = {
			Title = "Intermission",
			Start = os.clock() + intermissionDuration,
		},
	})

	task.wait(intermissionDuration)
	ServerMatchSystem.startMatch(configName)
end

--- Starts a match with the given configuration.
-- @param configName The name of the match configuration to use.
function ServerMatchSystem.startMatch(configName: string)
	local config = ConfigUtility.GetConfig("Modes", configName)
	if not config then
		warn("Could not find match config:", configName)
		return
	end

	-- Load the map
	local map = MapLoader:load(config.Map)
	teleportPlayersToSpawns(Players:GetPlayers(), map)

	-- Assign roles and notify clients
	local players = Players:GetPlayers()
	local playerDataForClients = {}
	for _, player in ipairs(players) do
		table.insert(playerDataForClients, {
			UserId = player.UserId,
			DisplayName = player.DisplayName,
		})
	end

	local matchDuration = config.Duration or 300 -- Default to 5 minutes
	local matchEndTime = os.clock() + matchDuration

	for i, player in ipairs(players) do
		-- Simple role assignment, alternates between the roles in the config
		local role = config.Roles[(i - 1) % #config.Roles + 1]

		matchStateBridge:Fire(player, {
			phase = "InGame",
			lightingPreset = config.Lighting,
			assignedRole = role,
			players = playerDataForClients,
			event = {
				Title = config.Name or "Classic",
				Start = matchEndTime,
			},
		})
	end
end

return ServerMatchSystem
