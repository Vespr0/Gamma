-- ProceduralAnimationController.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local trove = require(ReplicatedStorage.Packages.trove)

local ProceduralAnimationController = {}
ProceduralAnimationController.__index = ProceduralAnimationController

function ProceduralAnimationController.new(rig)
	local self = setmetatable({}, ProceduralAnimationController)

	assert(rig:IsA("Model"), "Rig must be a model")
	self.rig = rig
	self.humanoid = rig:FindFirstChildOfClass("Humanoid")
	assert(self.humanoid, "Rig must have a Humanoid")
	assert(rig:FindFirstChild("HumanoidRootPart"), "Rig must have a HumanoidRootPart")

	self.trove = trove.new()
	self.components = {}
	self.motors = {}
	self.lastFrameOffsets = {}

	-- Motor Indexing
	for _, child in rig:GetDescendants() do
		if child:IsA("Motor6D") then
			self.motors[child.Name] = child
		end
	end

	-- Bind Update Loop
	self.trove:Connect(RunService.RenderStepped, function(dt)
		self:_onUpdate(dt)
	end)

	return self
end

function ProceduralAnimationController:loadComponent(componentModule, params)
	-- The module is passed directly, not a path
	local componentInstance = componentModule.new(self, params)
	self.components[componentModule.Name] = componentInstance
	self.trove:Add(componentInstance)
	return componentInstance
end

function ProceduralAnimationController:getComponent(componentName)
	return self.components[componentName]
end

function ProceduralAnimationController:destroy()
	self.trove:Destroy()

	for motorName, lastOffset in pairs(self.lastFrameOffsets) do
		local motor = self.motors[motorName]
		if motor and motor.Parent then
			motor.C0 = motor.C0 * lastOffset:Inverse()
		end
	end

	self.rig = nil
	self.humanoid = nil
	self.motors = nil
	self.components = nil
	self.lastFrameOffsets = nil
end

function ProceduralAnimationController:_onUpdate(deltaTime)
	local combinedOffsets = {}

	for _, component in pairs(self.components) do
		local componentOffsets = component:update(deltaTime)
		for motorName, offsetCFrame in pairs(componentOffsets) do
			combinedOffsets[motorName] = (combinedOffsets[motorName] or CFrame.new()) * offsetCFrame
		end
	end

	local motorsToUpdate = {}
	for motorName, _ in pairs(combinedOffsets) do
		motorsToUpdate[motorName] = true
	end
	for motorName, _ in pairs(self.lastFrameOffsets) do
		motorsToUpdate[motorName] = true
	end

	for motorName, _ in pairs(motorsToUpdate) do
		local motor = self.motors[motorName]
		if motor and motor.Parent then
			local lastOffset = self.lastFrameOffsets[motorName] or CFrame.new()
			local currentOffset = combinedOffsets[motorName] or CFrame.new()

			if lastOffset ~= currentOffset then
				motor.C0 = motor.C0 * lastOffset:Inverse() * currentOffset
			end
		end
	end

	self.lastFrameOffsets = combinedOffsets
end

return ProceduralAnimationController
