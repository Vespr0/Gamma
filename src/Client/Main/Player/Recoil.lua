-- Services
local RunService = game:GetService("RunService")

local RecoilController = {}
RecoilController.__index = RecoilController

--
-- SETTINGS
--
-- How fast the camera returns to its original position after a shot.
-- Higher numbers = a faster, "snappier" return.
-- Lower numbers = a "softer", more delayed return.
local RECOVER_SPEED = 15

local singleton = nil

--
-- Constructor
--
function RecoilController.new()
	local self = setmetatable({}, RecoilController)

	-- This tracks the current offset of the camera from recoil.
	self.currentRecoil = Vector2.new(0, 0)
	self.camera = workspace.CurrentCamera

	-- The 'onRenderStep' function will be connected to this to run every frame.
	-- This is disconnected automatically if the script is destroyed.
	self.renderConnection = RunService.RenderStepped:Connect(function(dt)
		self:onRenderStep(dt)
	end)

	return self
end

--
-- Singleton Accessor
--
function RecoilController:get()
	if not singleton then
		singleton = RecoilController.new()
	end
	return singleton
end

--
-- Public Methods
--

-- This function is called from a weapon script when a shot is fired.
-- vertical: How many degrees to kick the camera "up".
-- horizontal: How many degrees to kick the camera sideways.
function RecoilController:applyRecoil(vertical: number, horizontal: number)
	-- Directly add the recoil impulse, as in the reference guide.
	self.currentRecoil = self.currentRecoil + Vector2.new(vertical, horizontal)
end

--
-- Internal Logic
--

-- This function runs every frame to apply the recoil effect.
function RecoilController:onRenderStep(deltaTime: number)
	if not self.camera then
		return
	end

	-- Smoothly interpolate the recoil angle back towards zero.
	-- We use deltaTime to make recovery speed consistent regardless of framerate.
	-- Alpha is clamped to 1 to prevent overshooting on low framerates.
	local alpha = math.min(RECOVER_SPEED * deltaTime, 1)
	self.currentRecoil = self.currentRecoil:Lerp(Vector2.new(0, 0), alpha)

	-- Create the rotation CFrame from the current recoil angles.
	-- We apply -X for vertical recoil so a positive 'vertical' value kicks the camera UP.
	local recoilRotation = CFrame.Angles(
		math.rad(self.currentRecoil.X), -- Vertical
		math.rad(self.currentRecoil.Y), -- Horizontal
		0
	)

	-- Apply the rotation to the camera's current CFrame.
	-- The multiplication order is important: Current * Adjustment
	self.camera.CFrame = self.camera.CFrame * recoilRotation
end

-- This allows the singleton to be cleaned up if needed.
function RecoilController:destroy()
	if self.renderConnection then
		self.renderConnection:Disconnect()
		self.renderConnection = nil
	end
	singleton = nil
end

return RecoilController
