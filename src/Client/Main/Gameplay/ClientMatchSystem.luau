--!strict
--[[
	ClientMatchSystem
	@author Gemini
	@date 11/07/2025

	Handles the client-side logic for matches.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BridgeNet2 = require(ReplicatedStorage.Packages.BridgeNet2)
local Signal = require(ReplicatedStorage.Packages.signal)
local LightingManager = require(script.Parent.Parent.Visual.LightingManager)

local ClientMatchSystem = {}

ClientMatchSystem.MatchStateChanged = Signal.new()
ClientMatchSystem.CurrentMatchState = { phase = "None" }

function ClientMatchSystem.Init()
	local matchStateBridge = BridgeNet2.ClientBridge("MatchState")

	matchStateBridge:Connect(function(data: {
		phase: string,
		lightingPreset: string?,
		assignedRole: string?,
		players: { { UserId: number, DisplayName: string } }?,
		event: { Title: string, Start: number }?,
	})
		ClientMatchSystem.CurrentMatchState = data
		ClientMatchSystem.MatchStateChanged:Fire(data)

		if data.phase == "Lobby" then
			print("Entered lobby!")

			LightingManager.SetPreset("Day")
		elseif data.phase == "InGame" then
			print("Match started!")

			print("Lighting preset:", data.lightingPreset)

			print("Assigned role:", data.assignedRole)

			-- Set the lighting

			if data.lightingPreset then
				LightingManager.SetPreset(data.lightingPreset)
			end
		end
	end)
end

return ClientMatchSystem
