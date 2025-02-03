--!strict
local Footsteps = {}
Footsteps.__index = Footsteps

-- Services
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
-- Modules
local AssetsDealer = require(ReplicatedStorage.AssetsDealer)
local Trove = require(ReplicatedStorage.Packages.trove)
local Game = require(ReplicatedStorage.Utility.Game)
-- Constants
local RAYCAST_PARAMS = RaycastParams.new()
RAYCAST_PARAMS.FilterType = Enum.RaycastFilterType.Include
RAYCAST_PARAMS.FilterDescendantsInstances = {Game.Folders.Map}
local FADE_TIME = 0.4
local VOLUME = 0.5

function Footsteps.new()
    local self = setmetatable({}, Footsteps)

    -- Components
    self.anima = require(script.Parent.Parent.Player.ClientAnima):get()
    self.trove = Trove.new()

    self:setup()

    return self
end

function Footsteps:getMaterial()
	local raycast = workspace:Raycast(self.anima.root.Position, -Vector3.yAxis*(self.anima.height+0.1), RAYCAST_PARAMS)
    if not raycast or not raycast.Instance then return nil end
    return raycast.Instance:GetAttribute("Material")
end

function Footsteps:step()
	if not self.anima.character or not self.anima.character.Parent then return end

    local function fadeOut(sound)
        local tween = TweenService:Create(sound, TweenInfo.new(FADE_TIME), {Volume = 0})
        tween:Play()
        tween.Completed:Wait()
        sound.Playing = false
    end

    local function reset()
        for _,sound in self.sounds:GetChildren() do
            task.spawn(fadeOut, sound)
        end
    end

    local function update()
		local material = self:getMaterial()
		
		if not material then reset() return end
		
        if material ~= self.lastmat and self.lastmat ~= nil then
            self.sounds[self.lastmat].Playing = false
        end
        local materialSound = self.sounds[material]
        materialSound.Volume = VOLUME
		materialSound.PlaybackSpeed = self.anima.humanoid.WalkSpeed/12
        materialSound.Playing = true
        self.lastmat = material
    end

	if self.anima.moving then update() else reset() end
end

function Footsteps:muteDefaultSounds()
    for _,child in self.anima.root:GetChildren() do
        if not child:IsA("Sound") then continue end
        child.Volume = 0
    end
end

function Footsteps:setupCharacter()
    --self:muteDefaultSounds()
	-- TODO	
end

function Footsteps:setup()
    -- Remove default footstep sound
    self.anima.events.CharacterAdded:Connect(Footsteps.setupCharacter, self)
	if self.anima.character then
        self:setupCharacter()
    end
    -- Setup sounds
    self.sounds = AssetsDealer.Get("Sounds","Footsteps") 
	self.trove:Connect(RunService.RenderStepped, function() self:step() end)
end

function Footsteps.Init()
    return Footsteps.new()
end

return Footsteps