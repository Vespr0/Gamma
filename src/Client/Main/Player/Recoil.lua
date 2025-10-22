-- Packes
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Fusion
local Fusion = require(ReplicatedStorage.Packages.fusion)

local RecoilController = {}
RecoilController.__index = RecoilController

-- Constants for tuning
local SPRING_SPEED = 20 -- How quickly the spring moves to its goal. Similar to frequency.
local SPRING_DAMPING = 0.7 -- How much the spring resists oscillation.
local RESET_DELAY = 0.15 -- Time after the last shot before recoil resets.

local singleton = nil

function RecoilController.new()
	local self = setmetatable({}, RecoilController)

	-- A scope handles cleanup automatically. No need for trove or manual destroy.
	local scope = Fusion.scoped()

	-- State object that holds the target recoil angle. This is our "source of truth".
	-- We will animate towards this value.
	self.goal = Fusion.Value(scope, Vector2.new(0, 0))

	-- The Fusion Spring automatically animates to follow the `_goal` state.
	-- This single object replaces your manual springs and the RenderStepped update loop.
	self.spring = Fusion.Spring(scope, self.goal, SPRING_SPEED, SPRING_DAMPING)

	self._resetTask = nil -- To keep track of the scheduled reset

	self:setup()

	return self
end

function RecoilController:get()
	if not singleton then
		singleton = RecoilController.new()
	end
	return singleton
end

-- This function is called from your weapon script when a shot is fired
function RecoilController:applyRecoil(vertical: number, horizontal: number)
	-- Cancel any previously scheduled reset, since we just fired again.
	if self._resetTask then
		task.cancel(self._resetTask)
		self._resetTask = nil
	end

	-- Add the new recoil to the current goal.
	-- We use Fusion.peek() to get the state's value without creating a dependency.
	local currentGoal = Fusion.peek(self.goal)
	self.goal:set(currentGoal + Vector2.new(vertical, horizontal))

	-- Schedule the recoil to reset after a delay.
	self._resetTask = task.delay(RESET_DELAY, function()
		self.goal:set(Vector2.new(0, 0)) -- Set the goal to zero, the spring will animate back.
	end)
end

function RecoilController:setup()
	local scope = Fusion.scoped()
	local camera = workspace.CurrentCamera

	-- Use Fusion.Observer to react to changes in the recoil state
	Fusion.Observer(scope, self.spring):onChange(function()
		-- Get the current animated recoil value from the Spring state object
		local recoilOffset = Fusion.peek(self.spring)

		-- Apply it to the camera's CFrame. This runs every frame the recoil value changes.
		-- This is the ONLY place the camera is directly modified.
		camera.CFrame = camera.CFrame
			* CFrame.Angles(
				math.rad(recoilOffset.X), -- Vertical
				math.rad(recoilOffset.Y), -- Horizontal
				0
			)
	end)
end
return RecoilController
