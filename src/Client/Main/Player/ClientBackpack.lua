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
    self.tools = Player:WaitForChild("Backpack")
    self.currentTool = nil :: Tool | nil

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
            self:unequip()
        else
            self:equip(index)
        end
    end)
end

function ClientBackpack:attachHandle()
    if not self.currentTool then warn("No current tool handle to attach") return end

    local itemAsset = ItemUtility.GetItemAsset(self.currentTool.Name)
    local handleMotor6D = itemAsset:FindFirstChildOfClass("Motor6D")

    if handleMotor6D then
        handleMotor6D = handleMotor6D:Clone()

        local currentToolHandle = self.currentTool.Model:FindFirstChild("Handle")
        handleMotor6D.Parent = self.currentTool 
        handleMotor6D.Part0 = Player.Character:FindFirstChild("Right Arm")
        handleMotor6D.Part1 = currentToolHandle
    else
        warn("No handle motor6D found in item asset")
    end
end

function ClientBackpack:equip(index: number)
    local tool = self:getToolFromIndex(index)
    if tool then
        self.events.ToolEquipped:Fire(tool,tool:GetAttribute("Index"))
        Player.Character.Humanoid:EquipTool(tool)
        self.currentTool = tool
        self:attachHandle()
        local LocalAnimator = Animator.Get("Local")
        LocalAnimator:play("Base","Hold")
    end
end

function ClientBackpack:unequip()
    self.events.ToolUnequipped:Fire(self.currentTool,self.currentTool:GetAttribute("Index"))
    Player.Character.Humanoid:UnequipTools()
    self.currentTool = nil
    local LocalAnimator = Animator.Get("Local")
    LocalAnimator:stop("Base","Hold")
end

function ClientBackpack.Init()
    if not ClientBackpack.LocalPlayerInstance then
        ClientBackpack.LocalPlayerInstance = ClientBackpack.new()
    end
end

return ClientBackpack