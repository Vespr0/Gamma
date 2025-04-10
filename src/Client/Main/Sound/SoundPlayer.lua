--!strict
local SoundPlayer = {}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Modules
local AssetsDealer = require(ReplicatedStorage:WaitForChild("AssetsDealer"))

-- Variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local activeSounds = {}

-- Function to play a sound
function SoundPlayer.PlaySound(directory: string, parent: Instance?, volume: number?, looped: boolean?,fadeInTime: number?)
	parent = parent or playerGui
	-- Fetch the sound instance using AssetsDealer
	local sound = AssetsDealer.GetDir("Sounds", directory, "Clone")

	if not sound or not sound:IsA("Sound") then
		warn(`Invalid sound asset at "{directory}"`)
		return
	end

	-- Set sound properties
	sound.Volume = fadeInTime and 0 or (volume or 1)
	sound.Looped = looped or false
	sound.Parent = parent

	-- Play the sound
	sound:Play()

	-- Tween
	if fadeInTime then
		local Tween = TweenService:Create(
			sound,
			TweenInfo.new(fadeInTime),
			{Volume = volume or 1}
		)
		Tween:Play()
	end
	-- Store active sound for later management
	table.insert(activeSounds, sound)

	-- Cleanup when sound finishes if it's not looped
	if not sound.Looped then
		sound.Ended:Connect(function()
			SoundPlayer.StopSound(sound)
		end)
	end

	-- TODO: Possible memory leak here
	-- sound.Stopping:Connect(function()
	-- 	sound:Destroy()
	-- end)

	return sound
end

function SoundPlayer.FadeOut(sound, fadeOutTime: number)
	local tween = TweenService:Create(sound, TweenInfo.new(fadeOutTime), {Volume = 0})
	tween:Play()
	tween.Completed:Wait()
	sound:Stop()
end

-- Function to stop a sound
function SoundPlayer.StopSound(sound)
	if sound and sound:IsA("Sound") then
		sound:Stop()
		sound:Destroy()

		-- Remove from activeSounds
		for i, activeSound in ipairs(activeSounds) do
			if activeSound == sound then
				table.remove(activeSounds, i)
				break
			end
		end
	end
end

-- Function to stop all currently playing sounds
function SoundPlayer.StopAllSounds()
	for _, sound in ipairs(activeSounds) do
		SoundPlayer.StopSound(sound)
	end
end

return SoundPlayer
