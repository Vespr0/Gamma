local Cursor = {}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CursorComponent = require(ReplicatedStorage.UI.Components.Cursor)

UserInputService.MouseIconEnabled = false

function Cursor.InitUi(ui)
	local spreadValue = ui.scope:Value(4)
	local positionValue = ui.scope:Value(UDim2.fromOffset(0, 0))

	-- Get the CursorGui
	local playerGui = ui.playerGui
	local CursorGui = playerGui:FindFirstChild("Cursor")

	-- Create the cursor component from the scope
	local cursorInstance = CursorComponent(ui.scope, {
		Parent = CursorGui,
		Position = positionValue,
		Spread = spreadValue,
	})

	-- Store reference to the spread value for external access
	Cursor.Spread = spreadValue

	-- Move the cursor with the mouse
	local function mouseMoved()
		local position = ui.GetMousePosition(false)
		positionValue:set(UDim2.fromOffset(position.X, position.Y))
	end

	-- Connect events and add to trove for cleanup
	ui.trove:Add(ui.mouse.Move:Connect(mouseMoved))

	-- Initial position
	mouseMoved()

	return ui.trove
end

return Cursor
