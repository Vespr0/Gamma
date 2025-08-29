local AssetsDealer = {}

export type assetsGetMode = "Clone" | "Require" | nil

AssetsDealer.Initialized = false

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local function validateAssets()
	for category,assets in AssetsDealer.RawAssets do
		local validator = script.Validators:FindFirstChild(category.."Validator")
		if validator then 
			validator = require(validator)
		else 
			warn(`No validator for "{category}" category`) 
			continue 
		end
		
		for _,asset in assets do
			validator(asset)
		end
	end
end

function AssetsDealer.Init()
	if AssetsDealer.Initialized then 
		warn("AssetsDealer was already inizialized on the "..RunService:IsServer() and "server" or "client")
		return 
	end
	
	if RunService:IsServer() then
		AssetsDealer.Assets = workspace:WaitForChild("Assets",3)
		
		if not AssetsDealer.Assets then
			error("❌ No assets folder in workspace")
		else
			AssetsDealer.Assets.Parent = ReplicatedStorage
		end
	else
		repeat task.wait() until ReplicatedStorage:FindFirstChild("Assets")
	end
	
	for _,category in AssetsDealer.Assets:GetChildren() do
		AssetsDealer.RawAssets[category.Name] = category:GetDescendants()
	end
	
	if RunService:IsServer() then
		validateAssets()
	end
	
	AssetsDealer.Initialized = true
end

-- Variables
AssetsDealer.Assets = ReplicatedStorage:WaitForChild("Assets",3)
AssetsDealer.RawAssets = {}
AssetsDealer.Bakery = {}

function AssetsDealer.GetDir(category: string, directory: string, mode: assetsGetMode)
    -- Split the directory string into components
    local components = string.split(directory, "/")

    -- Start from the category folder
	local currentFolder = AssetsDealer.Assets:FindFirstChild(category)
    if not currentFolder then
		warn(`No category "{category}"`)
        return nil
    end

    -- Navigate through the hierarchy based on the remaining path
    for _, folderName in ipairs(components) do
        currentFolder = currentFolder:FindFirstChild(folderName)
        if not currentFolder then
            warn(`Invalid directory, couldn't find folder "{folderName}" in category "{category}"`)
            return nil
        end
    end

    -- If the final result is not an instance, return nil
    if not currentFolder:IsA("Instance") then
        warn("Invalid directory, final target is not an instance")
        return nil
    end

    if mode == "Clone" then
        return currentFolder:Clone()
    elseif mode == "Require" and currentFolder:IsA("ModuleScript") then
        return require(currentFolder)
    end
    return currentFolder
end

function AssetsDealer.Get(category: string,name: string,mode: assetsGetMode) 
	local categoryFolder = AssetsDealer.Assets:FindFirstChild(category)
	if not categoryFolder then
		warn("No category",category)
		return nil
	end
	
	for _,d in AssetsDealer.RawAssets[category] do
		if d.Name == name then
            -- Immediately clone or require without caching
            if mode == "Clone" then
                return d:Clone()
            elseif mode == "Require" and d:IsA("ModuleScript") then
                return require(d)
            end
            return d
        end
    end

	warn(`Couldn't find asset of category "{category}" with name "{name}"`)
	return nil
end

return AssetsDealer
