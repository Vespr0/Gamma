local ViewmodelManager = {}
ViewmodelManager.__index = ViewmodelManager

-- Services
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")

-- Modules
local AssetsDealer = require(ReplicatedStorage.AssetsDealer)
local Trove = require(ReplicatedStorage.Packages.trove)
local Game = require(ReplicatedStorage.Utility.Game)
local Signal = require(ReplicatedStorage.Packages.signal)
local EntityUtility = require(ReplicatedStorage.Utility.Entity)

-- Constants
local VISIBLE_LIMBS = { Game.Limbs.RightArm, Game.Limbs.LeftArm }
local VIEWMODEL_WHITELIST = { Game.Limbs.Torso, Game.Limbs.RightArm, Game.Limbs.LeftArm, Game.Limbs.RightLeg, "HumanoidRootPart", "Meshes" }
local CAMERA = Workspace.CurrentCamera
local VIEWMODEL_SCALE = 0.5

-- Singleton
local singleton = nil

ViewmodelManager.Dependencies = { "ClientAnima", "ClientBackpack" }

-- Helper functions
local function scaleCFrame(cframe: CFrame, scale: number)
    local pos = cframe.Position * scale
    local rot = cframe - cframe.Position
    return CFrame.new(pos) * rot
end

local function destroyFakeTool(fakeTool)
    fakeTool.model:Destroy()
    fakeTool.handle:Destroy()
    fakeTool.motor:Destroy()
end

function ViewmodelManager.new()
    local self = setmetatable({}, ViewmodelManager)
    
    self.anima = require(script.Parent.Parent.Player.ClientAnima):get()
    self.backpack = require(script.Parent.Parent.Player.ClientBackpack).LocalPlayerInstance
    self.visible = true
    self.fakeTools = {}
    self.rig = nil
    self.events = { NewRig = Signal.new() }

    self:initializeDependencies()
    return self
end

function ViewmodelManager:toggleFakeToolVisibility(fakeTool,visible: boolean)
    fakeTool.model.Parent = visible and self.rig or nil
end

function ViewmodelManager:initializeDependencies()
    self:setupCharacterEvents()
    self:setupToolEvents()
end

function ViewmodelManager:setupCharacterEvents()
    if self.anima.character then
        self:createNewRig()
    end
    self.anima.events.CharacterAdded:Connect(function()
        self:createNewRig()
    end)
end

function ViewmodelManager:setupToolEvents()
    for _, tool in self.backpack:getTools() do
        self:createFakeTool(tool)
    end
    
    self.backpack.events.ToolAdded:Connect(function(tool)
        self:createFakeTool(tool)
    end)

    self.backpack.events.ToolRemoved:Connect(function(tool)
        for i, fakeTool in self.fakeTools do
            destroyFakeTool(fakeTool)
            table.remove(self.fakeTools, i)
        end
    end)

    self.backpack.events.ToolEquipped:Connect(function(tool)
        local ID = tool:GetAttribute("ID")
        for otherID, fakeTool in self.fakeTools do
            if otherID == ID then
                fakeTool:show()
            else
                fakeTool:hide()
            end
        end
    end)

    self.backpack.events.ToolUnequipped:Connect(function(tool)
        local ID = tool:GetAttribute("ID")
        self.fakeTools[ID]:hide()
    end)
end

function ViewmodelManager:createNewRig()
    self:cleanupExistingRig()
    local character = self.anima.character
    if not character then return end

    self.rig = self:cloneCharacterRig(character)
    self:configureRigAppearance()
    self:setupRigSync()
    self.events.NewRig:Fire(self.rig)
end

function ViewmodelManager:cleanupExistingRig()
    if self.rig then
        self.rig:Destroy()
        self.rig = nil
    end
end

function ViewmodelManager:cloneCharacterRig(character)
    local rig = character:Clone()
    rig.Name = "Viewmodel"
    rig.PrimaryPart.Anchored = true
    CollectionService:RemoveTag(rig, Game.Tags.Entity)
    CollectionService:AddTag(rig, Game.Tags.Viewmodel)
    rig.Parent = CAMERA
    return rig
end

function ViewmodelManager:configureRigAppearance()
    local modelsFolder = Instance.new("Folder")
    modelsFolder.Name = "Models"
    modelsFolder.Parent = self.rig

    self:processRigParts()
    self:adjustShoulderMotors()
    self.rig:ScaleTo(VIEWMODEL_SCALE)
end

function ViewmodelManager:processRigParts()
    for _, child in self.rig:GetChildren() do
        if child:IsA("BasePart") then
            self:configurePartVisibility(child)
            child.CanCollide = false
            child.CastShadow = false
        elseif not table.find(VIEWMODEL_WHITELIST, child.Name) then
            child:Destroy()
        end
    end
