--!strict
-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
-- Metatable
local BaseEntity = require(ReplicatedStorage.Classes.Bases.BaseEntity)
local ServerEntity = setmetatable({}, {__index = BaseEntity})
ServerEntity.__index = ServerEntity
-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local Game = require(ReplicatedStorage.Utility.Game)
local EntityUtility = require(ReplicatedStorage.Utility.Entity)
local ServerBackpack = require(script.Parent.Parent.Player.ServerBackpack)

-- Variables
ServerEntity.Instances = {}
ServerEntity.GlobalAdded = Signal.new()
ServerEntity.Counter = 0

function ServerEntity.new(rig,player: Player | nil)
	if not EntityUtility.IsHealthy(rig) then warn(`Rig "{rig.Name}" is not healthy, cannot create server entity instance`) return end

	ServerEntity.Counter += 1
	local id = ServerEntity.Counter
	local self = setmetatable(BaseEntity.new(rig,id), ServerEntity)

	-- Player entity id attribute
	if player then player:SetAttribute("EntityID", id) end

	self:setup()

	return self
end

function ServerEntity:setup()
	self.Archivable = true
	self.rig:SetAttribute("ID",self.id)
	self.rig.Parent = Game.Folders.Entities
	
	self:setupHumanoid()

	CollectionService:AddTag(self.rig,Game.Tags.Entity)	

	self:setupBackpack()

	self.events.Died:Connect(function()
		self:destroy()
	end)

	ServerEntity.Instances[self.id] = self
	ServerEntity.GlobalAdded:Fire(self)
end

function ServerEntity.Get(id: number|string)
	return ServerEntity.Instances[tostring(id)]
end

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
