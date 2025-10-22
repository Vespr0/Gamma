-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Metatable
local BaseAnima = require(ReplicatedStorage.Classes.Bases.BaseAnima)
local ClientAnima = setmetatable({}, { __index = BaseAnima })
ClientAnima.__index = ClientAnima
-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local ClientEntity = require(script.Parent.Parent.Entities.ClientEntity)
local CameraController = require(script.Parent.Parent.Character.Camera.CameraController)
-- Variables
local Player = Players.LocalPlayer
ClientAnima.Singleton = nil

function ClientAnima.new()
	if ClientAnima.Singleton then
		error("ClientAnima: Singleton already exists.")
	end
	local self = setmetatable(BaseAnima.new(Player), ClientAnima)

	self:setup()

	return self
end

function ClientAnima:get()
	if not ClientAnima.Singleton then
		ClientAnima.Singleton = ClientAnima.new()
	end
	return ClientAnima.Singleton
end

function ClientAnima:setupEntity(entity)
	warn(`Loading entity for local player`)

	self.entity = entity
	self.events.EntityAdded:Fire(self.entity)
end

function ClientAnima:setup()
	self.camera = CameraController.new(self)

	if ClientEntity.LocalPlayerInstance then
		self:setupEntity(ClientEntity.LocalPlayerInstance)
	else
		ClientEntity.GlobalAdded:Connect(function(entity)
			if entity.isLocalPlayerInstance then
				self:setupEntity(entity)
			end
		end)
	end
end

function ClientAnima:destroy()
	-- Fire event and clear the singleton
	self:destroyBase()
	ClientAnima.Singleton = nil
end

function ClientAnima.Init()
	ClientAnima:get()
end

return ClientAnima
