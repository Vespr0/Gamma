local TokensAccess = {}

-- Services --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Modules --
local PlayerData = require(script.Parent.Parent.PlayerData)
local DataAccess = require(script.Parent.Parent.DataAccess) -- Keep for PlayerDataChanged signal
local OnboardingAccess = require(script.Parent.OnboardingAccess)

function TokensAccess.GiveTokens(...)
	local player, amount = DataAccess.GetParameters(...)
	if not (player and amount) then
		return false, "Missing parameters"
	end

	-- Use PlayerData to increment tokens
	PlayerData.Increment(player, "Tokens", amount)

	-- Log onboarding step
	OnboardingAccess.Complete(player, "FirstTokenEarned")

	DataAccess.PlayerDataChanged:Fire(player, "Tokens", amount)

	return true
end

function TokensAccess.TakeTokens(...)
	local player, amount = DataAccess.GetParameters(...)
	if not (player and amount) then
		return false, "Missing parameters"
	end

	-- Use PlayerData to decrement tokens by using negative increment
	PlayerData.Increment(player, "Tokens", -amount)

	DataAccess.PlayerDataChanged:Fire(player, "Tokens", amount)

	return true
end

function TokensAccess.GetTokens(...)
	local player = DataAccess.GetParameters(...)
	if not player then
		return false, "Missing parameters"
	end

	-- Use PlayerData to get tokens value
	local tokens = PlayerData.Get(player, "Tokens") or 0
	return tokens
end

return TokensAccess
