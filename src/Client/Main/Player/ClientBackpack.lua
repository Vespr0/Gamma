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
ClientBackpack.LocalPlayerInstance = nil -- TODO: remove. Keep track of every backpack by entity id instead?
-- Network
local BackpackMiddleware = require(ReplicatedStorage.Middleware.MiddlewareManager).Get("Backpack")
local ToolUtility = require(ReplicatedStorage.Utility.ToolUtility)
local Animator = require(script.Parent.Parent.Entities.Animator)

function ClientBackpack.new(entity) -- no longer takes a player as an arg, must take an entity.
    local self = setmetatable(BaseBackpack.new(entity), ClientBackpack) -- send the entity to the base class

    self:setup()

    return self
end

function ClientBackpack:setup()
    if self.entity.isLocalPlayer then 
        ClientBackpack.LocalPlayerInstance = self
        self.isLocalPlayerInstance = true
    end

    BackpackMiddleware.ReadToolAdded:Connect(function(entityID: number, index: number)
        if entityID ~= self.entity.id then return end
        self.events.ToolAdded:Fire(index)
    end)

    BackpackMiddleware.ReadToolRemoved:Connect(function(entityID: number, index: number)
        if entityID ~= self.entity.id then return end
        self.events.ToolRemoved:Fire(index)
    end)

    -- For local player add hotbar input connection
    if self.isLocalPlayerInstance then
        HotbarInput.Event:Connect(function(incremental: boolean, index: number)
            if incremental then
                -- Incremental index when using a controller
                local currentIndex = self.equippedTool and self.equippedTool:GetAttribute("Index") or 1
                index = currentIndex + 1
            end
            
            if self.equippedTool and index == self.equippedTool:GetAttribute("Index") then
                self:unequipTool()
            else
                if self.equippedTool then
                    self:unequipTool()
                end
                self:equipTool(index)
            end
        end)
    end
end

function ClientBackpack:attachHandle(dummyTool: Tool)
    if not dummyTool then warn("No dummy tool provided") return end

    local itemAsset = ToolUtility.GetAsset(dummyTool.Name)
    local handleMotor6D = itemAsset:FindFirstChildOfClass("Motor6D")

    if handleMotor6D then
        handleMotor6D = handleMotor6D:Clone()

        local equippedToolHandle = dummyTool.Model:FindFirstChild("Handle")
        handleMotor6D.Parent = dummyTool
        handleMotor6D.Part0 = Player.Character:FindFirstChild("Right Arm")
        handleMotor6D.Part1 = equippedToolHandle
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
        self.equippedTool = tool
        -- Attach handle
        self:attachHandle(dummyTool)
        -- Play hold animation
        local LocalAnimator = Animator.Get("Local")
        LocalAnimator:play("Base","Hold")
        warn("Equipped tool: "..tool.Name)
    end
end

function ClientBackpack:unequipTool()
    self.events.ToolUnequipped:Fire(self.equippedTool,self.equippedTool:GetAttribute("Index"))
    BackpackMiddleware.SendToolUnequip:Fire()
    -- Remove dummy tool
    local dummyTool = Player.Character:FindFirstChildOfClass("Tool")
    if dummyTool then
        dummyTool:Destroy()
    end
    self.equippedTool = nil
    -- Stop hold animation
    local LocalAnimator = Animator.Get("Local")
    LocalAnimator:stop("Base","Hold")
end

return ClientBackpack