end

function ViewmodelManager:configurePartVisibility(part)
    part.LocalTransparencyModifier = table.find(VISIBLE_LIMBS, part.Name) and 0 or 1
end

function ViewmodelManager:adjustShoulderMotors()
    self.rig.Torso["Right Shoulder"].C0 = CFrame.new(1.25, 0.5, 0) * CFrame.Angles(0, math.rad(90), 0)
    self.rig.Torso["Left Shoulder"].C0 = CFrame.new(-1.25, 0.5, 0) * CFrame.Angles(0, math.rad(-90), 0)
end

function ViewmodelManager:setupRigSync()
    local trove = Trove.new()
    self.anima.events.CharacterDied:Connect(function()
        trove:Destroy()
    end)
    trove:Connect(RunService.RenderStepped, function(deltaTime)
        self:updateRigPosition()
        self:syncMotors()
    end)
end

function ViewmodelManager:updateRigPosition()
    if not self.rig then return end
    local cameraCFrame = CAMERA.CFrame
    local origin = cameraCFrame + cameraCFrame.LookVector/2 - cameraCFrame.UpVector
    self.rig:PivotTo(origin)
end

function ViewmodelManager:syncMotors()
    local rigMotors = {
        RightShoulder = self.rig.Torso["Right Shoulder"],
        LeftShoulder = self.rig.Torso["Left Shoulder"],
        RootJoint = self.rig.HumanoidRootPart.RootJoint,
    }

    local character = self.anima.character
    local characterMotors = {
        RightShoulder = character.Torso["Right Shoulder"],
        LeftShoulder = character.Torso["Left Shoulder"],
        RootJoint = character.HumanoidRootPart.RootJoint,
    }

    for name, rigMotor in rigMotors do
        local charMotor = characterMotors[name]
        if rigMotor and charMotor then
            rigMotor.Transform = charMotor.Transform
        end
    end
end

function ViewmodelManager:createFakeTool(tool)
    local asset = AssetsDealer.Get("Tools", tool.Name)
    if not asset then return end

    local toolComponents = self:getToolComponents(asset)
    if not toolComponents then return end

    local fakeTool = self:createFakeToolComponents(tool, toolComponents)
    self.fakeTools[tool:GetAttribute("ID")] = fakeTool

    fakeTool:hide()
    return fakeTool
end

function ViewmodelManager:getToolComponents(asset)
    local model = asset:FindFirstChild("Tool"):FindFirstChild("Model")
    local handle = model and model:FindFirstChild("Handle")
    local motor = asset:FindFirstChildOfClass("Motor6D")
    
    if not (model and handle and motor) then
        warn("Tool asset missing components")
        return nil
    end
    
    return { model = model, handle = handle, motor = motor }
end

function ViewmodelManager:createFakeToolComponents(tool, components)
    local clonedModel = components.model:Clone()
    clonedModel:ScaleTo(VIEWMODEL_SCALE)
    
    local folder = Instance.new("Folder")
    folder.Name = tool:GetAttribute("ID")
    folder.Parent = self.rig
    
    local correspondingLimb = self.rig[components.motor.Part0.Name]
    if not correspondingLimb then return end
    
    local clonedMotor = self:cloneMotor(components.motor, correspondingLimb, clonedModel.Handle)
    clonedModel.Parent = folder
    
    -- Add hide and show functions to the fakeTool
    local fakeTool = {
        model = clonedModel,
        handle = clonedModel.Handle,
        motor = clonedMotor,
        folder = folder, -- Store the folder for visibility control
        destroy = function(self) destroyFakeTool(self) end,
        hide = function(self)
            self.model.Parent = nil -- Hide the model by setting parent to nil
        end,
        show = function(self)
            self.model.Parent = self.folder -- Show the model by setting parent back to the folder
        end
    }
    
    return fakeTool
end

function ViewmodelManager:cloneMotor(originalMotor, part0, part1)
    local clonedMotor = originalMotor:Clone()
    clonedMotor.Part0 = part0
    clonedMotor.Part1 = part1
    clonedMotor.C0 = scaleCFrame(originalMotor.C0, VIEWMODEL_SCALE)
    clonedMotor.C1 = scaleCFrame(originalMotor.C1, VIEWMODEL_SCALE)
    clonedMotor.Parent = part0
    return clonedMotor
end

-- Singleton pattern
function ViewmodelManager:get()
    if not singleton then
        singleton = ViewmodelManager.new()
    end
    return singleton
end

function ViewmodelManager.Init()
    ViewmodelManager:get()
end

return ViewmodelManager