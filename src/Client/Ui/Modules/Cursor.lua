--!strict
local Cursor = {}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Mouse = Players.LocalPlayer:GetMouse()

UserInputService.MouseIconEnabled = false

function Cursor.InitUi(ui)
	-- UI Elements
	local CursorGui = ui.GetGui("Cursor")
	local Dot = CursorGui.Dot

	-- Move the dot with the mouse
	local function mouseMoved()
		Dot.Position = UDim2.fromOffset(Mouse.X, Mouse.Y)
	end

	-- Connect events
	Mouse.Move:Connect(mouseMoved)

	return { Destroy = function() end } -- dummy trove
end

return Cursor