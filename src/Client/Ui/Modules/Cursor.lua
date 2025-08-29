local Cursor = {}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

UserInputService.MouseIconEnabled = false

function Cursor.InitUi(ui)
	local peek = ui.Fusion.peek
	-- Create the cursor component from the scope
	local component = ui.scope:CursorComponent({
		Spread = ui.scope:Value(4),
		Utility = ui,
	})

	-- Get the CursorGui
	local playerGui = ui.playerGui
	local CursorGui = playerGui:FindFirstChild("Cursor")

	-- Parent the cursor to the CursorGui
	component.Container.Parent = CursorGui

	-- Store reference to the spread value for external access
	Cursor.Spread = component.Spread

	-- Move the cursor with the mouse
	local function mouseMoved()
		local position = ui.GetMousePosition(false)
		component.Container.Position = UDim2.fromOffset(position.X, position.Y)
	end

	-- Connect events and add to trove for cleanup
	ui.trove:Add(ui.mouse.Move:Connect(mouseMoved))

	-- Initial position
	mouseMoved()

	return ui.trove
end

return Cursor