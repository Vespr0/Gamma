--!strict
--[[
	LightingManager
	@author Gemini
	@date 11/07/2025

	A module for managing lighting presets.
]]

local Lighting = game:GetService("Lighting")

local LightingManager = {}

local presets = {
	Day = {
		-- Lighting properties
		Ambient = Color3.fromRGB(70, 70, 70),
		Brightness = 3,

		-- ClockTime
		ClockTime = 14.5,

		-- ExposureCompensation
		ExposureCompensation = 0,
	},
	Night = {
		-- Lighting properties
		Ambient = Color3.fromRGB(60, 60, 60),
		Brightness = 1,

		-- ClockTime
		ClockTime = 0,

		-- ExposureCompensation
		ExposureCompensation = -0.5,
	},
}

--- Sets the lighting to a given preset.
-- @param presetName The name of the preset to apply (e.g., "Day", "Night").
function LightingManager.SetPreset(presetName: string)
	local preset = presets[presetName]
	if not preset then
		warn("Lighting preset not found:", presetName)
		return
	end

	for property, value in pairs(preset) do
		pcall(function()
			Lighting[property] = value
		end)
	end
end

return LightingManager
