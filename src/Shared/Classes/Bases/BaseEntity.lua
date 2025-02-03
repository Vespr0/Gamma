local BaseEntity = {}
BaseEntity.__index = BaseEntity
BaseEntity.__type = ""

-- Services 
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local Game = require(ReplicatedStorage.Utility.Game)

function BaseEntity.new(rig,id: number)
	local self = setmetatable({}, BaseEntity)

	assert(rig, "Rig is nil")
	assert(id,"ID is nil")
	
	assert(typeof(rig) == "Instance" and rig:IsA("Model"),"Rig is not a model")
	assert(typeof(id) == "number","ID is not a number")
	
	self.player = Players:GetPlayerFromCharacter(rig) or nil
	self.rig = rig
	self.id = id
	self.root = rig:FindFirstChild("HumanoidRootPart")
	
	-- Events
	self.events = {
		Died = Signal.new()
	}

	self:setupBase()

	return self
end

function BaseEntity:setupBase()
	self:setupRig()
end

function BaseEntity:setupRig()
	self.humanoid = self.rig:WaitForChild("Humanoid") 
		or warn(`Entity "{self.rig.Name}" with id "{self.id}" has no humanoid.`)
	if not self.humanoid:WaitForChild("Animator") then 
		warn(`Entity "{self.rig.Name}" with id "{self.id}" has no animator.`)
	end
	self.root = self.rig.PrimaryPart 
		or warn(`Entity "{self.rig.Name}" with id "{self.id}" has no primary part.`)
	
	self.humanoid.Died:Connect(function()
		self.events.Died:Fire()
	end)
	self.rig.Destroying:Connect(function()
		self.events.Died:Fire()
	end)
end

function BaseEntity:destroyBase()
	table.clear(self)
end

return BaseEntity
