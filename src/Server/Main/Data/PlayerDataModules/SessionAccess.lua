local SessionAccess = {}

-- Services --
local Players = game:GetService("Players")

-- Modules --
local PlayerData = require(script.Parent.Parent.PlayerData)
local DataAccess = require(script.Parent.Parent.DataAccess) -- Keep for PlayerDataChanged signal
local OnboardingAccess = require(script.Parent.OnboardingAccess)

local function setSessionVariable(player, variable, value)
    local sessionData = PlayerData.Get(player, "Session") or {}
    sessionData[variable] = value or os.time()
    PlayerData.Set(player, "Session", sessionData)
end

local function hasPlayerPlayedBefore(player)
    local sessionData = PlayerData.Get(player, "Session") or {}
    local firstPlayed = sessionData["FirstPlayed"]
    return not (firstPlayed == nil or firstPlayed == 0)
end

function SessionAccess.SetFirstPlayed(...)
	local player = DataAccess.GetParameters(...)
	if not player then
		return
	end

	setSessionVariable(player, "FirstPlayed")
	warn(player.UserId .. " first played: " .. os.date("%c"))

	-- Log onboarding step
	OnboardingAccess.Complete(player, "FirstPlayed")

	-- Update
	DataAccess.PlayerDataChanged:Fire(player, "FirstPlayed", os.time())
end

function SessionAccess.SetLastPlayed(...)
	local player = DataAccess.GetParameters(...)
	if not player then
		return
	end

	setSessionVariable(player, "LastPlayed")
	--warn(player.UserId.." last played: "..os.date("%c"))

	-- Update
	DataAccess.PlayerDataChanged:Fire(player, "LastPlayed", os.time())
end

function SessionAccess.UpdateTotalPlayTime(...)
	local player = DataAccess.GetParameters(...)
	if not player then
		return
	end

	local sessionData = PlayerData.Get(player, "Session") or {}
	local lastPlayed = sessionData["LastPlayed"] or os.time()
	local addedPlayTime = os.time() - lastPlayed

	sessionData["TimePlayed"] = (sessionData["TimePlayed"] or 0) + addedPlayTime
	PlayerData.Set(player, "Session", sessionData)

	-- Update
	DataAccess.PlayerDataChanged:Fire(player, "TimePlayed", addedPlayTime)
end

function SessionAccess.GetTimePlayed(...)
	local player = DataAccess.GetParameters(...)
	if not player then
		return
	end

	local sessionData = PlayerData.Get(player, "Session") or {}
	return sessionData["TimePlayed"] or 0
end


function SessionAccess.Init()
	Players.PlayerAdded:Connect(function(player)
		if not hasPlayerPlayedBefore(player) then
			SessionAccess.SetFirstPlayed(player)
		end
		SessionAccess.SetLastPlayed(player)
	end)
	Players.PlayerRemoving:Connect(function(player)
		SessionAccess.UpdateTotalPlayTime(player)
	end)
end

return SessionAccess
