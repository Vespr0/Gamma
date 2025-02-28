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

function ServerBackpack.new(entity) 
    local self = setmetatable(BaseBackpack.new(entity), ServerBackpack) 

    self.entity = entity
    self.player = Players:GetPlayerFromCharacter(entity.rig) or nil :: Player?
        
    self:setup()

    -- Subclass Events
    self.events.ToolEquip = Signal.new()
    self.events.ToolUnequip = Signal.new()
    
    ServerBackpack.Instances[entity.id] = self

    return self
end

function ServerBackpack:setup()
    self.entity.events.ChildAdded:Connect(function(child)
        if not child:IsA("Tool") then return end

        self.events.ToolEquip:Fire(child)
    end)

    self.entity.events.ChildRemoved:Connect(function(child)
        if not child:IsA("Tool") then return end

        self.events.ToolUnequip:Fire(child)
    end)

    -- Listen for tool equip requests from the client
    BackpackMiddleware.ReadToolEquip:Connect(function(player: Player, index: number)
        local ServerAnima = require(script.Parent.ServerAnima)
        local anima = ServerAnima.Get(player.UserId)
        local entity = anima.entity
        if entity.id ~= self.entity.id then return end
        
        self:equipTool(index, player)
    end)

    -- Listen for tool unequip requests from the client
    BackpackMiddleware.ReadToolUnequip:Connect(function(player: Player)
        local ServerAnima = require(script.Parent.ServerAnima)
        local anima = ServerAnima.Get(player.UserId)
        local entity = anima.entity
        if entity.id ~= self.entity.id then return end
        
        self:unequipTool(player)
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
function ServerBackpack:equipTool(index: number, player: Player | nil)
    local tool = self:getToolFromIndex(index)
    if tool then
        -- TODO: Tell all other clients the tool was equipped   
        self.equippedTool = tool
        -- Set EquippedTool attribute
        self.entity.rig:SetAttribute("EquippedTool", tool.Name)

        -- Tell all other clients
        local blacklistedUserId = player and player.UserId or nil
        BackpackMiddleware.SendToolEquip:Fire(self.entity.id,index,blacklistedUserId)

        tool:SetAttribute("Equipped", true)
    end
end

function ServerBackpack:unequipTool(player: Player | nil)
    local tool = self.equippedTool
    if tool then
        -- TODO: Tell all other clients the tool was unequipped
        self.equippedTool = nil
        -- Set EquippedTool attribute
        self.entity.rig:SetAttribute("EquippedTool", nil)

        -- Tell all other clients
        local blacklistedUserId = player and player.UserId or nil
        BackpackMiddleware.SendToolUnequip:Fire(self.entity.id,blacklistedUserId)
        
        tool:SetAttribute("Equipped", false)
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
    warn(tool:GetFullName())

    ServerBackpack.ItemID += 1
    tool:SetAttribute("ID", ServerBackpack.ItemID)
    tool:SetAttribute("Owner", self.entity.id)
end

function ServerBackpack:removeTool(param: Tool | number)
    if typeof(param) == "number" then
        local index = param
        local tool = self:getToolFromIndex(index)
        if tool then
            BackpackMiddleware.SendToolRemoved:Fire(self.entity.id,index)
            tool:Destroy()
        end
    else
        -- Tool
        local index = param:GetAttribute("Index")
        BackpackMiddleware.SendToolRemoved:Fire(self.entity.id,index)
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
        BackpackMiddleware.SendToolRemoved:Fire(self.entity.id,index)
        tool.Parent = workspace
        self:setToolNetworkOwnership(tool, nil)
    end
end

function ServerBackpack:destroy()
    self:destroyBase()
    table.clear(self)
end

function ServerBackpack.Init()
    local ServerEntity = require(script.Parent.Parent.Entities.ServerEntity)
    ServerEntity.GlobalAdded:Connect(function(entity)
        ServerBackpack.new(entity)
    end)
end

return ServerBackpack