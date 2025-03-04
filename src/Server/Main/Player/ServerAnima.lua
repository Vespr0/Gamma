-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Metatable
local BaseAnima = require(ReplicatedStorage.Classes.Bases.BaseAnima)
local ServerAnima = setmetatable({}, {__index = BaseAnima})
ServerAnima.__index = ServerAnima
-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local ServerEntity = require(script.Parent.Parent.Entities.ServerEntity)
local AssetsDealer = require(ReplicatedStorage.AssetsDealer)
local Game = require(ReplicatedStorage.Utility.Game)
-- Variables
ServerAnima.Instances = {}
-- Global Events
ServerAnima.GlobalAdded = Signal.new()
ServerAnima.GlobalRemoved = Signal.new()

function ServerAnima.Get(userId: number)
	if (typeof(userId) ~= "number") then error("userId must be a number") end
	return (ServerAnima.Instances[userId] or error(`No server anima instance found with userId "{userId}"`))
end

function ServerAnima.new(player: Player)
	local self = setmetatable(BaseAnima.new(player), ServerAnima)

	-- Check if player already has a server anima instance
	if (ServerAnima.Instances[self.userId]) then error("Player already has a server anima instance") end

	self.userId = player.UserId :: number
	self.entity = nil

	self:setup()

	-- Fire global event when a new entity is added
	ServerAnima.GlobalAdded:Fire(self)
	-- Add instance to the table
	ServerAnima.Instances[self.userId] = self

	print(`Created server anima instance for player "{player.Name}"`)

	return self
end

function ServerAnima:setupProperties()
	-- Disable shift lock for the player
	self.player.DevEnableMouseLock = false
end

function ServerAnima:loadCharacter()
	local rig = AssetsDealer.Get("Rigs","Human","Clone")
	rig.Name = self.player.Name
	-- Move the rig to a temporary folder
	rig.Parent = game:GetService("ServerStorage"):WaitForChild("Temp")
	rig.Humanoid.Health = rig.Humanoid.MaxHealth -- TODO: I have to do this, i have no fucking clue why

	self.entity = ServerEntity.new(rig,self.player)
	self.events.EntityAdded:Fire(self.entity)

	warn("Applied entityID attribute to player")

	self.player.Character = rig
end

function ServerAnima:setup()
	-- Setup player-specific properties
	self:setupProperties()
	-- Setup character loading
	self:loadCharacter()
	self.events.EntityDied:Connect(function()
		print("Player died")
		task.wait(Game.RespawnTime)
		self:loadCharacter()
	end)
end

function ServerAnima:destroy()
	-- Fire global removal event
	ServerAnima.GlobalRemoved:Fire(self)
	-- Remove instance from table
	ServerAnima.Instances[self.userId] = nil
	-- Destroy base
	self:destroyBase()
end

function ServerAnima.Init()
	-- Setup existing players
	for _, player in Players:GetPlayers() do
		ServerAnima.new(player)
	end
	-- Listen for new players joining
	Players.PlayerAdded:Connect(function(player)
		ServerAnima.new(player)
	end)
	-- Listen for players leaving
	Players.PlayerRemoving:Connect(function(player)
		local instance = ServerAnima.Get(player.UserId)
		if instance then
			instance:destroy()
		end
	end)
end

return ServerAnima
