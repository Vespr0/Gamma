local AdminAccess = {}

-- Services --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Modules --
local PlayerData = require(script.Parent.Parent.PlayerData)

-- Constants --
local ADMIN_USER_IDS = {
	-- Add admin user IDs here
	-- 123456789,
}

-- Helper function to check if a user is an admin
local function isAdmin(userId)
	if RunService:IsStudio() then
		return true -- Allow all operations in Studio
	end
	
	for _, adminId in ADMIN_USER_IDS do
		if adminId == userId then
			return true
		end
	end
	return false
end

-- Wipe all data for a specific user ID
function AdminAccess.WipeUserData(adminUserId, targetUserId)
	-- Validate admin permissions
	if not isAdmin(adminUserId) then
		warn("AdminAccess.WipeUserData: Unauthorized access attempt by userId " .. tostring(adminUserId))
		return false, "Unauthorized"
	end
	
	-- Validate target user ID
	if not targetUserId then
		warn("AdminAccess.WipeUserData: Target userId not provided")
		return false, "Invalid target userId"
	end
	
	-- Perform the wipe - need to handle userId since player might be offline
	-- For offline players, we need to use a different approach
	local targetPlayer = Players:GetPlayerByUserId(tonumber(targetUserId))
	if targetPlayer then
		local success, message = PlayerData.WipePlayerData(targetPlayer)
		if success then
			-- Log the action
			warn("AdminAccess.WipeUserData: Admin " .. tostring(adminUserId) .. " wiped data for userId " .. tostring(targetUserId))
			
			-- TODO: Ordered datastore is not accounted for
			
			return true, "Data wiped successfully"
		else
			return false, message or "Failed to wipe data"
		end
	else
		-- Offline player - use PlayerData's userId-based function
		local success, message = PlayerData.WipePlayerDataByUserId(targetUserId)
		
		if success then
			warn("AdminAccess.WipeUserData: Admin " .. tostring(adminUserId) .. " wiped data for offline userId " .. tostring(targetUserId))
			return true, "Data wiped successfully"
		else
			return false, message or "Failed to wipe data"
		end
	end
end

-- Wipe data for a player object (convenience function)
function AdminAccess.WipePlayerData(adminPlayer, targetPlayer)
	if not adminPlayer or not targetPlayer then
		return false, "Invalid player objects"
	end
	
	return AdminAccess.WipeUserData(adminPlayer.UserId, targetPlayer.UserId)
end

-- Get user data for inspection (admin only)
function AdminAccess.InspectUserData(adminUserId, targetUserId)
	-- Validate admin permissions
	if not isAdmin(adminUserId) then
		warn("AdminAccess.InspectUserData: Unauthorized access attempt by userId " .. tostring(adminUserId))
		return nil, "Unauthorized"
	end
	
	-- Get the data
	local targetPlayer = Players:GetPlayerByUserId(tonumber(targetUserId))
	if targetPlayer then
		local data = PlayerData.GetFull(targetPlayer)
		return data, "Success"
	else
		-- Try to access datastore directly for offline players
		local data = PlayerData.GetFullByUserId(targetUserId)
		if data then
			return data, "Success"
		else
			return nil, "Could not access user data"
		end
	end
end

-- Add admin user ID to the list (for runtime admin management)
function AdminAccess.AddAdmin(superAdminUserId, newAdminUserId)
	-- Only allow this in Studio or by existing admins
	if not (RunService:IsStudio() or isAdmin(superAdminUserId)) then
		warn("AdminAccess.AddAdmin: Unauthorized access attempt by userId " .. tostring(superAdminUserId))
		return false, "Unauthorized"
	end
	
	table.insert(ADMIN_USER_IDS, newAdminUserId)
	warn("AdminAccess.AddAdmin: Added admin userId " .. tostring(newAdminUserId))
	return true, "Admin added successfully"
end

-- List current admins (admin only)
function AdminAccess.ListAdmins(adminUserId)
	if not isAdmin(adminUserId) then
		warn("AdminAccess.ListAdmins: Unauthorized access attempt by userId " .. tostring(adminUserId))
		return nil, "Unauthorized"
	end
	
	return ADMIN_USER_IDS, "Success"
end

return AdminAccess