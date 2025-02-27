-- Services 
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Modules
local BaseBackpack = require(ReplicatedStorage.Classes.Bases.BaseBackpack)
local Signal = require(ReplicatedStorage.Packages.signal)
-- Variables
local ServerBackpack = setmetatable({}, {__index = BaseBackpack})
ServerBackpack.__index = ServerBackpack
ServerBackpack.Instances = {}
-- Network
local BackpackMiddleware = require(ReplicatedStorage.Middleware.MiddlewareManager).Get("Backpack")
local ToolUtility = require(ReplicatedStorage.Utility.ToolUtility)

ServerBackpack.ItemID = 0

function ServerBackpack.new(entity) --No longer takes a player arg, must take an entity.
    local self = setmetatable(BaseBackpack.new(entity), ServerBackpack) --Send the entity to the base class

    self.entity = entity
        
    self:setup()

    -- Subclass Events
    self.events.ToolEquipped = Signal.new()
    self.events.ToolUnequipped = Signal.new()
    
    ServerBackpack.Instances[entity.id] = self

    return self
end

function ServerBackpack:setup()
    self.entity.events.ChildAdded:Connect(function(child)
        if not child:IsA("Tool") then return end

        self.events.ToolEquipped:Fire(child)
    end)

    self.entity.events.ChildRemoved:Connect(function(child)
        if not child:IsA("Tool") then return end

        self.events.ToolUnequipped:Fire(child)
    end)

    -- Listen for tool equip requests from the client
    BackpackMiddleware.ReadToolEquip:Connect(function(player: Player, index: number)
        local ServerAnima = require(script.Parent.ServerAnima)
        local anima = ServerAnima.Get(player.UserId)
        local entity = anima.entity
        if entity.id ~= self.entity.id then return end
        
        self:equipTool(index)
    end)

    local function debugItems()
        warn("Debugging Items")
        self:addTool(ToolUtility.GetFromName("Brick", true))
        self:addTool(ToolUtility.GetFromName("Sword", true))    
    end

    debugItems()

    -- Delete when entity dies
    self.entity.events.Died:Connect(function()
        self:destroy()
    end)
end

function ServerBackpack:setToolNetworkOwnership(tool: Tool, owner: Player | nil)
    local Model = tool:FindFirstChild("Model")

    if not Model then error("Tool has no model") return end

    for _,instance in Model:GetDescendants() do
        if instance:IsA("BasePart") then
            instance:SetNetworkOwner(owner)
        end
    end
end

--[[ 
    On the server side equipping tools is just setting the current equipped tool and adding an attribute to the character
    physically equipping the tool is handled by the client side.
]]
function ServerBackpack:equipTool(index: number)
    local tool = self:getToolFromIndex(index)
    if tool then
        -- TODO: Tell all other clients the tool was equipped   
        self.equippedTool = tool
        -- Set EquippedTool attribute
        self.anima.entity.rig:SetAttribute("EquippedTool", tool.Name)
        tool:SetAttribute("Equipped", true)
    end
end

function ServerBackpack:addTool(tool: Tool)
    -- Hotbar number index
    local currentIndex = #self:getTools()
    local index = currentIndex + 1
    tool:SetAttribute("Index", index)

    -- Very important since i implement custom dropping.
    tool.CanBeDropped = false
    
    -- Put the tool in the backpack
    tool.Parent = self.tools

    ServerBackpack.ItemID += 1
    tool:SetAttribute("ID", ServerBackpack.ItemID)
    tool:SetAttribute("Owner", self.entity.id)
end

function ServerBackpack:removeTool(param: Tool | number)
    if typeof(param) == "number" then
        local index = param
        local tool = self:getToolFromIndex(index)
        if tool then
            BackpackMiddleware.SendToolRemoved:Fire(index)
            tool:Destroy()
        end
    else
        -- Tool
        local index = param:GetAttribute("Index")
        BackpackMiddleware.SendToolRemoved:Fire(index)
        param:Destroy()
    end
end

function ServerBackpack:removeAllTools()
    for _,tool in self:getTools() do
        self:removeTool(tool)
    end
end

function ServerBackpack:dropTool(index: number)
    local tool = self:getToolFromIndex(index)
    if tool then
        BackpackMiddleware.SendToolRemoved:Fire(index)
        tool.Parent = workspace
        self:setToolNetworkOwnership(tool, nil)
    end
end

function ServerBackpack:destroy()
    self:destroyBase()
    table.clear(self)
end

function ServerBackpack.Init()
    Players.PlayerAdded:Connect(function(player: Player)
        local entity = require(script.Parent.ServerAnima).new(player).entity
        ServerBackpack.new(entity) -- Pass the entity
    end)

    for _, player in pairs(Players:GetPlayers()) do
        local entity = require(script.Parent.ServerAnima).new(player).entity
        ServerBackpack.new(entity) -- Pass the entity
    end
end

return ServerBackpack