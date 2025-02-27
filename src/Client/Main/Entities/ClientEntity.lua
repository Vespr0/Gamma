-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService") 
-- Metatable
local BaseEntity = require(ReplicatedStorage.Classes.Bases.BaseEntity)
local ClientEntity = setmetatable({}, {__index = BaseEntity})
ClientEntity.__index = ClientEntity
-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local Game = require(ReplicatedStorage.Utility.Game)
local Animator = require(script.Parent.Animator)
local TypeRig = require(ReplicatedStorage.Types.TypeRig)
local Motor6DManager = require(script.Parent.Motor6DManager)
local EntityUtility = require(ReplicatedStorage.Utility.Entity)
local ClientBackpack = require(script.Parent.Parent.Player.ClientBackpack)
-- Variables
local LocalPlayer = Players.LocalPlayer
ClientEntity.Instances = {}
ClientEntity.GlobalAdded = Signal.new()
ClientEntity.LocalPlayerInstance = nil

function ClientEntity.Get(id: number|string)
	return ClientEntity.Instances[tostring(id)]
end

function ClientEntity.new(rig: TypeRig.Rig)
	if not EntityUtility.IsHealthy(rig) then warn(`Rig "{rig.Name}" is not alive, cannot create client entity instance`) return end

	local id = rig:GetAttribute("ID") :: number
	local self = setmetatable(BaseEntity.new(rig,id), ClientEntity)

	-- Store the instance
	ClientEntity.Instances[id] = self
	ClientEntity.GlobalAdded:Fire(self)
	-- Store the instance linked to the current player character
	self.isLocalPlayer = rig == LocalPlayer.Character
	if self.isLocalPlayer then ClientEntity.LocalPlayerInstance = self end
	
	self:setup()

	-- print(`Created client entity instance for rig "{rig.Name}"`)
	
	return self
end

function ClientEntity:setup()
	self:setupAnimations()

	self.Motor6DManager = Motor6DManager.new(self.rig)

	self:setupBackpack()

	self.events.Died:Connect(function()
		self.Motor6DManager:destroy()
		self:destroy()
	end)
end

function ClientEntity:setupAnimations()
	-- Destroy the roblox default animate script if present
	local animateScript = self.rig:FindFirstChild("Animate")
	if animateScript then
		animateScript:Destroy()
	end
	-- Link an animator instance
	self.animator = Animator.new(self.rig,self.isLocalPlayer)
end

function ClientEntity:setupBackpack()
	ClientBackpack.new(self)
end

function ClientEntity:destroy()
	self:destroyBase()
	table.clear(self)
end

function ClientEntity.Init() 
	for _,rig in CollectionService:GetTagged(Game.Tags.Entity) do
		ClientEntity.new(rig)
	end
	CollectionService:GetInstanceAddedSignal(Game.Tags.Entity):Connect(function(rig)
		ClientEntity.new(rig)
	end)
end

return ClientEntity