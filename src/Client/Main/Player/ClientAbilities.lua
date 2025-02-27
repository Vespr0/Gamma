-- src/Client/Main/Player/ClientAbilities.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ClientBackpack = require(script.Parent.ClientBackpack) 
local ToolUtility = require(ReplicatedStorage.Utility.ToolUtility) 
local AssetsDealer = require(ReplicatedStorage.AssetsDealer)

local ClientAbilities = {}

local abilities = {} -- Store ability instances

-- Helper function to create a client ability instance
local function createClientAbility(tool)
    local abilityConfig = ToolUtility.GetConfig(tool) -- TODO 
    if not abilityConfig then return end

    for abilityName, config in pairs(abilityConfig) do
        
    end
end

local function destroyClientAbility(tool)
	if abilities[tool] then
		abilities[tool]:destroy()
		abilities[tool] = nil
		print("Destroyed client ability for tool", tool.Name)
	end
end

function ClientAbilities.Init()
    -- When the local player instance is created, go through all current tools and add abilities
    -- ClientBackpack.LocalPlayerInstance.events.ToolAdded:Connect(function(index)
    --     local tool = ClientBackpack.LocalPlayerInstance:GetToolAtIndex(index)
    --     if tool then
    --         createClientAbility(tool)
    --     end
    -- end)

    -- ClientBackpack.LocalPlayerInstance.events.ToolRemoved:Connect(function(index)
    --     local tool = ClientBackpack.LocalPlayerInstance:GetToolAtIndex(index)
    --     if tool then
    --         destroyClientAbility(tool)
    --     end
    -- end)
end

return ClientAbilities