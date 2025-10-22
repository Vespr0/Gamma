--!strict

-- Server-side simulation for GammaCast

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Game = require(ReplicatedStorage.Utility.Game)
local Draw = require(ReplicatedStorage.Utility.Draw)
local ProjectileTypes = require(script.Parent.ProjectileTypes)
local TypeRig = require(ReplicatedStorage.Types.TypeRig)
local EntityUtility = require(ReplicatedStorage.Utility.Entity)
local Snapshots = require(ReplicatedStorage.Utility.LagCompensation.Snapshots)
local Settings = require(script.Parent.Settings)

-- Import the custom hit result type
type EntityHitResult = Snapshots.EntityHitResult

export type SimulationResult = {
	Position: Vector3,
	Rig: Model?,
	Normal: Vector3?,
	Distance: number?,
}

export type Simulation = {
	-- Configuration
	authorEntityID: number,
	typeName: string,
	origin: Vector3,
	direction: Vector3,
	visualize: boolean?,

	-- Ballistics parameters
	gravity: number,
	range: number,
	speed: number,
	bulletLength: number,
	timeStep: number,
	hitscan: boolean,

	-- Runtime state
	velocity: Vector3,
	traveled: number,
	position: Vector3,
	path: { Vector3 },
	time: number,
	timestamp: number,

	-- Utility objects
	authorRig: Model,
	authorPing: number,
	raycastParams: RaycastParams,

	-- Methods
	Step: (self: Simulation) -> SimulationResult?,
}

local Simulation = {} :: any
Simulation.__index = Simulation

local IS_SERVER = RunService:IsServer() -- Unused currently, but kept for future logic

local DEBUG_COLORS = {
	Client = Color3.new(0.000000, 0.635294, 1.000000),
	Server = Color3.new(0.368627, 1.000000, 0.000000),
	Compensated = Color3.new(0.717647, 0.007843, 1.000000),
}

-- Constructor --------------------------------------------------------------
--
function Simulation.new(
	authorEntityID: number,
	typeName: string,
	origin: Vector3,
	direction: Vector3,
	clientTimestamp: number?,
	modifiers: { [string]: any }?,
	debug: boolean?
)
	assert(authorEntityID, "Missing authorEntityID")
	assert(typeName, "Missing typeName")
	assert(origin, "Missing origin")
	assert(direction, "Missing direction")

	local self = setmetatable({}, Simulation)

	self.authorEntityID = authorEntityID
	self.typeName = typeName
	self.origin = origin
	self.direction = direction
	self.debug = debug
	self.clientTimestamp = clientTimestamp -- Store the client timestamp if provided

	-- Lookup author rig so that we can ignore it in raycasts
	local authorRig = EntityUtility.GetEntityFromEntityID(authorEntityID) :: TypeRig.Rig
	self.authorRig = authorRig

	-- Store author's ping at fire time (server only)
	self.authorPing = 0 -- Default to 0 for client or if player not found
	if IS_SERVER and self.clientTimestamp ~= nil then
		local authorPlayer = EntityUtility.GetPlayerFromEntityID(authorEntityID)
		if authorPlayer then
			self.authorPing = workspace:GetServerTimeNow() - self.clientTimestamp
		else
			-- Handle case where author might be an NPC (entity ID might not map to player ID)
			-- For NPCs, ping is 0, so lag comp uses current server state for them.
			warn(
				"GammaCast Simulation.new: Could not find player for authorEntityID",
				authorEntityID,
				". Assuming NPC or disconnected player, ping set to 0."
			)
		end
	end
	-- If clientTimestamp is nil, authorPing stays 0 and lag comp is ignored

	-- Bullet definition
	local def = ProjectileTypes[typeName] or ProjectileTypes.Default
	self.hitscan = def.hitscan
	self.range = def.range

	-- Non-hitscan bullet parameters
	if not self.hitscan then
		self.gravity = def.gravity or 0
		self.speed = def.speed
		self.bulletLength = def.length or 10
		self.timeStep = def.timeStep or 1 / 60
	end

	-- State variables
	if not self.hitscan then
		self.velocity = direction.Unit * self.speed
		self.traveled = 0
	end
	self.position = origin
	self.path = { origin }
	self.time = 0
	self.timestamp = workspace:GetServerTimeNow()

	-- Raycast params (ignore projectiles, debug objects, and author rig)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { Game.Folders.Projectiles, Game.Folders.Debug, authorRig }
	self.raycastParams = raycastParams

	return self
end

