local Item = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Modules
local AssetsDealer = require(ReplicatedStorage.AssetsDealer)

function Item.GetToolModel(tool: Tool)
    local model = tool:FindFirstChild("Model")

    if model then
        return model :: Model
    else
        warn(`Tool has no model`)
        return nil
    end
end

function Item.GetItemAsset(itemName: string, mode: ("Clone" | nil)?)
    local asset = AssetsDealer.Get("Tools", itemName, mode)
    if asset then
        return asset
    else
        error(`Item asset not found with name {itemName}`)
        return nil
    end
end

function Item.GetToolFromName(itemName: string,clone: boolean)
    local asset = Item.GetItemAsset(itemName)
    local tool = asset:FindFirstChildOfClass("Tool")

    if tool then
        if clone then
            tool = tool:Clone()
            tool.Name = itemName
        end
        return tool :: Tool
    else
        warn(`Tool not found in asset with name {itemName}`)
        return nil
    end
end

return Item