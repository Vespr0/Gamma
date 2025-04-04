local ViewmodelManager = {}
ViewmodelManager.__index = ViewmodelManager

-- Dependencies
ViewmodelManager.Dependencies = { "ClientAnima" }

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
local ClientAnima = require(script.Parent.Parent.Player.ClientAnima) -- No need to get instance here
local ClientEntity = require(script.Parent.Parent.Entities.ClientEntity)
local TypeEntity = require(ReplicatedStorage.Types.TypeEntity)
local Loading = require(ReplicatedStorage.Utility.Loading)
-- Constants
local VISIBLE_LIMBS = { Game.Limbs.RightArm, Game.Limbs.LeftArm }
local VIEWMODEL_WHITELIST = { Game.Limbs.Torso, Game.Limbs.RightArm, Game.Limbs.LeftArm, Game.Limbs.RightLeg, "HumanoidRootPart", "Meshes" }
local CAMERA = Workspace.CurrentCamera
local VIEWMODEL_SCALE = 1

-- Variables
ViewmodelManager.Singleton = nil

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

function ViewmodelManager.new(entity: TypeEntity.ClientEntity)
    assert(entity, "Entity is nil!")

    local self = setmetatable({}, ViewmodelManager)
    
    self.anima = ClientAnima:get() -- should be local to player
    self.entity = entity

    self.visible = true
    self.fakeTools = {}
    self.currentFakeTool = nil
    self.rig = nil
    self.events = { NewRig = Signal.new() }
    self.trove = Trove.new()

    -- Wait for backpack using the Loading utility
    task.spawn(function()
        local backpack, err = Loading.waitFor(function()
            local ClientBackpack = require(script.Parent.Parent.Entities.ClientBackpack)
            return ClientBackpack.LocalPlayerInstance
        end, 5) 
        
        if not backpack then
            warn("Failed to get backpack:", err)
            return
        end

        self.backpack = backpack
        self:setup()
    end)

    ViewmodelManager.Singleton = self

    return self
end

function ViewmodelManager:toggleFakeToolVisibility(fakeTool,visible: boolean)
    fakeTool.model.Parent = visible and self.rig or nil
end

function ViewmodelManager:setup()
    self:createNewRig()
    self:setupToolEvents()

    self.trove:Connect(self.entity.events.Died, function()
        self:destroy()
    end)
end

function ViewmodelManager:setupToolEvents()
    for _, tool in self.backpack:getTools() do
        self:createFakeTool(tool)
    end
    self.backpack.events.ToolAdded:Connect(function(tool)
        self:createFakeTool(tool)
    end)

    self.backpack.events.ToolRemoved:Connect(function(index)
        print(index)
        local tool = self.backpack:getToolFromIndex(index)

        if not tool then return end -- TODO may cause ambiguous behaivor

        local ID = tool:GetAttribute("ID")
        for otherID, fakeTool in self.fakeTools do
            if otherID == ID then
                destroyFakeTool(fakeTool)
                table.remove(self.fakeTools, ID)
            end
        end
    end)

    self.backpack.events.ToolEquip:Connect(function(tool)
        local ID = tool:GetAttribute("ID")
        for otherID, fakeTool in self.fakeTools do
            if otherID == ID then
                fakeTool:show()
                self.currentFakeTool = fakeTool
            else
                fakeTool:hide()
            end
        end
    end)

    self.backpack.events.ToolUnequip:Connect(function(tool)
        local ID = tool:GetAttribute("ID")
        self.fakeTools[ID]:hide()
        self.currentFakeTool = nil
    end)
end

function ViewmodelManager:createNewRig()
    self:cleanupExistingRig()
    local character = self.entity.rig

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
			child.Transparency = 0.1	
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
    self.trove:Connect(RunService.RenderStepped, function(deltaTime)
        self:updateRigPosition()
        self:syncMotors()
    end)
end

function ViewmodelManager:updateRigPosition()
    if not self.rig then return end
    local cameraCFrame = CAMERA.CFrame
    local origin = cameraCFrame + (cameraCFrame.LookVector/2) - (cameraCFrame.UpVector * (VIEWMODEL_SCALE+1/2))
    self.rig:PivotTo(origin)
end

function ViewmodelManager:syncMotors()
    local rigMotors = {
        RightShoulder = self.rig.Torso["Right Shoulder"],
        LeftShoulder = self.rig.Torso["Left Shoulder"],
        RootJoint = self.rig.HumanoidRootPart.RootJoint,
        Handle = self.rig:FindFirstChild("Handle") , -- May be nil and that's ok
    }

    local character = self.entity.rig
    local characterMotors = {
        RightShoulder = character.Torso["Right Shoulder"],
        LeftShoulder = character.Torso["Left Shoulder"],
        RootJoint = character.HumanoidRootPart.RootJoint,
        Handle = character:FindFirstChild("Handle")
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
    local rig = asset:FindFirstChild("Rig")
    local model = rig:FindFirstChildOfClass("Tool"):FindFirstChild("Model")
    local handle = model and model:FindFirstChild("Handle")
    local motor = rig:FindFirstChildOfClass("Motor6D")
    
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
            clonedMotor.Parent = nil
        end,
        show = function(self)
            if self.folder and self.folder:IsDescendantOf(game) then -- Ensure folder is valid
                self.model.Parent = self.folder
                clonedMotor.Parent = self.folder.Parent
            else
                warn("Cannot show fake tool: folder is invalid or destroyed.")
            end
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

function ViewmodelManager:destroy()
    for _, fakeTool in self.fakeTools do
        destroyFakeTool(fakeTool)
    end
    if self.rig then
        self.rig:Destroy()
    end
    if self.trove then
        self.trove:Destroy()
    end
end

function ViewmodelManager.Init()
    if ClientEntity.LocalPlayerInstance then
       ViewmodelManager.new(ClientEntity.LocalPlayerInstance)
    end
    ClientEntity.GlobalAdded:Connect(function(entity)
        if not entity.isLocalPlayerInstance then return end
        ViewmodelManager.new(entity)
    end)
end

return ViewmodelManager