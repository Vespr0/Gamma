local Camera = {}
Camera.__index = Camera

-- Services
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local Trove = require(ReplicatedStorage.Packages.trove)
local Signal = require(ReplicatedStorage.Packages.signal)
local FirstPerson = require(script.Parent.FirstPerson)
local ThirdPerson = require(script.Parent.ThirdPerson)

function Camera.new(anima)
    local self = setmetatable({}, Camera)
    assert(anima, "anima is nil")

    -- Basic Properties
    self.anima = anima
    self.camera = workspace.CurrentCamera
    self.trove = Trove.new()
    self.offsets = {}

    -- Events
    self.events = {
        onModeChanged = Signal.new()
    }

    self.modes = {
        FirstPerson = FirstPerson.new(self),
        ThirdPerson = ThirdPerson.new(self)
    }

    self:setup()

    return self
end

function Camera:sumOffsets()
    local sum = Vector3.zero
    for _, offset in pairs(self.offsets) do
        sum = sum + offset
    end
    return sum
end

function Camera:setup()
    self:setMode("ThirdPerson")

    -- Connect RenderStepped to update the camera behavior
    self.trove:Connect(RunService.RenderStepped, function()
        local modeHandler = self.modes[self.mode]
        if modeHandler and modeHandler.step then
            modeHandler:step()
        else
            warn("Invalid mode or missing step function.")
        end
        self.offset = self:sumOffsets()
    end)
end

function Camera:setMode(mode)
    print("Setting camera mode:", mode)
    if self.modes[mode] then
        self.mode = mode
        self.modes[mode]:set()
        self.events.onModeChanged:Fire(mode)
    else
        warn("Attempted to set an invalid camera mode:", mode)
    end
end

function Camera:destroy()
    -- Clean up all resources and events
    self.trove:Destroy()
    for _, event in pairs(self.events) do
        if typeof(event) == "Instance" and event.Destroy then
            event:Destroy()
        end
    end
end

return Camera
