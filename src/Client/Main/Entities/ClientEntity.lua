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
local ClientBackpack = require(script.Parent.Parent.Entities.ClientBackpack)
local ClientMovement = require(script.Parent.Parent.Entities.ClientMovement)
local ClientAppearance = require(script.Parent.ClientAppearance)
local ClientLookAt = require(script.Parent.ClientLookAt)

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

	-- Store the instance linked to the current player character
	self.isLocalPlayerInstance = LocalPlayer.Character == rig :: boolean
	if self.isLocalPlayerInstance then ClientEntity.LocalPlayerInstance = self end
	
	self:setup()

	-- Store the instance
	ClientEntity.Instances[id] = self
	ClientEntity.GlobalAdded:Fire(self)

	print(`Created client entity instance for rig "{rig.Name}"`)
	
	return self
end

function ClientEntity:setup()
	-- Initialize components in correct order, changing the order will result in errors
	self:setupAnimations()
	self:setupMovement()
	self:setupBackpack()
	self:setupAppearance()

	self.Motor6DManager = Motor6DManager.new(self.rig)

	self.events.Died:Connect(function()
		self:destroy()
	end)
end

function ClientEntity:setupMovement()
	self.movement = ClientMovement.new(self,self.isLocalPlayerInstance)
	-- no longer overriding default movement; just enhanced air control via ClientJumping
end

function ClientEntity:setupAnimations()
	-- Destroy the roblox default animate script if present
	local animateScript = self.rig:FindFirstChild("Animate")
	if animateScript then
		animateScript:Destroy()
	end
	-- Link an animator instance
	self.animator = Animator.new(self.rig,self.isLocalPlayerInstance)
end

function ClientEntity:setupBackpack()
	self.backpack = ClientBackpack.new(self,self.isLocalPlayerInstance)
	print(self.backpack,self.isLocalPlayerInstance)
end

function ClientEntity:setupAppearance()
	self.appearance = ClientAppearance.new(self)
end

function ClientEntity:destroy()
	self.Motor6DManager:destroy()
	if self.Recoil then
		self.Recoil:destroy()
	end

	ClientEntity.Instances[tostring(self.id)] = nil
	if self.isLocalPlayerInstance then ClientEntity.LocalPlayerInstance = nil end

	self:destroyBase()
end

function ClientEntity.Init()
	warn("w")
	for _,rig in CollectionService:GetTagged(Game.Tags.Entity) do
		ClientEntity.new(rig)
	end
	CollectionService:GetInstanceAddedSignal(Game.Tags.Entity):Connect(function(rig)
		ClientEntity.new(rig)
	end)
end

return ClientEntity