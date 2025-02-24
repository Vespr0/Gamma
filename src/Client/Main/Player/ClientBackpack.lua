-- Services 
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local Inputs = require(script.Parent.Parent.Input.Inputs)
local HotbarInput = Inputs.GetModule("Hotbar")
local BaseBackpack = require(ReplicatedStorage.Classes.Bases.BaseBackpack)
-- Variables
local Player = Players.LocalPlayer
-- Class
local ClientBackpack = setmetatable({}, {__index = BaseBackpack})
ClientBackpack.__index = ClientBackpack
ClientBackpack.Instances = {}
ClientBackpack.GlobalAdded = Signal.new()
ClientBackpack.LocalPlayerInstance = nil
-- Network
local BackpackMiddleware = require(ReplicatedStorage.Middleware.MiddlewareManager).Get("Backpack")
local ItemUtility = require(ReplicatedStorage.Utility.ItemUtility)
local Animator = require(script.Parent.Parent.Entities.Animator)

function ClientBackpack.new()
    local self = setmetatable(BaseBackpack.new(Player), ClientBackpack)

    -- Subclass Events
    self.events.ToolAdded = Signal.new()
    self.events.ToolRemoved = Signal.new()
    self.events.ToolEquipped = Signal.new()
    self.events.ToolUnequipped = Signal.new()

    self:setup()

    return self
end

function ClientBackpack:setup()
    BackpackMiddleware.ReadToolAdded:Connect(function(index: number)
        self.events.ToolAdded:Fire(index)
    end)

    BackpackMiddleware.ReadToolRemoved:Connect(function(index: number)
        self.events.ToolRemoved:Fire(index)
    end)

    HotbarInput.Event:Connect(function(incremental: boolean, index: number)
        if incremental then
            -- Incremental index when using a controller
            local currentIndex = self.currentTool and self.currentTool:GetAttribute("Index") or 1
            index = currentIndex + 1
        end
        
        if self.currentTool and index == self.currentTool:GetAttribute("Index") then
            self:unequipTool()
        else
            if self.currentTool then
                self:unequipTool()
            end
            self:equipTool(index)
        end
    end)
end

function ClientBackpack:attachHandle(dummyTool: Tool)
    if not dummyTool then warn("No dummy tool provided") return end

    local itemAsset = ItemUtility.GetItemAsset(dummyTool.Name)
    local handleMotor6D = itemAsset:FindFirstChildOfClass("Motor6D")

    if handleMotor6D then
        handleMotor6D = handleMotor6D:Clone()

        local currentToolHandle = dummyTool.Model:FindFirstChild("Handle")
        handleMotor6D.Parent = dummyTool
        handleMotor6D.Part0 = Player.Character:FindFirstChild("Right Arm")
        handleMotor6D.Part1 = currentToolHandle
    else
        warn("No handle motor6D found in item asset")
    end
end

function ClientBackpack:equipTool(index: number)
    if not Player.Character then error("Player has no character") return end

    local tool = self:getToolFromIndex(index)
    if tool then
        -- Remove handle (if present)
        local existingHandle = tool:FindFirstChild("Handle")
        if existingHandle then existingHandle:Destroy() end
        -- Tool equipped local event
        self.events.ToolEquipped:Fire(tool,tool:GetAttribute("Index"))
        -- Send to server
        BackpackMiddleware.SendToolEquip:Fire(tool:GetAttribute("Index"))
        -- Dummy tool
        local dummyTool = tool:Clone()
        dummyTool.Parent = Player.Character
        self.currentTool = tool
        -- Attach handle
        self:attachHandle(dummyTool)
        -- Play hold animation
        local LocalAnimator = Animator.Get("Local")
        LocalAnimator:play("Base","Hold")
    end
end

function ClientBackpack:unequipTool()
    self.events.ToolUnequipped:Fire(self.currentTool,self.currentTool:GetAttribute("Index"))
    BackpackMiddleware.SendToolUnequip:Fire()
    -- Remove dummy tool
    local dummyTool = Player.Character:FindFirstChildOfClass("Tool")
    if dummyTool then
        dummyTool:Destroy()
    end
    self.currentTool = nil
    -- Stop hold animation
    local LocalAnimator = Animator.Get("Local")
    LocalAnimator:stop("Base","Hold")
end

function ClientBackpack.Init()
    if not ClientBackpack.LocalPlayerInstance then
        ClientBackpack.LocalPlayerInstance = ClientBackpack.new()
    end
end

return ClientBackpack