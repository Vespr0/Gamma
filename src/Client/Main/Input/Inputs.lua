local Inputs = {}
Inputs.__index = Inputs

-- Services 
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
-- Variables
local Modules = script.Parent.Modules:GetChildren()
local singleton = nil

local function setupModules()
    for _,module in Modules do
        if module:IsA("ModuleScript") then
            require(module).Start(Inputs:get())
        end
    end
end

function Inputs.IsValidKey(validKeys: {Enum.KeyCode},key: Enum.KeyCode)
	for _,validKey in validKeys do
        if validKey == key then
            return true
        end
    end
    return false
end

function Inputs.GetModule(name)
    -- Remove Input from name
    return require(script.Parent.Modules[name.."Input"])
end

function Inputs.new()
    if singleton then error("Inputs: Singleton already exists.") end
    local self = setmetatable({}, Inputs)

    self.isMobile = UserInputService.TouchEnabled
    self.isPC = not self.isMobile
    self.isController = UserInputService.GamepadEnabled

    self.events = {
        InputBegan = Signal.new(),
        ProcessedInputBegan = Signal.new(),
        InputEnded = Signal.new(),
        ProcessedInputEnded = Signal.new()
    }

    self:setup()

    singleton = self
    return self
end

function Inputs:get()
    if not singleton then
        singleton = Inputs.new()
    end
    return singleton
end

function Inputs:setupEvents()
    UserInputService.InputBegan:Connect(function(input,gameProcessed)
        self.events.ProcessedInputBegan:Fire(input)
        if gameProcessed then return end
        self.events.InputBegan:Fire(input)
    end)
    UserInputService.InputEnded:Connect(function(input,gameProcessed)
        self.events.ProcessedInputEnded:Fire(input)
        if gameProcessed then return end
        self.events.InputEnded:Fire(input)
    end)
end

function Inputs:setup()
   self:setupEvents()
end

function Inputs.Init() 
    Inputs:get() 
    setupModules() 
end

return Inputs
