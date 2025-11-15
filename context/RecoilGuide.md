-- This MUST be a LocalScript, placed inside your Tool
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local tool = script.Parent

-- ========
-- SETTINGS
-- ========
-- This is the "UP" part. How many degrees to kick the camera up per shot.
local KICK_UP_DEGREES = 1.5

-- This is the "DOWN" part. How fast the camera returns to 0.
-- Higher numbers = a faster, "snappier" return.
-- Lower numbers = a "softer" return.
local RECOVER_SPEED = 8

-- This is our "spring" variable. It tracks the current camera offset.
local currentRecoilAngle = 0

-- A helper function for Linear Interpolation (Lerp)
-- This is the heart of the "DOWN" (return) movement.
function lerp(start, goal, alpha)
return start + (goal - start) \* alpha
end

-- ========
-- THE LOGIC
-- ========

-- This function runs when the tool is "Activated" (clicked)
function onFire()
-- This is the "UP" part:
-- We just ADD our kick amount to the current recoil.
currentRecoilAngle = currentRecoilAngle + KICK_UP_DEGREES
end

-- This function runs every single frame, right before the camera renders
function onRenderStep(deltaTime)
-- This is the "DOWN" part:
-- We smoothly interpolate the currentRecoilAngle back towards 0.
-- We use 'deltaTime' to make the recovery speed consistent
-- regardless of the player's frame rate.
local alpha = RECOVER_SPEED \* deltaTime
currentRecoilAngle = lerp(currentRecoilAngle, 0, alpha)

    -- This is the "APPLY" part:
    -- We apply the current recoil to the camera as a rotation.
    -- CFrame.Angles uses radians, so we convert our degrees.
    local recoilRotation = CFrame.Angles(math.rad(currentRecoilAngle), 0, 0)

    -- We MUST multiply the CFrame in this order:
    -- (Current Camera) * (Our Recoil Adjustment)
    if camera then
    	camera.CFrame = camera.CFrame * recoilRotation
    end

end

-- Connect the functions to the game events
tool.Activated:Connect(onFire)
RunService.RenderStepped:Connect(onRenderStep)
