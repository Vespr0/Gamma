--!strict
local BaseItemAbilities = {}
-- Services
-- local Players = game:GetService("Players")
-- local RunService = game:GetService("RunService")
-- local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- -- Modules
-- local ItemInput = require(script.Parent.Parent.Input.Modules.Item)
-- local ClientBackpack = require(script.Parent.ClientBackpack)
-- local Safety = require(ReplicatedStorage.Utility.Safety)
-- local ClientBackpackLocalPlayerInstance
-- local ClientMovement = require(script.Parent.Parent.Character.ClientMovement):get()
-- local ClientAnima = require(script.Parent.Parent.Player.ClientAnima):get()
-- local Game = require(ReplicatedStorage.Utility.Game)
-- -- Variables
-- local Player = Players.LocalPlayer

-- local function getCharge()
-- 	return (ClientAnima:GetAttribute("Charge") or 0)
-- end	

-- local function setupThrow()
-- 	local pressed = false
	
-- 	ItemInput.BeganEvent:Connect(function(name)
-- 		if name == "THROW" then
-- 			pressed = true
-- 			task.spawn(function()
-- 				while pressed and getCharge() < 1 do
-- 					RunService.RenderStepped:Wait()
					
-- 					-- Increment Charge
-- 					ClientAnima:IncrementAttribute("Charge",Game.Gameplay.ChargeIncrement)
					
-- 					-- Slow down the character speed
-- 					ClientMovement.boosts.WalkSpeed.Throw = -getCharge()*5
-- 				end
-- 			end)
-- 		end
-- 	end)

-- 	ItemInput.EndedEvent:Connect(function(name)
-- 		if name == "THROW" then
-- 			print("Thrown")
-- 			pressed = false
-- 			ClientAnima:SetAttribute("Charge",0)
-- 			ClientMovement.boosts.WalkSpeed.Throw = 0			
-- 		end
-- 	end)
-- end

-- function BaseItemAbilities.Init()
-- 	task.spawn(function()
-- 		ClientBackpackLocalPlayerInstance = Safety.WaitForInstance(ClientBackpack,"LocalPlayerInstance")
-- 	end)
	
-- 	--setupThrow()
-- end

return BaseItemAbilities
