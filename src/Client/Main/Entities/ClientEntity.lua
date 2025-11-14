-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
-- Metatable
local BaseEntity = require(ReplicatedStorage.Classes.Bases.BaseEntity)
local ClientEntity = setmetatable({}, { __index = BaseEntity })
ClientEntity.__index = ClientEntity
-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local Game = require(ReplicatedStorage.Utility.Game)
local Animator = require(script.Parent.Animator)
local TypeRig = require(ReplicatedStorage.Types.TypeRig)
local EntityUtility = require(ReplicatedStorage.Utility.Entity)
local ClientBackpack = require(script.Parent.Parent.Entities.ClientBackpack)
local ClientMovement = require(script.Parent.Parent.Entities.ClientMovement)
local ViewmodelManager = require(script.Parent.Parent.Character.ViewmodelManager)
local ClientAppearance = require(script.Parent.ClientAppearance)
local ClientLookAt = require(script.Parent.ClientLookAt)
local ProceduralAnimationController = require(script.Parent.ProceduralAnimation.ProceduralAnimationController)
local ProceduralCrouching = require(script.Parent.ProceduralAnimation.Components.ProceduralCrouching)

-- Variables
local LocalPlayer = Players.LocalPlayer
ClientEntity.Instances = {}
ClientEntity.GlobalAdded = Signal.new()
ClientEntity.LocalPlayerInstance = nil

function ClientEntity.Get(id: number | string)
	return ClientEntity.Instances[tostring(id)]
end

function ClientEntity.new(rig: TypeRig.Rig)
	if not EntityUtility.IsHealthy(rig) then
		warn(`Rig "{rig.Name}" is not alive, cannot create client entity instance`)
		return
	end

	local id = rig:GetAttribute("ID") :: number
	local self = setmetatable(BaseEntity.new(rig, id), ClientEntity)

	-- Store the instance linked to the current player character
	self.isLocalPlayerInstance = LocalPlayer.Character == rig :: boolean
	if self.isLocalPlayerInstance then
		ClientEntity.LocalPlayerInstance = self
	end

	self:setup()

	-- Store the instance
	ClientEntity.Instances[id] = self
	ClientEntity.GlobalAdded:Fire(self)

	print(`Created client entity instance for rig "{rig.Name}"`)

	return self
end

function ClientEntity:setupViewmodel()
	if not self.isLocalPlayerInstance then
		return
	end

	self.viewmodelManager = ViewmodelManager.new(self)
end

function ClientEntity:setupProceduralAnimations()
	self.animationController = ProceduralAnimationController.new(self.rig)
	self.animationController:loadComponent(ProceduralCrouching)
end

function ClientEntity:setup()
	-- Initialize components in correct order, changing the order will result in errors
	self:setupAnimations()
	self:setupMovement()
	self:setupAppearance()
	self:setupViewmodel()
	self:setupProceduralAnimations()
	self:setupBackpack()

	self.events.Died:Connect(function()
		self:destroy()
	end)
end

function ClientEntity:setupMovement()
	self.movement = ClientMovement.new(self, self.isLocalPlayerInstance)
	-- no longer overriding default movement; just enhanced air control via ClientJumping
end

function ClientEntity:setupAnimations()
	-- Destroy the roblox default animate script if present
	local animateScript = self.rig:FindFirstChild("Animate")
	if animateScript then
		animateScript:Destroy()
	end
	-- Link an animator instance
	self.animator = Animator.new(self.rig, self.isLocalPlayerInstance)
end

function ClientEntity:setupBackpack()
	self.backpack = ClientBackpack.new(self, self.isLocalPlayerInstance)
	print(self.backpack, self.isLocalPlayerInstance)
end

function ClientEntity:setupAppearance()
	self.appearance = ClientAppearance.new(self)
end

function ClientEntity:destroy()
	if self.Recoil then
		self.Recoil:destroy()
	end

	self.animationController:destroy()

	ClientEntity.Instances[tostring(self.id)] = nil

	if self.isLocalPlayerInstance then
		self.viewmodelManager:destroy()

		ClientEntity.LocalPlayerInstance = nil
	end

	self:destroyBase()
end

function ClientEntity.Init()
	for _, rig in CollectionService:GetTagged(Game.Tags.Entity) do
		ClientEntity.new(rig)
	end
	CollectionService:GetInstanceAddedSignal(Game.Tags.Entity):Connect(function(rig)
		ClientEntity.new(rig)
	end)
end

return ClientEntity
