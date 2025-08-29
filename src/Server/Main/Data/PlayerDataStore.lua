local PlayerDataStore = {}

-- Dependencies for proper loading order
PlayerDataStore.Dependencies = {"DataAccess"}

-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Folders --

local Packages = ReplicatedStorage.Packages
-- Modules --
local DataStoreModule = require(Packages.suphisdatastoremodule)
local DataUtility = require(ReplicatedStorage.Data.DataUtility)

PlayerDataStore.DataTemplate = {
	-- Basic Data --
	Gold = 0,
	-- Items --
	Inventory = {},
	-- Session --
	Session = {
		FirstPlayed = nil,
		LastPlayed = nil,
		TimePlayed = 0,
	},
	-- Stats --
	Stats = {
	},

	-- Onboarding steps tracking --
	Onboarding = {},
}

function PlayerDataStore.Init()
	-- Player joins.
	Players.PlayerAdded:Connect(function(player)
		print("PlayerAdded: Creating new session for " .. player.Name)
		
		DataStoreModule.new(DataUtility.GetDataScope("Player"), player.UserId)
		-- The SuphisDataStoreModule will automatically handle opening the session.
		-- We don't need to manually open it or manage its state.
	end)
	-- Player leaves.
	Players.PlayerRemoving:Connect(function(player)
		local dataStore = DataStoreModule.find(DataUtility.GetDataScope("Player"), player.UserId)
		-- If the player leaves, the datastore object is destroyed.
		if dataStore ~= nil then
			print("PlayerRemoving: Destroying session for " .. player.Name)
			dataStore:Destroy()
		end
	end)
end

return PlayerDataStore
