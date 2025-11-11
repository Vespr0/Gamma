-- ProceduralAnimationController.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local trove = require(ReplicatedStorage.Packages.trove)

local ProceduralAnimationController = {}
ProceduralAnimationController.__index = ProceduralAnimationController

function ProceduralAnimationController.new(rig)
    local self = setmetatable({}, ProceduralAnimationController)

    assert(rig:IsA("Model"), "Rig must be a model")
    self.rig = rig
    self.humanoid = rig:FindFirstChildOfClass("Humanoid")
    assert(self.humanoid, "Rig must have a Humanoid")
    assert(rig:FindFirstChild("HumanoidRootPart"), "Rig must have a HumanoidRootPart")

    self.trove = trove.new()
    self.components = {}
    self.motors = {}

    -- Motor Indexing
    for _, child in ipairs(rig:GetDescendants()) do
        if child:IsA("Motor6D") then
            self.motors[child.Name] = child
        end
    end

    -- Bind Update Loop
    self.trove:Connect(RunService.RenderStepped, function(dt)
        self:_onUpdate(dt)
    end)

    return self
end

function ProceduralAnimationController:LoadComponent(componentModule, params)
    -- The module is passed directly, not a path
    local componentInstance = componentModule.new(self, params)
    self.components[componentModule.Name] = componentInstance
    self.trove:Add(componentInstance)
    return componentInstance
end

function ProceduralAnimationController:GetComponent(componentName)
    return self.components[componentName]
end

function ProceduralAnimationController:Destroy()
    self.trove:Destroy()

    for _, motor in pairs(self.motors) do
        if motor and motor.Parent then
            motor.Transform = CFrame.new()
        end
    end

    self.rig = nil
    self.humanoid = nil
    self.motors = nil
    self.components = nil
end

function ProceduralAnimationController:_onUpdate(deltaTime)
    local combinedOffsets = {}

    for _, component in pairs(self.components) do
        local componentOffsets = component:Update(deltaTime)
        for motorName, offsetCFrame in pairs(componentOffsets) do
            combinedOffsets[motorName] = (combinedOffsets[motorName] or CFrame.new()) * offsetCFrame
        end
    end

    for motorName, motor in pairs(self.motors) do
        if combinedOffsets[motorName] and motor and motor.Parent then
            local animationTransform = motor.Transform
            motor.Transform = animationTransform * combinedOffsets[motorName]
        end
    end
end

return ProceduralAnimationController
