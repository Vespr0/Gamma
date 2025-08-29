local BaseEntity = {}
BaseEntity.__index = BaseEntity
BaseEntity.__type = ""

-- TODO: Add trove

-- Services 
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local Game = require(ReplicatedStorage.Utility.Game)
local EntityUtility = require(ReplicatedStorage.Utility.Entity)
local Trove = require(ReplicatedStorage.Packages.trove)

function BaseEntity.new(rig,id: number)
	if not EntityUtility.IsHealthy(rig) then warn(`Rig "{rig.Name}" is not alive, cannot create base entity instance`) return end

	local self = setmetatable({}, BaseEntity)

	assert(rig, "Rig is nil")
	assert(id,"ID is nil")
	
	assert(typeof(rig) == "Instance" and rig:IsA("Model"),"Rig is not a model")
	assert(typeof(id) == "number","ID is not a number")

	self.rig = rig
	self.id = id
	self.root = rig:FindFirstChild("HumanoidRootPart")
	self.height = 0 :: number
	
	self.trove = Trove.new()

	-- Events
	self.events = {
		Died = Signal.new(),
		ChildAdded = Signal.new(),
		ChildRemoved = Signal.new()
	}

	self:setupBase()

	return self
end

function BaseEntity:setupBase()
	self:setupRig()
	self:setupEvents()
end

function BaseEntity:setupEvents()
	self.trove:Add(self.rig.ChildAdded:Connect(function(child)
		self.events.ChildAdded:Fire(child)
	end))
	self.trove:Add(self.rig.ChildRemoved:Connect(function(child)
		self.events.ChildRemoved:Fire(child)
	end))
end

function BaseEntity:setupRig()
	-- Rig's humanoid
	self.humanoid = self.rig:WaitForChild("Humanoid") 
		or warn(`Entity "{self.rig.Name}" with id "{self.id}" has no humanoid.`)
	-- Rig's animator
	if not self.humanoid:WaitForChild("Animator") then 
		warn(`Entity "{self.rig.Name}" with id "{self.id}" has no animator.`)
	end
	-- Rig's primary part
	self.root = self.rig.PrimaryPart 
		or warn(`Entity "{self.rig.Name}" with id "{self.id}" has no primary part.`)
	-- Height of the rig
	self.height = self.rig:GetExtentsSize().Y :: number

	-- TODO: Possible performance issue?
	self.trove:Add(RunService.Heartbeat:Connect(function()
		if not EntityUtility.IsAlive(self.rig) or not EntityUtility.IsHealthy(self.rig) then
			warn("DEMACIA")
			self.events.Died:Fire()
		end
	end))
	-- self.trove:Add(self.humanoid.Died:Connect(function()
	-- 	self.events.Died:Fire()
	-- end))
	-- self.trove:Add(self.rig.Destroying:Connect(function()
	-- 	self.events.Died:Fire()
	-- end))
end

function BaseEntity:destroyBase()
	if not self.trove then warn("destroyBase called twice on BaseEntity") end
	
	self.trove:Destroy()
	-- TODO: This code repeats often in a lot of classes
	for _, event: any in self.events do
		event:Destroy()
	end
	table.clear(self)
end

return BaseEntity
