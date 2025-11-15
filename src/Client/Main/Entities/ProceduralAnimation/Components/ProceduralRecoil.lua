-- ProceduralRecoil.lua (Fused)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)

local Component = {}
Component.Name = "ProceduralRecoil"
Component.__index = Component

-- Constants for tuning
local CAMERA_SPRING_SPEED = 15
local CAMERA_SPRING_DAMPING = 0.8
local ARM_SPRING_SPEED = 20
local ARM_SPRING_DAMPING = 0.8
local RESET_DELAY = 0.15

-- Constructor
function Component.new(controller, params)
	local self = setmetatable({}, Component)

	self.Name = Component.Name
	self.controller = controller
	self.scope = Fusion.scoped()

	-- State for camera recoil
	self.cameraGoal = self.scope:Value(Vector2.new(0, 0))
	self.cameraSpring = self.scope:Spring(self.cameraGoal, CAMERA_SPRING_SPEED, CAMERA_SPRING_DAMPING)
	self.currentCameraRecoilCFrame = CFrame.new()

	-- State for arm recoil
	self.armGoal = self.scope:Value(0) -- Changed to a single number for intensity
	self.armSpring = self.scope:Spring(self.armGoal, ARM_SPRING_SPEED, ARM_SPRING_DAMPING)

	self.resetTask = nil
	self.camera = workspace.CurrentCamera

	-- Observer to update the camera CFrame automatically when the spring changes.
	Fusion.Observer(self.scope, self.cameraSpring):onChange(function()
		local recoilOffset = Fusion.peek(self.cameraSpring)
		self.currentCameraRecoilCFrame = CFrame.Angles(
			math.rad(-recoilOffset.X), -- Vertical (negative for upward kick)
			math.rad(recoilOffset.Y), -- Horizontal
			0
		)
	end)

	return self
end

-- This is the main entry point for recoil, to be called by weapon scripts.
function Component:applyRecoil(vertical: number, horizontal: number)
	-- Cancel previous reset task to avoid premature reset.
	if self.resetTask then
		task.cancel(self.resetTask)
		self.resetTask = nil
	end

	-- Update camera recoil goal
	local currentCameraGoal = Fusion.peek(self.cameraGoal)
	self.cameraGoal:set(currentCameraGoal + Vector2.new(vertical, horizontal))

	-- Update arm recoil goal based on camera recoil (single intensity for Z-axis rotation)
	local currentArmGoal = Fusion.peek(self.armGoal)
	local armRecoilIntensity = vertical * 0.7 -- Use vertical recoil as intensity for arms
	self.armGoal:set(currentArmGoal + armRecoilIntensity)

	-- Schedule a single task to reset both recoil goals after a delay.
	self.resetTask = task.delay(RESET_DELAY, function()
		self.cameraGoal:set(Vector2.new(0, 0))
		self.armGoal:set(0) -- Reset to 0 for a number
	end)
end

-- Called by the ProceduralAnimationController to get arm animation offsets and apply camera recoil.
function Component:update(deltaTime)
	-- Apply camera recoil directly.
	-- self.currentCameraRecoilCFrame is updated by the Fusion observer.
	if self.camera then
		self.camera.CFrame = self.camera.CFrame * self.currentCameraRecoilCFrame
	end

	-- Calculate and return arm recoil offsets.
	local armRecoilValue = Fusion.peek(self.armSpring) -- This is now a number

	-- If recoil is negligible, do nothing for arms.
	if math.abs(armRecoilValue) < 0.01 then
		return {}
	end

	-- Create a CFrame with rotation only on the Z-axis for the arm recoil.
	local armRecoilCFrame = CFrame.Angles(0, 0, math.rad(armRecoilValue))

	-- Return offsets for the shoulder motors.
	return {
		["Right Shoulder"] = armRecoilCFrame,
		["Left Shoulder"] = armRecoilCFrame,
	}
end

-- Cleanup method for when the component is destroyed.
function Component:Destroy()
	if self.scope then
		self.scope:doCleanup()
	end
	self.controller = nil
end

return Component