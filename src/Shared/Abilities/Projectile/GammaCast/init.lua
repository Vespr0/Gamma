--!strict

local GammaCast = {}

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Settings = require(script.Settings)
local Simulation = require(script.Simulation)
local EntityUtility = require(ReplicatedStorage.Utility.Entity)

local IS_SERVER = RunService:IsServer()

local RemoteEvent: RemoteEvent = ReplicatedStorage.Remotes.Projectile

GammaCast.Settings = Settings
GammaCast.RemoteEvent = RemoteEvent

function GammaCast.CastClient(
	authorEntityID: number,
	typeName: string,
	origin: Vector3,
	direction: Vector3,
	modifiers: { [string]: any }?
)
	if IS_SERVER then
		return
	end

	-- Client-side predictive simulation (doesn't need client timestamp itself)
	local simulation = Simulation.new(authorEntityID, typeName, origin, direction, nil, modifiers, true) -- Pass nil for clientTimestamp

	-- Fire to server WITH the client's current time
	local clientTimestamp = workspace:GetServerTimeNow() -- Capture client time
	RemoteEvent:FireServer(typeName, origin, direction, clientTimestamp, modifiers) -- Add clientTimestamp

	local simulationResult = simulation:start() :: Simulation.SimulationResult?

	return simulationResult
end

-- Expects player and clientTimestamp from the RemoteEvent handler
function GammaCast.CastServer(
	authorEntityID: number,
	typeName: string,
	origin: Vector3,
	direction: Vector3,
	clientTimestamp: number,
	modifiers: { [string]: any }?
)
	if not IS_SERVER then
		return
	end

	-- Pass clientTimestamp to Simulation.new
	local simulation = Simulation.new(authorEntityID, typeName, origin, direction, clientTimestamp, modifiers, true)
	local simulationResult = simulation:start() :: Simulation.SimulationResult?

	return simulationResult
end

return GammaCast
