--!strict

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Modules
local AssetsDealer = require(ReplicatedStorage:WaitForChild("AssetsDealer"))
local Trove = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("trove"))

-- Sound categories and their volume multipliers
local SOUND_CATEGORIES = {
	Global = 1,
	Music = 0.8,
	Effects = 0.9,
	UI = 0.7,
	Ambient = 0.6,
}

--[[
	A wrapper object for Roblox Sound instances to provide a cleaner API
	and automatic memory management.
]]
local SoundObject = {}
SoundObject.__index = SoundObject

--[[
	Creates a new SoundObject. This is intended for internal use by the SoundManager.
	@param soundInstance {Sound} The raw Sound instance from Roblox.
	@param category {string?} The sound category for volume modulation.
	@returns {SoundObject}
]]
function SoundObject.new(soundInstance: Sound, category: string?)
	local self = setmetatable({}, SoundObject)
	self._sound = soundInstance
	self._category = category or "Global"
	self._trove = Trove.new()
	self._trove:Add(self._sound) -- Ensure sound is destroyed when this object is.

	return self
end

--[[
	Plays the sound with optional fade-in.
	@param volume {number?} The volume to play at (0 to 1).
	@param looped {boolean?} Whether the sound should loop.
	@param fadeInTime {number?} The time in seconds to fade in the sound.
]]
function SoundObject:Play(volume: number?, looped: boolean?, fadeInTime: number?)
	local categoryMultiplier = SOUND_CATEGORIES[self._category] or 1
	local finalVolume = (volume or 1) * categoryMultiplier

	self._sound.Looped = looped or false
	self._sound.Volume = fadeInTime and 0 or finalVolume

	self._sound:Play()

	if fadeInTime and fadeInTime > 0 then
		local tween = TweenService:Create(self._sound, TweenInfo.new(fadeInTime), { Volume = finalVolume })
		tween:Play()
		self._trove:Add(tween)
	end
end

--[[ Stops the sound immediately. ]]
function SoundObject:Stop()
	self._sound:Stop()
end

--[[
	Fades the sound out over a given duration and then stops it.
	@param fadeOutTime {number} The time in seconds to fade out.
]]
function SoundObject:FadeOut(fadeOutTime: number?)
	local time = fadeOutTime or 0.2
	local tween = TweenService:Create(self._sound, TweenInfo.new(time), { Volume = 0 })
	tween:Play()

	self._trove:Add(tween.Completed:Connect(function()
		self:Stop()
	end))
end

--[[
	Connects a function to the sound's Ended event.
	@param callback {function}
	@returns {RBXScriptConnection}
]]
function SoundObject:OnEnded(callback: () -> ())
	return self._sound.Ended:Connect(callback)
end

--[[ Destroys the sound instance and cleans up any connections. ]]
function SoundObject:Destroy()
	self:Stop()
	self._trove:Destroy()
end

--[[
	The main SoundManager module. Provides factory functions for creating
	and playing sounds.
]]
local SoundManager = {}

type SoundOptions = {
	directory: string,
	parent: Instance?,
	category: string?,
	volume: number?,
	looped: boolean?,
	fadeInTime: number?,
}

--[[
	Creates a managed SoundObject that can be controlled by the caller.
	This is for sounds that need to be started, stopped, or managed over time (e.g., looping sounds).
	The creator of the sound is responsible for calling :Destroy() on it when it's no longer needed.

	@param options {SoundOptions}
	@returns {SoundObject?}
]]
function SoundManager.createSound(options: SoundOptions): SoundObject?
	local soundAsset = AssetsDealer.GetDir("Sounds", options.directory, "Clone")

	if not soundAsset or not soundAsset:IsA("Sound") then
		warn(`Invalid sound asset at "{options.directory}"`)
		return nil
	end

	soundAsset.Parent = options.parent or RunService:IsClient() and Players.LocalPlayer:WaitForChild("PlayerGui")
	soundAsset.Name = options.directory
	soundAsset.RollOffMode = Enum.RollOffMode.InverseTapered
	soundAsset.Volume = 0 -- Start silent

	local soundObject = SoundObject.new(soundAsset, options.category)

	-- Play immediately if volume or looped is specified in the creation options
	if options.volume or options.looped then
		soundObject:Play(options.volume, options.looped, options.fadeInTime)
	end

	return soundObject
end

--[[
	Plays a sound once and automatically handles cleanup.
	This is for "fire and forget" sound effects.

	@param options {SoundOptions}
]]
function SoundManager.playSound(options: SoundOptions)
	local soundObject = SoundManager.createSound(options)
	if not soundObject then
		return
	end

	-- For one-shot sounds, play them and destroy them on completion.
	-- Looping is explicitly disallowed for this type of sound.
	soundObject:Play(options.volume, false, options.fadeInTime)
	soundObject:OnEnded(function()
		soundObject:Destroy()
	end)
end

return SoundManager