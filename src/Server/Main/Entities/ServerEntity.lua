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
-- Variables
ServerEntity.Instances = {}
ServerEntity.GlobalAdded = Signal.new()
ServerEntity.Counter = 0

function ServerEntity.new(rig)
	if not EntityUtility.IsHealthy(rig) then warn(`Rig "{rig.Name}" is not alive, cannot create server entity instance`) return end

	ServerEntity.Counter += 1
	local id = ServerEntity.Counter
	local self = setmetatable(BaseEntity.new(rig,id), ServerEntity)

	self:setup()

	return self
end

function ServerEntity:setup()
	self.Archivable = true
	self.rig:SetAttribute("ID",self.id)
	self.rig.Parent = Game.Folders.Entities
	
	CollectionService:AddTag(self.rig,Game.Tags.Entity)	
	
	ServerEntity.Instances[self.id] = self
	ServerEntity.GlobalAdded:Fire(self)
	
	self.events.Died:Connect(function()
		self:destroy()
	end)
end

function ServerEntity.Get(id: number|string)
	return ServerEntity.Instances[tostring(id)]
end

function ServerEntity:destroy()
	self:destroyBase()
end

function ServerEntity.Init() 

end

return ServerEntity
