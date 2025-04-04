local Animator = {}
Animator.__index = Animator

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
-- Modulesv
local Signal = require(ReplicatedStorage.Packages.signal)
local AssetsDealer = require(ReplicatedStorage.AssetsDealer)
local Trove = require(ReplicatedStorage.Packages.trove)
local Game = require(ReplicatedStorage.Utility.Game)

-- Variables
local Player = Players.LocalPlayer
Animator.Instances = {}
Animator.GlobalAdded = Signal.new()

-- Constants for animation fading factors
local FADING_IN_FACTOR = 1 / 3
local FADING_OUT_FACTOR = 1 / 4

function Animator.Get(key)
	assert(key, `Key must not be nil.`)
	return Animator.Instances[key]
end

function Animator.Print()
	print("Animator Instances:")
	for _,instance in Animator.Instances do
		print(`"{instance.rig.Name}" : "{instance.id}"`)
	end
end

function Animator.new(rig, isLocalPlayerInstance)
	local id = rig:GetAttribute("ID")
	assert(id,`ID Attribute of rig "{rig.Name}" is nil.`)
	assert(not Animator.Get(id), `Animator instance with ID "{id}" already exists. Attempt on rig "{rig.Name}".`)
	for _,animator in Animator.Instances do
		if animator.rig == rig then
			error(`An animator instance for rig "{rig.Name}" has already been created and is active.`)
		end
	end

	local self = setmetatable({}, Animator)

	self.rig = rig
	self.id = id
	self.trove = Trove.new()

	self.humanoid = self.rig:WaitForChild("Humanoid")
	self.animator = self.humanoid:WaitForChild("Animator")
	self.loaded = {}

	self.wasMoving = false
	self.wasRunning = false
	self.freeFalling = false

	self:connectEvents()
	self:setupAnimations()
	
	-- Play idle by default
	self:play("Base", "Idle")

	self.isLocalPlayerInstance = isLocalPlayerInstance
	self.key = isLocalPlayerInstance and "Local" or self.id 
	Animator.Instances[self.key] = self
	Animator.GlobalAdded:Fire(self)
	
	return self
end

function Animator:setupAnimations()	
	-- Load base animations
	self:load("Base", "Idle", "Movement/Generic/Idle")
	self:load("Base", "Walk", "Movement/Generic/Walk")
	self:load("Base", "Run", "Movement/Generic/Run")
	self:load("Base", "Jump", "Movement/Generic/Jump")
	self:load("Base", "FreeFalling", "Movement/Generic/FreeFalling")
	-- self:load("Base","Hold","Tools/Generic/Hold")
end

function Animator:doesAnimationExist(folderName:string, actionName:string)
	return self.loaded[folderName] and self.loaded[folderName][actionName]
end

function Animator:load(folderName:string, actionName:string, assetDirectory:string)
	local animation = AssetsDealer.GetDir("Animations", assetDirectory)
	if not animation then
		warn(`Couldn't find animation with directory: "{assetDirectory}"`)
		return
	end
	
	if not self.loaded[folderName] then self.loaded[folderName] = {} end

	self.loaded[folderName][actionName] = self.animator:LoadAnimation(animation)
end

function Animator:play(folderName:string, actionName:string, fadeTime:number, weight:number, speed:number)
	if not self:doesAnimationExist(folderName, actionName) then
		warn(`No loaded animation to play with folder name: "{folderName}" and action name: "{actionName}".`)
		return
	end
	self.loaded[folderName][actionName]:Play(fadeTime, weight, speed)
end

function Animator:stop(folderName:string, actionName: string, fadeTime: number)
	if not self:doesAnimationExist(folderName, actionName) then
		warn(`No loaded animation to stop with folder name: "{folderName}" and action name: "{actionName}".`)
		return
	end
	self.loaded[folderName][actionName]:Stop(fadeTime)
end

function Animator:adjustSpeed(folderName:string, actionName: string, speed: number)
	if not self:doesAnimationExist(folderName, actionName) then
		warn(`No loaded animation to adjust speed with folder name: "{folderName}" and action name: "{actionName}".`)
		return
	end
	self.loaded[folderName][actionName]:AdjustSpeed(speed)
end

function Animator:connectEvents()
	self.trove:Add(self.humanoid.StateChanged:Connect(function(old, new)
		self:handleStateChange(old, new)
	end))

	self.trove:Add(self.humanoid.Running:Connect(function(speed)
		self:handleRunning(speed)
	end))

	self.trove:Add(self.humanoid.FreeFalling:Connect(function(isActive)
		self:handleFreeFalling(isActive)
	end))

	self.humanoid.Died:Connect(function()
		self:destroy()
	end)
end

function Animator:handleStateChange(old, new)
	if old == Enum.HumanoidStateType.None then
		self:stop("Base", "Idle", FADING_OUT_FACTOR)
	end

	if new == Enum.HumanoidStateType.None then
		self:play("Base", "Idle", FADING_IN_FACTOR * 2)
	elseif new == Enum.HumanoidStateType.Jumping then
		self:play("Base", "Jump", FADING_IN_FACTOR * 2)
	elseif new == Enum.HumanoidStateType.Landed then
		self:play("Base", "Idle", FADING_IN_FACTOR)
	end
end

function Animator:handleRunning(speed)
	local function toggleRunningAnimations(run, walk)
		if run and (not self.wasRunning or not self.wasMoving) then
			self:play("Base", "Run", FADING_IN_FACTOR)
			self:stop("Base", "Walk", FADING_OUT_FACTOR)
			self.wasRunning = true
		end
		self.loaded.Base.Run:AdjustSpeed(speed / 15)

		if walk and (self.wasRunning or not self.wasMoving) then
			self:play("Base", "Walk", FADING_IN_FACTOR)
			self:stop("Base", "Run", FADING_OUT_FACTOR)
			self.wasRunning = false
		end

		if walk or run then
			self.wasMoving = true
			self.loaded.Base.Walk:AdjustSpeed(speed / 10)
			self.loaded.Base.Run:AdjustSpeed(speed / 14)
		else
			self.wasMoving = false
			self:stop("Base", "Walk", FADING_OUT_FACTOR)
			self:stop("Base", "Run", FADING_OUT_FACTOR)
		end
	end

	if self.freeFalling then toggleRunningAnimations(false, false) return end

	if speed > 14 then
		toggleRunningAnimations(true, false)
	elseif speed > 0.5 then
		toggleRunningAnimations(false, true)
	else
		toggleRunningAnimations(false, false)
		self:play("Base", "Idle", FADING_IN_FACTOR)
	end
end

function Animator:handleFreeFalling(isActive)
	self.freeFalling = isActive
	if self.freeFalling then
		self:play("Base", "FreeFalling", FADING_IN_FACTOR)
	else
		self:stop("Base", "FreeFalling", FADING_OUT_FACTOR)
	end
end

function Animator:destroy()
	self.trove:Destroy()
	for _, folder in pairs(self.loaded) do
		for _, track in pairs(folder) do
			track:Stop()
		end
	end
	Animator.Instances[self.id] = nil
	table.clear(self)
end

return Animator
