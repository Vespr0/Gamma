local PlayerOrderedDataManager = {}

-- Dependencies for proper loading order
PlayerOrderedDataManager.Dependencies = {"DataAccess", "PlayerDataStore", "PlayerDataManager"}

-- Services --
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

-- Folders --

local Server = ServerScriptService.Main
local OrderedDataModules = script.Parent.OrderedDataModules
local Packages = ReplicatedStorage.Packages

-- Modules --
-- local AnalyticsUtility = require(Server.Analytics.AnalyticsUtility)
local BridgeNet2 = require(Packages.BridgeNet2)

-- Constants --
PlayerOrderedDataManager.Errors = {
	invalidParameters = "Invalid parameter, %q is nil",
	updateFailed = "Failed to update ordered datastore.",
}
local ERRORS = PlayerOrderedDataManager.Errors

-- Variables --
local orderedDataStores = {}

-- Bridge --
local RankedDataUpdateBridge = BridgeNet2.ServerBridge("RankedDataUpdate")
RankedDataUpdateBridge.Logging = false

-- Local Functions --

local function getOrderedDataStore(name)
	if not orderedDataStores[name] then
		orderedDataStores[name] = DataStoreService:GetOrderedDataStore(name)
	end
	return orderedDataStores[name]
end

-- Functions --

function PlayerOrderedDataManager.GetParameters(...)
	local args = { ... }
	local returnedArgs = {}

	for i, v in args do
		returnedArgs[i] = v
		if v == nil then
			error(string.format(ERRORS.invalidParameters, i))
		end
	end
	if #returnedArgs > 0 then
		return table.unpack(returnedArgs)
	end

	return nil
end

function PlayerOrderedDataManager.UpdatePlayerData(dataStoreName, player, value)
	-- Skip updating ordered datastore for admin players
	-- if AnalyticsUtility.IsPlayerAdmin(player) then
	-- 	return true -- Return success but don't actually update the datastore
	-- end

	local success, result = pcall(function()
		local orderedStore = getOrderedDataStore(dataStoreName)
		return orderedStore:SetAsync(tostring(player.UserId), value)
	end)

	if not success then
		error(ERRORS.updateFailed .. " " .. tostring(result))
	end

	return success
end

function PlayerOrderedDataManager.GetTopPlayers(dataStoreName, pageSize, isAscending)
	pageSize = pageSize or 10
	isAscending = isAscending or false

	local success, result = pcall(function()
		local orderedStore = getOrderedDataStore(dataStoreName)
		local pages = orderedStore:GetSortedAsync(isAscending, pageSize)
		return pages:GetCurrentPage()
	end)

	if success then
		return result
	else
		error(ERRORS.updateFailed .. " " .. tostring(result))
		return {}
	end
end

function PlayerOrderedDataManager.GetRankedData()
	local rankedData = {}
	
	-- Automatically get data types from OrderedDataModules folder
	for _, orderedDataModule in pairs(OrderedDataModules:GetChildren()) do
		if orderedDataModule:IsA("ModuleScript") then
			-- Extract data type from module name (e.g., "LevelOrdered" -> "Level")
			local moduleName = orderedDataModule.Name
			local dataType = moduleName:gsub("Ordered$", "")
			
			local topPlayers = PlayerOrderedDataManager.GetTopPlayers(dataType, 20, false) -- Get top 100
			rankedData[dataType] = {}
			
			for rank, playerData in ipairs(topPlayers) do
				local userId = tonumber(playerData.key)
				if userId then
					table.insert(rankedData[dataType], {
						userId = userId,
						rank = rank,
						value = playerData.value
					})
				end
			end
		end
	end
	
	return rankedData
end

function PlayerOrderedDataManager.SendRankedDataToPlayer(player)
	local start = os.clock()
    local timeout
    repeat 
        task.wait(.1) 
        timeout = os.clock() - start > 8
    until player:GetAttribute("ClientLoaded") or timeout

	local rankedData = PlayerOrderedDataManager.GetRankedData()
	RankedDataUpdateBridge:Fire(player, rankedData)
end

function PlayerOrderedDataManager.SendRankedDataToAllPlayers()
	local rankedData = PlayerOrderedDataManager.GetRankedData()
	RankedDataUpdateBridge:Fire(Players:GetPlayers(), rankedData)
end

function PlayerOrderedDataManager.Init()
	for _, orderedDataModule in pairs(OrderedDataModules:GetChildren()) do
		if orderedDataModule:IsA("ModuleScript") then
			local module = require(orderedDataModule)
			if module.Init then
				module.Init()
			end
		end
	end

	for _,player in Players:GetPlayers() do
		PlayerOrderedDataManager.SendRankedDataToPlayer(player)
	end
	-- Send ranked data to players when they join
	Players.PlayerAdded:Connect(function(player)
		PlayerOrderedDataManager.SendRankedDataToPlayer(player)
	end)

	-- Send ranked data to all players every minute
	task.spawn(function()
		while true do
			task.wait(60) -- Wait 1 minute
			PlayerOrderedDataManager.SendRankedDataToAllPlayers()
		end
	end)

	-- local topPlayers = PlayerOrderedDataManager.GetTopPlayers("Level", 10, false)
	-- warn("Top 10 players by level:")
	-- for i, playerData in ipairs(topPlayers) do
	-- 	warn(i .. ". " .. playerData.key .. " - Level: " .. playerData.value)
	-- end
end

return PlayerOrderedDataManager
