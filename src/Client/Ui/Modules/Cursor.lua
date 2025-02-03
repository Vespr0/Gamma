--!strict
local Cursor = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Modules
local Viewports = require(script.Parent.Parent.Viewports)
local Trove = require(ReplicatedStorage.Packages.trove)
local TypeAnima = require(ReplicatedStorage.Types.TypeAnima)
local ClientAnima = require(script.Parent.Parent.Parent.Main.Player.ClientAnima):get() :: TypeAnima.ClientAnima

local Mouse = Players.LocalPlayer:GetMouse()

UserInputService.MouseIconEnabled = false

local random = Random.new()

function Cursor.InitUi(ui)
	-- UI Elements
	local CursorGui = ui.GetGui("Cursor")
	local Dot = CursorGui.Dot

	-- Trove for cleaning up
	local trove = Trove.new()
	
	-- Constants
	local relaxedSize = UDim2.fromOffset(5,5)
	local growSize = UDim2.fromOffset(8,8)
	-- Reactive 
	local currentSize = ui.Value(relaxedSize) 
	local springSize = ui.Spring(currentSize, 50, 0.8) 
	
	local function getCursorColor(charge: number)
		local yellow = Color3.fromRGB(255, 213, 0)
		local red = Color3.fromRGB(255, 24, 7) 
		local white = Color3.fromRGB(255, 255, 255)

		if charge >= 0.9 then
			return red
		end
		if charge >= 0.6 then
			return yellow
		end
		return white
	end

	local function getCursorSize(charge: number)
		local bias = 3
		if charge == 1 then
			bias += random:NextInteger(-1,1)
		end		
		return springSize:get() :: UDim2 + UDim2.fromOffset(charge*bias,charge*bias)
	end
	
	-- Move the dot with the mouse
	local function mouseMoved()
		Dot.Position = UDim2.fromOffset(Mouse.X, Mouse.Y)
	end

	-- Handle mouse clicks to grow and shrink the dot
	local function mouseClicked()
		currentSize:set(growSize)
		task.delay(.2,function()
			currentSize:set(relaxedSize)
		end)
	end
	
	local function stepped()
		local charge = ClientAnima:GetAttribute("Charge") or 0 :: number
		
		Dot.Size = getCursorSize(charge)
		Dot.BackgroundColor3 = getCursorColor(charge)
	end
	
	-- Connect events
	trove:Add(Mouse.Move:Connect(mouseMoved))
	trove:Add(Mouse.Button1Down:Connect(mouseClicked))
	trove:Add(RunService.RenderStepped:Connect(stepped))
	
	return trove
end


return Cursor