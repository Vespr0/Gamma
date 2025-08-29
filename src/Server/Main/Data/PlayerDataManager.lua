local PlayerDataManager = {}

-- Dependencies for proper loading order
PlayerDataManager.Dependencies = {"DataAccess", "PlayerDataStore"}

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Folders --
local Packages = ReplicatedStorage.Packages

-- Modules --
local DataStoreModule = require(Packages.suphisdatastoremodule)
local DataUtility = require(ReplicatedStorage.Data.DataUtility)
--local Trove = require(Packages.trove)
local BridgeNet2 = require(Packages.BridgeNet2)
local PlayerDataReplication = require(script.Parent.PlayerDataReplication)
local DataAccess = require(script.Parent.DataAccess)
local PlayerDataStore = require(script.Parent.PlayerDataStore)

-- Wipe all data for a user by userId
function PlayerDataManager.WipeUserData(userId)
	local userIdStr = tostring(userId)
	local dataStore = DataStoreModule.find(DataUtility.GetDataScope("Player"), userIdStr)

	if dataStore and dataStore.State == true then
		-- Player is online, so we can wipe the data directly.
		dataStore.Value = PlayerDataStore.DataTemplate
		local response, responseData = dataStore:Save()
		if response == "Saved" then
			warn("PlayerDataManager.WipeUserData: Wiped data for online userId " .. userIdStr)
			return true
		else
			error(
				"PlayerDataManager.WipeUserData: Failed to save wiped data for userId "
					.. userIdStr
					.. " - "
					.. tostring(responseData)
			)
			return false
		end
	else
		-- Player is offline, so we need to use a hidden session to avoid session locking.
		local hiddenDataStore = DataStoreModule.hidden(DataUtility.GetDataScope("Player"), userIdStr)
		local response, responseData = hiddenDataStore:Open(PlayerDataStore.DataTemplate)

		if response ~= "Success" then
			hiddenDataStore:Destroy()
			error(
				"PlayerDataManager.WipeUserData: Failed to open hidden datastore for userId "
					.. userIdStr
					.. " - "
					.. tostring(responseData)
			)
			return false
		end

		-- Set to template and save
		hiddenDataStore.Value = PlayerDataStore.DataTemplate
		local saveResponse, saveResponseData = hiddenDataStore:Save()

		-- Clean up
		hiddenDataStore:Destroy()

		if saveResponse == "Saved" then
			warn("PlayerDataManager.WipeUserData: Wiped data for offline userId " .. userIdStr)
			return true
		else
			error(
				"PlayerDataManager.WipeUserData: Failed to save wiped data for userId "
					.. userIdStr
					.. " - "
					.. tostring(saveResponseData)
			)
			return false
		end
	end
end

-- Setup --
function PlayerDataManager.Init()
	Players.PlayerAdded:Connect(function(player)
		-- Replication.
		PlayerDataReplication.InitPlayer(player)
		player:SetAttribute("DataLoaded", true)
	end)
end

return PlayerDataManager
