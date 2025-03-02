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
local ClientEntity = require(script.Parent.Parent.Entities.ClientEntity)
local TypeEntity = require(ReplicatedStorage.Types.TypeEntity)
-- Variables
Footsteps.Instances = {}
-- Constants
local RAYCAST_PARAMS = RaycastParams.new()
RAYCAST_PARAMS.FilterType = Enum.RaycastFilterType.Include
RAYCAST_PARAMS.FilterDescendantsInstances = {Game.Folders.Map}
local FADE_TIME = 0.4
local VOLUME = 0.5

function Footsteps.new(entity: TypeEntity.BaseEntity)
    local self = setmetatable({}, Footsteps)
    assert(entity, "Entity is nil!")

    -- Components
    self.entity = entity
    self.trove = Trove.new()
    self.anima = require(script.Parent.Parent.Player.ClientAnima):get() -- should be local to player

    self:setup()

    Footsteps.Instances[self.entity.id] = self

    return self
end

function Footsteps:getMaterial()
    if not self.entity.rig then return nil end
    if not self.entity.root then return nil end

	local raycast = workspace:Raycast(self.entity.root.Position, -Vector3.yAxis*(self.entity.height+0.1), RAYCAST_PARAMS)
    if not raycast or not raycast.Instance then return nil end
    return raycast.Instance:GetAttribute("Material")
end

function Footsteps:step()
	if not self.entity.rig or not self.entity.rig.Parent then return end

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
		
		if not material then reset(); return end
		
        if material ~= self.lastmat and self.lastmat ~= nil then
            self.sounds[self.lastmat].Playing = false
        end
        local materialSound = self.sounds[material]
        materialSound.Volume = VOLUME
		materialSound.PlaybackSpeed = self.entity.rig.Humanoid.WalkSpeed/12
        materialSound.Playing = true
        self.lastmat = material
    end

	local humanoid = self.entity.rig:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    if humanoid.MoveDirection.Magnitude > 0 then update() else reset() end
end

function Footsteps:muteDefaultSounds()
    for _,child in self.entity.rig:GetChildren() do
        if not child:IsA("Sound") then continue end
        child.Volume = 0
    end
end

function Footsteps:setupRig()
    --self:muteDefaultSounds()
	-- TODO	
end

function Footsteps:setup()
    -- Setup sounds
    self.sounds = AssetsDealer.Get("Sounds","Footsteps") 
    -- Render step
	self.trove:Connect(RunService.RenderStepped, function() self:step() end)
    -- Died event
    self.trove:Connect(self.entity.events.Died, function() self:destroy() end)
end

function Footsteps:destroy()
    self.trove:Destroy()
end

function Footsteps.Init()
    ClientEntity.GlobalAdded:Connect(function(entity)
        Footsteps.new(entity)
    end)
end

return Footsteps