function Simulation:step(dt: number): SimulationResult?
	-- advance sim time
	-- self.time = self.time + self.timeStep -- Time accumulation might not be needed if only using timestamp
	-- local _currentTime = self.timestamp + self.time -- Removed unused variable

	-- Ended because max range reached
	if (self.traveled :: number) >= (self.range :: number) then
		return nil
	end

	-- Kinematic integration
	local nextVelocity = self.velocity + Vector3.new(0, -self.gravity * self.timeStep, 0)
	local stepVec = nextVelocity * self.timeStep
	local nextPosition = self.position + stepVec

	-- Build two rays: compDir for lag-comp (full bullet length), stepVec for movement
	local compDir = self.direction.Unit * self.bulletLength
	local moveDir = stepVec

	if self.debug then
		-- Draw the ray using the actual movement vector (stepVec) to ensure perfect connection
		Draw.ray(self.position, stepVec, IS_SERVER and DEBUG_COLORS.Server or DEBUG_COLORS.Client, nil, 0.05)
	end

	-- Lag compensation: check entities via snapshots
	-- Lag compensation: check entities via snapshots only if clientTimestamp is provided
	local lagCompTime: number? = nil
	if IS_SERVER and self.clientTimestamp ~= nil then
		-- Calculate lag compensation
		lagCompTime = self.clientTimestamp - (self.authorPing + Settings.INTERPOLATION_OFFSET)
	end

	if IS_SERVER and lagCompTime ~= nil then
		-- Lag-check ray against entities along full bullet length
		local entityHit = Snapshots.RaycastEntities(self.authorRig, self.position, compDir, lagCompTime)
		if entityHit then
			Draw.point(entityHit.Position, DEBUG_COLORS.Compensated, nil, 0.5)
			return { Rig = entityHit.Rig, Position = entityHit.Position }
		end
	end
	-- If clientTimestamp is nil, lag compensation is skipped and normal raycast proceeds

	-- Perform workspace raycast for environment collision (movement step)
	local hit = workspace:Raycast(self.position, moveDir, self.raycastParams)
	self.position = nextPosition

	if hit then
		table.insert(self.path, hit.Position)
	else
		table.insert(self.path, self.position)
	end

	-- Update state
	self.traveled = (self.traveled :: number) + stepVec.Magnitude
	self.velocity = nextVelocity

	if hit then
		if self.debug then
			Draw.point(hit.Position, IS_SERVER and DEBUG_COLORS.Server or DEBUG_COLORS.Client)
		end
		return { Position = hit.Position, Rig = hit.Instance, Normal = hit.Normal }
	end

	return nil
end

function Simulation:start(): SimulationResult?
	-- main sim loop
	if self.hitscan then
		-- Hitscan behavior: single instantaneous ray with lag compensation (if clientTimestamp is provided)
		local lagCompTime: number? = nil
		if IS_SERVER and self.clientTimestamp ~= nil then
			lagCompTime = self.clientTimestamp - (self.authorPing + Settings.INTERPOLATION_OFFSET)
		end
		if IS_SERVER and lagCompTime ~= nil then
			local entityHit =
				Snapshots.RaycastEntities(self.authorRig, self.origin, self.direction.Unit * self.range, lagCompTime)
			if entityHit then
				if self.debug then
					Draw.point(
						entityHit.Position,
						IS_SERVER and DEBUG_COLORS.Compensated or DEBUG_COLORS.Client,
						nil,
						1
					)
				end
				return { Rig = entityHit.Rig, Position = entityHit.Position }
			end
		end
		-- If clientTimestamp is nil, skip lag comp and just raycast environment
		local rayDir = self.direction.Unit * self.range
		if self.debug then
			Draw.ray(self.origin, rayDir, IS_SERVER and DEBUG_COLORS.Server or DEBUG_COLORS.Client)
		end
		local envHit = workspace:Raycast(self.origin, rayDir, self.raycastParams)
		if envHit then
			if self.debug then
				Draw.point(envHit.Position, IS_SERVER and DEBUG_COLORS.Server or DEBUG_COLORS.Client)
			end
			-- Check if the hit instance is part of an entity rig
			local candidate = envHit.Instance
			local rig = nil
			-- TODO: potentially dangerous while loop
			while candidate do
				if candidate.Parent == Game.Folders.Entities then
					rig = candidate
					break
				end
				candidate = candidate.Parent
			end
			if rig then
				return { Rig = rig, Position = envHit.Position, Normal = envHit.Normal, Distance = envHit.Distance }
			else
				return {
					Instance = envHit.Instance,
					Position = envHit.Position,
					Normal = envHit.Normal,
					Distance = envHit.Distance,
				}
			end
		else
			return nil
			-- return {Position = self.origin + rayDir}
		end
	end
	self.startTime = os.clock()
	while true do
		local startTime = os.clock()
		local result: SimulationResult? = self:step() -- Assign the result directly
		if result then -- Check if step returned any hit (EntityHitResult or RaycastResult)
			return { Position = result.Position, Rig = result.Rig, Normal = result.Normal, Distance = result.Distance }
		end
		local endTime = os.clock()
		self.elapsedTime = endTime - startTime
		local sleepTime = math.max(0, self.timeStep - self.elapsedTime)
		task.wait(sleepTime)
	end
end

return Simulation
