-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Metatable
local BaseAnima = require(ReplicatedStorage.Classes.Bases.BaseAnima)
local ClientAnima = setmetatable({}, {__index = BaseAnima})
ClientAnima.__index = ClientAnima
-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local ClientEntity = require(script.Parent.Parent.Entities.ClientEntity)
local Camera = require(script.Parent.Parent.Character.Camera.CameraController)
-- Variables
local Player = Players.LocalPlayer
local singleton = nil

function ClientAnima.new()
	if singleton then error("ClientAnima: Singleton already exists.") end
	local self = setmetatable(BaseAnima.new(Player), ClientAnima)

	self:setup()

	singleton = self
	return self
end

function ClientAnima:get()
	if not singleton then
		singleton = ClientAnima.new()
	end
	return singleton
end

function ClientAnima:setupEntity(entity)
	self.entity = entity
	self.events.EntityAdded:Fire(self.entity)
end

function ClientAnima:setup()
	self.camera = Camera.new(self)
	
	if self.character then
		self:setupEntity(ClientEntity.LocalPlayerInstance)
	end
	ClientEntity.GlobalAdded:Connect(function(entity)
		if entity.isLocalPlayer then
			self:setupEntity(entity)
		end
	end)
end

function ClientAnima:destroy()
	-- Fire event and clear the singleton
	self:destroyBase()
	singleton = nil
end

function ClientAnima.Init() ClientAnima:get() end

return ClientAnima
