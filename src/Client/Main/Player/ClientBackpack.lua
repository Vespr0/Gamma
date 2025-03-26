-- Services 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local Inputs = require(script.Parent.Parent.Input.Inputs)
local HotbarInput = Inputs.GetModule("Hotbar")
local BaseBackpack = require(ReplicatedStorage.Classes.Bases.BaseBackpack)
local ToolUtility = require(ReplicatedStorage.Utility.ToolUtility)
local EntityUtility = require(ReplicatedStorage.Utility.Entity)
local ClientAbilities = require(script.Parent.ClientAbilities)

-- Class
local ClientBackpack = setmetatable({}, {__index = BaseBackpack})
ClientBackpack.__index = ClientBackpack
ClientBackpack.Instances = {}
ClientBackpack.GlobalAdded = Signal.new()
ClientBackpack.LocalPlayerInstance = nil

-- Network
local BackpackMiddleware = require(ReplicatedStorage.Middleware.MiddlewareManager).Get("Backpack")

function ClientBackpack.new(entity)
    if not entity then error("No entity provided") return end
    
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

    if self.isLocalPlayerInstance then
        -- For local player add hotbar input connection
        HotbarInput.Event:Connect(function(incremental: boolean, index: number)
            if incremental then
                -- Incremental index when using a controller
                local currentIndex = self.equippedTool and self.equippedTool:GetAttribute("Index") or 1
                index = currentIndex + 1
            end
            
            if self.equippedTool and index == self.equippedTool:GetAttribute("Index") then
                self:unequipTool()
                -- Send unequip to server
                BackpackMiddleware.SendToolUnequip:Fire()
            else
                if self.equippedTool then
                    self:unequipTool()
                    -- Send unequip to server
                    BackpackMiddleware.SendToolUnequip:Fire()
                end
                self:equipTool(index)
                -- Send equip to server
                BackpackMiddleware.SendToolEquip:Fire(index)
            end
        end)
    else
        -- For client entities that are not the local player's the server will send events
        BackpackMiddleware.ReadToolEquip:Connect(function(entityID: number, index: number)
            print("Equipping tool",index,"for entity",entityID)
            if entityID ~= self.entity.id then return end
            print(entityID,self.entity.id,self.entity.rig)
            self:equipTool(index)
        end)

        BackpackMiddleware.ReadToolUnequip:Connect(function(entityID: number)
            if entityID ~= self.entity.id then return end
            self:unequipTool()
        end)
    end

    -- Connect client abilities instance
    self.abilities = ClientAbilities.new(self)

    ClientBackpack.GlobalAdded:Fire(self)
    ClientBackpack.Instances[self.entity.id] = self
end

function ClientBackpack:attachHandle(dummyTool)
    if not dummyTool then warn("No dummy tool provided") return end

    local itemAsset = ToolUtility.GetAsset(dummyTool.Name)
    local itemAssetRig = itemAsset:FindFirstChild("Rig")
    local handleMotor6D = itemAssetRig:FindFirstChildOfClass("Motor6D")

    if handleMotor6D then
        handleMotor6D = handleMotor6D:Clone()

        local equippedToolHandle = dummyTool.Model:FindFirstChild("Handle")
        handleMotor6D.Parent = self.entity.rig
        handleMotor6D.Part0 = self.entity.rig:FindFirstChild("Right Arm")
        handleMotor6D.Part1 = equippedToolHandle
    else
        warn("No handle motor6D found in item asset")
    end
end

function ClientBackpack:getDummyTool()
    return self.entity.rig:FindFirstChildOfClass("Tool")
end

function ClientBackpack:equipTool(index: number)
    if not EntityUtility.IsAlive(self.entity.rig) then return end

    local tool = self:getToolFromIndex(index)
    if tool then
        -- Remove handle (if present)
        local existingHandle = tool:FindFirstChild("Handle")
        if existingHandle then existingHandle:Destroy() end
        -- Tool equipped local event
        self.events.ToolEquip:Fire(tool,tool:GetAttribute("Index"))
        -- Dummy tool
        local dummyTool = tool:Clone()
        dummyTool.Parent = self.entity.rig
        self.equippedTool = tool
        self.equippedToolID = tool:GetAttribute("ID")
        -- Attach handle
        self:attachHandle(dummyTool)
        -- Play hold animation
        -- self.entity.animator:play("Base","Hold")
        print("Equipped tool: "..tool.Name,"Entity ID: "..self.entity.id)
    end
end

function ClientBackpack:unequipTool()
    if not EntityUtility.IsAlive(self.entity.rig) then return end

    self.events.ToolUnequip:Fire(self.equippedTool,self.equippedTool:GetAttribute("Index"))
    -- Remove dummy tool
    local dummyTool = self.entity.rig:FindFirstChildOfClass("Tool")
    if dummyTool then
        dummyTool:Destroy()
    end
    self.equippedTool = nil
    -- Stop hold animation
    -- self.entity.animator:stop("Base","Hold")
end

return ClientBackpack