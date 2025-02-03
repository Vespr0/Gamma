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

	self.userId = player.UserId :: number
	self.entity = nil

	self:setup()
	
	print(`Created server anima instance for player "{player.Name}"`)

	return self
end

function ServerAnima:setupProperties()
	-- Disable shift lock for the player
	self.player.DevEnableMouseLock = false
end

function ServerAnima:setup()
	-- Fire global event when a new entity is added
	ServerAnima.GlobalAdded:Fire(self)
	-- Add instance to the table
	ServerAnima.Instances[self.userId] = self
	-- Setup player-specific properties
	self:setupProperties()
	
	-- Manually load character
	self.player:LoadCharacter()

	-- if self.character then
	-- 	ServerEntity.new(self.character)
	-- end
	-- Listen for new characters being added
	self.events.CharacterAdded:Connect(function()
		self.entity = ServerEntity.new(self.character,self.player)
	
		self.entity.events.Died:Connect(function()
			--self.player:LoadCharacter()
		end)
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
	-- Setup starter character
	local rig = AssetsDealer.Get("Rigs","Human","Clone")
	rig.Parent = game:GetService("StarterPlayer")
	rig.Name = "StarterCharacter"
	
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
