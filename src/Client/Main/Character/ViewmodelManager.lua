local ViewmodelManager = {}
ViewmodelManager.__index = ViewmodelManager

-- Services
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
-- tag service
local CollectionService = game:GetService("CollectionService")

-- Modules
local AssetsDealer = require(ReplicatedStorage.AssetsDealer)
local Trove = require(ReplicatedStorage.Packages.trove)
local Game = require(ReplicatedStorage.Utility.Game)
local Signal = require(ReplicatedStorage.Packages.signal)
local EntityUtility = require(ReplicatedStorage.Utility.Entity)

-- Constants
local VISIBLE_LIMBS = {
    Game.Limbs.RightArm,
    Game.Limbs.LeftArm
}
local VIEWMODEL_WHITELIST = {
    --Game.Limbs.Head,
    Game.Limbs.Torso,
    Game.Limbs.RightArm,
    Game.Limbs.LeftArm,
    Game.Limbs.RightLeg,
    "HumanoidRootPart",
    "Meshes"
}

local CAMERA = Workspace.CurrentCamera
local RIG_SCALE = 0.5

-- Singleton
local singleton = nil

ViewmodelManager.Dependencies = { "ClientAnima", "ClientBackpack" }

function ViewmodelManager.new()
    local self = setmetatable({}, ViewmodelManager)

    -- Components
    self.anima = require(script.Parent.Parent.Player.ClientAnima):get()
    self.backpack = require(script.Parent.Parent.Player.ClientBackpack).LocalPlayerInstance
    self.visible = true

    self.models = {} 
    self.rig = nil

    self:setup()

    self.events = {
        NewRig = Signal.new()
    }

    return self
end

function ViewmodelManager:createToolModel(tool: Tool)
    -- Get tool asset from AssetsDealer
    local asset = AssetsDealer:Get(tool.Name)
    if not asset then return end

    -- Find tool model and handle in asset
    local toolModel = asset:FindFirstChild("Tool")
    local handle = toolModel and toolModel:FindFirstChild("Handle")
    local motor = handle and handle:FindFirstChildOfClass("Motor6D")
    
    if not toolModel or not handle or not motor then
        return warn("Tool asset missing required components")
    end

    local id = tool:GetAttribute("ID")
    -- Clone tool model for viewmodel
    local clonedModel = toolModel:Clone()
    local clonedHandle = clonedModel.Handle
    clonedModel.Name = "Model"

    local folder = Instance.new("Folder")
    folder.Name = id
    folder.Parent = self.rig

    local correspondingLimb = self.rig[motor.Part0.Name]
    motor.Part0 = correspondingLimb
    motor.Part1 = clonedHandle
    motor.Parent = folder

    local model = {}

    model.destroy = function(self)
        self.model:Destroy()
        self.handle:Destroy()
    end

end

function ViewmodelManager:setup()
    -- Connect tool events
    self.backpack.events.ToolAdded:Connect(function(tool)
        if tool:IsA("Tool") then
            self:createToolModel(tool)
        end
    end)

    self.backpack.events.ToolRemoved:Connect(function(tool)
        for i,model in self.models do
            model:destroy()
            table.remove(model, i)
        end
    end)

    -- Initial rig setup
    if self.anima.character then
        self:createNewRig()
    end
    self.anima.events.CharacterAdded:Connect(function()
        self:createNewRig()
    end)
end

-- Singleton pattern
function ViewmodelManager:get()
    if not singleton then
        singleton = ViewmodelManager.new()
    end
    return singleton
end

function ViewmodelManager:stepRig(deltaTime)
    if not self.rig or not self.anima.character then return end

    local cameraCFrame = CAMERA.CFrame
    local character = self.anima.character

    local origin = cameraCFrame+cameraCFrame.LookVector/2-cameraCFrame.UpVector
    self.rig:PivotTo(origin)

    local rigMotors = {
        RightShoulder= self.rig.Torso["Right Shoulder"],
        LeftShoulder= self.rig.Torso["Left Shoulder"],
        RootJoint= self.rig.HumanoidRootPart.RootJoint,
    }
    local characterMotors = {
        RightShoulder= character.Torso["Right Shoulder"],
        LeftShoulder= character.Torso["Left Shoulder"],
        RootJoint= character.HumanoidRootPart.RootJoint,
    }

    -- Animations sync:
    for i,motor in rigMotors do
        local characterMotor = characterMotors[i]
        if motor and characterMotor then
            motor.Transform = characterMotor.Transform
        end
    end
end

function ViewmodelManager:setupRig()
    local trove = Trove.new()
    -- Render stepped with trove
    self.anima.events.CharacterDied:Connect(function()
        trove:Destroy()
    end)

    trove:Connect(RunService.RenderStepped, function(deltaTime: number)
        self:stepRig(deltaTime)
    end)
end

function ViewmodelManager:createNewRig()
    -- Cleanup existing rig and viewmodels
    if self.rig then
        self.rig:Destroy()
        self.rig = nil
    end

    if not self.anima.character then error("No character found to update viewmodel rig") return end

    -- Get current character
    local rig = self.anima.character:Clone()
    rig.Name = "Viewmodel"
    rig.PrimaryPart.Anchored = true
    -- Remove entity tag
    CollectionService:RemoveTag(rig, Game.Tags.Entity)
    CollectionService:AddTag(rig, Game.Tags.Viewmodel)

    rig.Parent = CAMERA
    local modelsFolder = Instance.new("Folder")
    modelsFolder.Name = "Models"
    modelsFolder.Parent = rig

    for _, child in rig:GetChildren() do
        if child:IsA("BasePart") then
            -- Hide character limbs in first-person
            if not table.find(VISIBLE_LIMBS, child.Name) then
                child.LocalTransparencyModifier = 1
            end 
            -- Turn off collisions
            child.CanCollide = false
            -- Disable shadows
            child.CastShadow = false
        end
        -- Remove unused instances
        if not table.find(VIEWMODEL_WHITELIST, child.Name) then
            child:Destroy()
        end
    end    

    -- Make shoulders more far apart
    rig.Torso["Right Shoulder"].C0 = CFrame.new(1.25, 0.5, 0) * CFrame.Angles(0, math.rad(90), 0)
    rig.Torso["Left Shoulder"].C0 = CFrame.new(-1.25, 0.5, 0) * CFrame.Angles(0, math.rad(-90), 0)

    -- Scale the rig
    rig:ScaleTo(RIG_SCALE)

    self.rig = rig

    self:setupRig()
end

function ViewmodelManager.Init()
    ViewmodelManager:get()
end

return ViewmodelManager