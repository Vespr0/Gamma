local Motor6DManager = {}
Motor6DManager.__index = Motor6DManager

-- Services
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
-- Modules
local TypeRig = require(game:GetService("ReplicatedStorage").Types.TypeRig)
local Trove = require(game:GetService("ReplicatedStorage").Packages.trove)
local EntityUtility = require(game:GetService("ReplicatedStorage").Utility.Entity)
-- Motor6DModules
local Motor6DModules = script.Parent.Motor6DModules
Motor6DManager.Modules = {} :: {[string]: any}
for _,module in Motor6DModules:GetChildren() do
    Motor6DManager.Modules[module.Name] = require(module)
end
-- Variables
local LocalPlayer = game:GetService("Players").LocalPlayer

-- Types
export type Bias = {
    offset: CFrame,
    angles: CFrame
}
export type DualBias = {
    C0: Bias,
    C1: Bias
}

-- Functions
local function lerpBias(current: Bias, target: Bias, smoothness: number)
    if current.offset then
        current.offset = current.offset:Lerp(target.offset, smoothness)
    end
    if current.angles then
        current.angles = current.angles:Lerp(target.angles, smoothness)
    end
end

function Motor6DManager.new(rig: TypeRig.Rig)
    local self = setmetatable({}, Motor6DManager)

    self.rig = rig or error("Rig is nil")
    self.isLocalPlayerInstance = rig == LocalPlayer.Character
    self.motors = {}
    self.defaults = {}

    self.connections = {}
    self.modules = {}
    
    self.dualBiases = {} 
    self.trove = Trove.new()

    self:setup()

    return self
end

function Motor6DManager:getModule(moduleName: string)
    return self.connections[moduleName]
end

function Motor6DManager:setup()
    self:setupMotors()
    self:connectMotorModules()

    self.trove:Connect(RunService.RenderStepped, function(deltaTime: number)
        self:step(deltaTime)
    end)
end

function Motor6DManager:setupMotors()
    for _,motor in self.rig:GetDescendants() do
        if motor:IsA("Motor6D") then
            self.motors[motor.Name] = motor
            self.dualBiases[motor.Name] = {}
            self.defaults[motor.Name] = {}
            self.defaults[motor.Name].C0 = motor.C0
            self.defaults[motor.Name].C1 = motor.C1
            -- TODO: Potentially troublesome as based on the state of the rig the defaults can be different.
        end
    end
end

function Motor6DManager:connectMotorModules()
    for name,module in Motor6DManager.Modules do
        local requiredModule = module.Connect(self,self.rig,self.motors)
        self.connections[name] = requiredModule.connection
        self.modules[name] = requiredModule
    end
end

function Motor6DManager:addBias(motorName: string, biasName: string, biasType: "C0" | "C1", bias: Bias, smoothness: number)
    -- Exit if rig is destroyed
    if not EntityUtility.IsAlive(self.rig) then return end
    -- Prevent adding bias if it's already active or being removed
    assert(self.dualBiases[motorName], `Motor6D "{motorName}" is nil`)

    -- Remove any existing bias to reset state
    self:removeBias(motorName, biasName)

    self.dualBiases[motorName][biasName] = { status = "active" } -- Set as active

    if smoothness then
        task.spawn(function()
            local current = { offset = Vector3.new(), angles = CFrame.Angles(0, 0, 0) }
            self.dualBiases[motorName][biasName][biasType] = current

            while self.dualBiases[motorName][biasName] and EntityUtility.IsAlive(self.rig) do
                local deltaTime = RunService.RenderStepped:Wait()
                lerpBias(current, bias, smoothness * deltaTime)
                self.dualBiases[motorName][biasName][biasType] = current
                if self.dualBiases[motorName][biasName].status ~= "active" then
                    break
                end
            end
        end)
    else
        self.dualBiases[motorName][biasName][biasType] = bias
    end
end

function Motor6DManager:removeBias(motorName: string, biasName: string, smoothness: number)
    -- Exit if rig is destroyed
    if not EntityUtility.IsAlive(self.rig) then return end
    -- Exit if there is no bias or if already removing
    if not self.dualBiases[motorName] or not self.dualBiases[motorName][biasName] or self.dualBiases[motorName][biasName].status == "removing" then
        return
    end

    self.dualBiases[motorName][biasName].status = "removing" -- Mark as removing

    if smoothness then
        for biasType, bias in self.dualBiases[motorName][biasName] do
            if typeof(bias) ~= "table" then continue end

            local current = bias
            local goal = { offset = Vector3.new(), angles = CFrame.Angles(0, 0, 0) }

            task.spawn(function()
                while self.dualBiases[motorName][biasName] and self.dualBiases[motorName][biasName].status == "removing" do

                    local deltaTime = RunService.RenderStepped:Wait()
                    lerpBias(current, goal, smoothness * deltaTime)

                    -- Remove the bias when it reaches zero
                    if current.offset == goal.offset and current.angles == goal.angles then
                        self.dualBiases[motorName][biasName] = nil
                        break
                    end
                end
            end)
        end
    else
        self.dualBiases[motorName][biasName] = nil
    end
end

function Motor6DManager:step(deltaTime: number)
    -- Skip stepping if rig is destroyed
    if not EntityUtility.IsAlive(self.rig) then return end
    for motorName,motor in self.motors do
        -- Set defaults first
        motor.C0 = self.defaults[motorName].C0
        motor.C1 = self.defaults[motorName].C1

        local BiasC0 = CFrame.new()
        local BiasC1 = CFrame.new()
        for biasName, dualBias: DualBias in self.dualBiases[motorName] do
            if dualBias.C0 then
                if dualBias.C0.offset then
                    BiasC0 += dualBias.C0.offset
                end
                if dualBias.C0.angles then
                    BiasC0 *= dualBias.C0.angles
                end
            end
            if dualBias.C1 then
                if dualBias.C1.offset then
                    BiasC1 += dualBias.C1.offset
                end
                if dualBias.C1.angles then
                    BiasC1 *= dualBias.C1.angles
                end
            end
        end        

        local targetC0 = self.defaults[motorName].C0 * BiasC0
        local targetC1 = self.defaults[motorName].C1 * BiasC1

        motor.C0 = targetC0
        motor.C1 = targetC1
    end
end

function Motor6DManager:checkMotors(...)
    for _,motorName in {...} do
        if not self.motors[motorName] then
            error(`Motor6D "{motorName}" is nil`)
        end
    end
end

function Motor6DManager:destroy()
    for _,connection in self.connections do
        connection:Disconnect()
    end
    self.trove:Destroy()
    table.clear(self)
end

return Motor6DManager
