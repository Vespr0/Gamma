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
local ItemUtility = require(ReplicatedStorage.Utility.ItemUtility)

ServerBackpack.ItemID = 0

function ServerBackpack.new(player: Player)
    local self = setmetatable(BaseBackpack.new(player), ServerBackpack)

    self.anima = require(script.Parent.ServerAnima).new(player)

    self:listen()

    -- Subclass Events
    self.events.ToolEquipped = Signal.new()
    self.events.ToolUnequipped = Signal.new()
    
    return self
end

function ServerBackpack:listen()
    self.anima.events.CharacterChildAdded:Connect(function(child)
        if not child:IsA("Tool") then return end

        self.events.ToolEquipped:Fire(child)
    end)

    self.anima.events.CharacterChildRemoved:Connect(function(child)
        if not child:IsA("Tool") then return end

        self.events.ToolUnequipped:Fire(child)
    end)

    local function debugItems()
        warn("Debugging Items")
        self:addTool(ItemUtility.GetToolFromName("Brick", true))
        self:addTool(ItemUtility.GetToolFromName("Sword", true))    
    end
    --debugItems()
    self.anima.events.CharacterAdded:Connect(function()
        debugItems()
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

    --self:setToolNetworkOwnership(tool, self.player) TODO: Gives problems because tool isnt in workspace
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
        ServerBackpack.new(player)
    end)

    for _, player in pairs(Players:GetPlayers()) do
        ServerBackpack.new(player)
    end

    Players.PlayerRemoving:Connect(function(player: Player)
        local instance = ServerBackpack.Instances[player.UserId]
        if instance then
            instance:destroy()
        end
    end)
end

return ServerBackpack