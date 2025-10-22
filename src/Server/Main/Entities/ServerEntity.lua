-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
-- Metatable
local BaseEntity = require(ReplicatedStorage.Classes.Bases.BaseEntity)
local ServerEntity = setmetatable({}, { __index = BaseEntity })
ServerEntity.__index = ServerEntity
-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local Game = require(ReplicatedStorage.Utility.Game)
local EntityUtility = require(ReplicatedStorage.Utility.Entity)
local ServerBackpack = require(script.Parent.ServerBackpack)
local Ragdoll = require(ReplicatedStorage.Utility.Ragdoll)

-- Variables
ServerEntity.Instances = {}
ServerEntity.GlobalAdded = Signal.new()
ServerEntity.Counter = 0

function ServerEntity.new(rig, player: Player | nil, team: string)
	team = team or "Neutral"
	if not EntityUtility.IsHealthy(rig) then
		warn(`Rig "{rig.Name}" is not healthy, cannot create server entity instance`)
		return
	end

	ServerEntity.Counter += 1
	local id = ServerEntity.Counter
	local self = setmetatable(BaseEntity.new(rig, id), ServerEntity)

	-- Player entity id attribute
	if player then
		player:SetAttribute("EntityID", id)
	end

	self.player = player

	assert(Game.Teams[team], `Team "{team}" is not valid`)
	self.team = team

	self:setup()

	return self
end

function ServerEntity:setup()
	self.Archivable = true
	self.rig:SetAttribute("ID", self.id)
	self.rig.Parent = Game.Folders.Entities
	self.rig:SetAttribute("Team", self.team)

	self:setupHumanoid()
	-- self:setupPhysicsController()
	self:setupBackpack()

	-- Setup ragdoll system
	self.ragdoll = Ragdoll.new(self)

	self.events.Died:Connect(function()
		if self.ragdoll then
			self.ragdoll:EnableRagdoll()
			self.ragdoll:applySpin()
		end
		self:destroy()
	end)

	ServerEntity.Instances[tostring(self.id)] = self
	CollectionService:AddTag(self.rig, Game.Tags.Entity)
	ServerEntity.GlobalAdded:Fire(self)
end

function ServerEntity.Get(id: number | string)
	return ServerEntity.Instances[tostring(id)]
end

-- function ServerEntity:setupPhysicsController()
-- 	self.humanoid.EvaluateStateMachine = false -- Disable Humanoid state machine and physics

-- 	local cm = Instance.new("ControllerManager")
-- 	local gc = Instance.new("GroundController", cm)
-- 	Instance.new("AirController", cm)
-- 	Instance.new("ClimbController", cm)
-- 	Instance.new("SwimController", cm)

-- 	cm.RootPart = self.root
-- 	gc.GroundOffset = self.humanoid.HipHeight
-- 	cm.FacingDirection = cm.RootPart.CFrame.LookVector

-- 	local floorSensor = Instance.new("ControllerPartSensor")
-- 	floorSensor.SensorMode = Enum.SensorMode.Floor
-- 	floorSensor.SearchDistance = self.humanoid.HipHeight + 2.0 -- Increased buffer for ground detection
-- 	floorSensor.Name = "GroundSensor"

-- 	local ladderSensor = Instance.new("ControllerPartSensor")
-- 	ladderSensor.SensorMode = Enum.SensorMode.Ladder
-- 	ladderSensor.SearchDistance = 1.5
-- 	ladderSensor.Name = "ClimbSensor"

-- 	local waterSensor = Instance.new("BuoyancySensor")

-- 	cm.GroundSensor = floorSensor
-- 	cm.ClimbSensor = ladderSensor

-- 	waterSensor.Parent = cm.RootPart
-- 	floorSensor.Parent = cm.RootPart
-- 	ladderSensor.Parent = cm.RootPart

-- 	cm.Parent = self.rig
-- end

function ServerEntity:setupHumanoid()
	self.humanoid.BreakJointsOnDeath = false
	-- Humanoid should use jump height
	self.humanoid.UseJumpPower = false
end

function ServerEntity:setupBackpack()
	self.backpack = ServerBackpack.new(self)
end

function ServerEntity:destroy()
	self:destroyBase()
end

return ServerEntity
