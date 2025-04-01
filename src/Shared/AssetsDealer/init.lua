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

    -- Baking logic
	if not AssetsDealer.Bakery[category] then
		AssetsDealer.Bakery[category] = {}
    end

	if AssetsDealer.Bakery[category][directory] then
        if mode == "Clone" then
			return AssetsDealer.Bakery[category][directory]:Clone()
        end
		return AssetsDealer.Bakery[category][directory]
    end

    local asset = currentFolder
    if mode == "Clone" then
		AssetsDealer.Bakery[category][directory] = asset
        asset = asset:Clone()
    elseif mode == "Require" and asset:IsA("ModuleScript") then
        asset = require(asset)
    end

	AssetsDealer.Bakery[category][directory] = asset

    assert(asset, `Couldn't find asset of category "{category}" with directory "{directory}"`)
    return asset
end

function AssetsDealer.Get(category: string,name: string,mode: assetsGetMode) 
	local categoryFolder = AssetsDealer.Assets:FindFirstChild(category)
	if not categoryFolder then
		warn("No category",category)
		return nil
	end
	
	for _,d in AssetsDealer.RawAssets[category] do
		if d.Name == name then
			-- Baking
			if not AssetsDealer.Bakery[category] then
				AssetsDealer.Bakery[category] = {}
			end
			if AssetsDealer.Bakery[category][name] then
				if mode == "Clone" then
					return AssetsDealer.Bakery[category][name]:Clone()
				end
				return AssetsDealer.Bakery[category][name]
			end
			
			local y = d
			if mode == "Clone" then
				AssetsDealer.Bakery[category][name] = d
				y = d:Clone()
			end
			if mode == "Require" then
				y = require(d)
			end
			
			AssetsDealer.Bakery[category][name] = y
			
			assert(y,`Couldn't find asset of category "{category}" with name "{name}"`)
			return y :: any
		end
	end

	warn(`Couldn't find asset of category "{category}" with name "{name}"`)
	return nil
end

return AssetsDealer
