local OnboardingAccess = {}

-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules --
local PlayerData = require(script.Parent.Parent.PlayerData)
local DataAccess = require(script.Parent.Parent.DataAccess) -- Keep for PlayerDataChanged signal

-- FunnelsLogger is optional - use dummy implementation if not available
local FunnelsLogger = {
    OnboardingSteps = {},
    LogOnboarding = function(player, stepName) end -- No-op function
}

-- Check if an onboarding step has been completed
function OnboardingAccess.HasCompleted(...)
	local player, stepName = DataAccess.GetParameters(...)
	if not (player and stepName) then return false end

    local onboardingData = PlayerData.Get(player, "Onboarding") or {}
    return onboardingData[stepName] or false
end

-- Mark an onboarding step as completed and log it
function OnboardingAccess.Complete(...)
	local player, stepName = DataAccess.GetParameters(...)
	if not (player and stepName) then return end
    
    -- Validate step name
    if not FunnelsLogger.OnboardingSteps[stepName] then
        return false, "Invalid onboarding step name: " .. tostring(stepName)
    end

    -- Get current onboarding data
    local onboardingData = PlayerData.Get(player, "Onboarding") or {}
    
    -- Only log and mark if not already completed
    if not onboardingData[stepName] then
        onboardingData[stepName] = true
        PlayerData.Set(player, "Onboarding", onboardingData)
        FunnelsLogger.LogOnboarding(player, stepName)
        DataAccess.PlayerDataChanged:Fire(player, "Onboarding", stepName)

        return true
    else
        return true, "Onboarding step already completed: " .. tostring(stepName)
    end
end

-- Check level-based onboarding steps
function OnboardingAccess.CheckLevelSteps(...)
	local player, level = DataAccess.GetParameters(...)
	if not (player and level) then 
        return false, `Invalid parameters`
    end
    
    local LEVELS = {25,50,100}

    for _,l in ipairs(LEVELS) do
        local success, errorMessage = OnboardingAccess.Complete(player, "ReachedLevel25")
        if not success then
            return false, `Error while marking complete onboarding level "{level}": {errorMessage}`
        end
    end

    return true
end

function OnboardingAccess.Init()
    -- Nothing to initialize here
end

return OnboardingAccess