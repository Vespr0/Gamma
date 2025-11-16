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
local BridgeNet2 = require(ReplicatedStorage.Packages.BridgeNet2)

-- Variables
ServerEntity.Instances = {}
ServerEntity.GlobalAdded = Signal.new()
ServerEntity.Counter = 0

local UpdateEntityResourceBridge = BridgeNet2.ServerBridge("UpdateEntityResource")

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
	self.resources = {}

	assert(Game.Teams[team], `Team "{team}" is not valid`)
	self.team = team

	self:setup()

	return self
end

-- New methods for resource management
function ServerEntity:AddResource(
	resourceName: string,
	resourceType: string,
	resourceAmount: number,
	resourceMaxAmount: number
)
	self.resources[resourceName] = {
		resourceType = resourceType,
		resourceAmount = resourceAmount,
		resourceMaxAmount = resourceMaxAmount,
	}
	if self.player then
		UpdateEntityResourceBridge:Fire(self.player, {
			entityId = self.id,
			resourceName = resourceName,
			resourceData = self.resources[resourceName],
		})
	end
end

function ServerEntity:GetResource(resourceName: string)
	return self.resources[resourceName]
end

function ServerEntity:SetResourceAmount(resourceName: string, amount: number)
	if self.resources[resourceName] then
		self.resources[resourceName].resourceAmount = amount
		if self.player then
			UpdateEntityResourceBridge:Fire(self.player, {
				entityId = self.id,
				resourceName = resourceName,
				resourceData = self.resources[resourceName],
			})
		end
	end
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

function ServerEntity:setupHumanoid()
	self.humanoid.BreakJointsOnDeath = false
	-- Humanoid should use jump height
	self.humanoid.UseJumpPower = false
	self.humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
end

function ServerEntity:setupBackpack()
	self.backpack = ServerBackpack.new(self)
end

function ServerEntity:destroy()
	self:destroyBase()
end

return ServerEntity
