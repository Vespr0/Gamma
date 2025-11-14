-- ProceduralCrouching.lua
local Component = {}
Component.Name = "ProceduralCrouching"
Component.__index = Component

local function lerp(a, b, t)
	return a + (b - a) * t
end

-- Constructor
function Component.new(controller, params)
	local self = setmetatable({}, Component)

	self.Name = Component.Name
	self.controller = controller -- Store reference
	self.movement = params and params.movement

	self.params = {
		crouchHeight = (params and params.crouchHeight) or -1,
		hipAngle = (params and params.hipAngle) or 35,
		lerpSpeed = (params and params.lerpSpeed) or 15,
	}

	self.state = {
		currentAlpha = 0,
	}

	return self
end

-- Main update logic, called by the controller
function Component:update(deltaTime)
	local rig = self.controller.rig
	local isCrouching = rig:GetAttribute("Crouching")
	local targetAlpha = isCrouching and 1.0 or 0.0

	-- Smooth the alpha value
	local t = 1 - math.exp(-self.params.lerpSpeed * deltaTime)
	self.state.currentAlpha = lerp(self.state.currentAlpha, targetAlpha, t)

	if self.state.currentAlpha < 0.001 then
		return {}
	end

	-- Calculate CFrame offsets
	local waistY = self.state.currentAlpha * self.params.crouchHeight
	local hipRad = math.rad(self.state.currentAlpha * self.params.hipAngle)

	return {
		["RootJoint"] = CFrame.new(0, 0, waistY),
		["Left Hip"] = CFrame.new(waistY / 1.5, -waistY, 0) * CFrame.Angles(0, 0, hipRad),
		["Right Hip"] = CFrame.new(-waistY / 1.5, -waistY, 0) * CFrame.Angles(0, 0, -hipRad),
	}
end

-- Cleanup method, called by the controller's trove
function Component:Destroy()
	-- Break circular reference
	self.controller = nil
	self.movement = nil
end

return Component
