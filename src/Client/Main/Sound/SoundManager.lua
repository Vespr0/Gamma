--!strict
local SoundManager = {}

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

-- Sound categories and their volume multipliers
local soundCategories = {
	Global = 1,
	Music = 0.8,
	Effects = 0.9,
	UI = 0.7,
	Ambient = 0.6
}

-- Function to create a new sound instance
function SoundManager.New(directory: string, parent: Instance?, category: string?)
	assert(directory, "Sound directory is nil")
	assert(parent, "Sound parent is nil")
	if parent == "Global" then parent = playerGui end
	
	-- Fetch the sound instance using AssetsDealer
	local sound = AssetsDealer.GetDir("Sounds", directory, "Clone")

	if not sound or not sound:IsA("Sound") then
		warn(`Invalid sound asset at "{directory}"`)
		return
	end

	-- Set sound properties
	sound.Volume = 0 -- Start at 0, will be adjusted when played
	sound.Name = directory
	sound.Parent = parent
	sound.RollOffMode = Enum.RollOffMode.InverseTapered

	-- Store category information
	sound:SetAttribute("Category", category or "Global")

	-- Store active sound for later management
	table.insert(activeSounds, sound)

	return sound
end

-- Function to play a sound
function SoundManager.Play(sound: Sound, volume: number?, looped: boolean?, fadeInTime: number?)
	if not sound or not sound:IsA("Sound") then
		warn("Invalid sound instance")
		return
	end

	-- Get category and calculate final volume
	local category = sound:GetAttribute("Category") or "Global"
	local categoryMultiplier = soundCategories[category] or 1
	local finalVolume = (volume or 1) * categoryMultiplier

	-- Set sound properties
	sound.Volume = fadeInTime and 0 or finalVolume
	sound.Looped = looped or false

	-- Play the sound
	sound:Play()

	-- Tween
	if fadeInTime then
		local Tween = TweenService:Create(
			sound,
			TweenInfo.new(fadeInTime),
			{Volume = finalVolume}
		)
		Tween:Play()
	end

	-- Cleanup when sound finishes if it's not looped
	if not sound.Looped then
		sound.Ended:Connect(function()
			SoundManager.StopSound(sound)
		end)
	end

	return sound
end

-- Function to play a sound directly (combines New and Play)
function SoundManager.PlaySound(directory: string, parent: Instance?, volume: number?, looped: boolean?, fadeInTime: number?, category: string?)
	local sound = SoundManager.New(directory, parent, category)
	if sound then
		return SoundManager.Play(sound, volume, looped, fadeInTime)
	end
end

function SoundManager.FadeOut(sound, fadeOutTime: number)
	local tween = TweenService:Create(sound, TweenInfo.new(fadeOutTime), {Volume = 0})
	tween:Play()
	tween.Completed:Wait()
	sound:Stop()
end

-- Function to stop a sound
function SoundManager.StopSound(sound)
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
function SoundManager.StopAllSounds()
	for _, sound in ipairs(activeSounds) do
		SoundManager.StopSound(sound)
	end
end

return SoundManager
