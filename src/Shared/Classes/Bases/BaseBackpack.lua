local BaseBackpack = {}
BaseBackpack.__index = BaseBackpack

-- Services
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Packages.signal)
local PlayerUtility = require(ReplicatedStorage.Utility.Player)
local AssetsDealer = require(ReplicatedStorage.AssetsDealer)
local ItemUtility = require(ReplicatedStorage.Utility.ItemUtility)
-- Constants
local IS_SERVER = RunService:IsServer()

function BaseBackpack.new(player: Player)
    local self = setmetatable({}, BaseBackpack)

    self.player = player

    if self.player == nil then error("Player is missing") return end
    if not PlayerUtility.IsValidPlayerValue(player) then error(`Player is not a Player"`) return end

    self.tools = self.player:WaitForChild("Backpack") :: Backpack

    self.events = {}

    return self
end

function BaseBackpack:getTools()
    local tools = {}
    for _, tool in self.tools:GetChildren() do
        if tool:IsA("Tool") then
            table.insert(tools, tool)
        end
    end
    return tools
end

function BaseBackpack:getTool(toolName: string)
    local tool = self.tools:FindFirstChild(toolName)

    if tool and tool:IsA("Tool") then
        return tool :: Tool
    else
        warn(`Tool not found with name {toolName} in backpack for player {self.player.Name}`)
        return nil
    end
end

function BaseBackpack:getToolFromIndex(index: number)
    for _,tool in self:getTools() do
        if not tool or not tool:IsA("Tool") then continue end

        if tool:GetAttribute("Index") == index then
            return tool :: Tool
        end
    end
    return nil
end

function BaseBackpack:destroyBase()
    for _, signal in pairs(self.events) do
        signal:Destroy()
    end
end

return BaseBackpack