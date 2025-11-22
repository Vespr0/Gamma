local TrustSystem = {}
local Players = game:GetService("Players")

-- Constants
local MAX_TRUST = 100
local STARTING_TRUST = 50
local REGEN_AMOUNT = 10
local REGEN_INTERVAL = 60 -- Seconds

-- Storage
local trustScores = {}

local KICK_MESSAGE = "Kicked for suspicious behavior. This can be caused by high ping, if you think this is a mistake contact me."

function TrustSystem.GetTrust(player: Player): number
	if not trustScores[player] then
		trustScores[player] = STARTING_TRUST
	end
	return trustScores[player]
end

function TrustSystem.ChangeTrust(player: Player, amount: number)
	local currentTrust = TrustSystem.GetTrust(player)
	local newTrust = math.clamp(currentTrust + amount, 0, MAX_TRUST)
	trustScores[player] = newTrust

	if newTrust <= 0 then
		player:Kick(KICK_MESSAGE)
	end
end

function TrustSystem.StartRegeneration()
	task.spawn(function()
		while true do
			task.wait(REGEN_INTERVAL)
			for player, score in pairs(trustScores) do
				if score < MAX_TRUST then
					TrustSystem.ChangeTrust(player, REGEN_AMOUNT)
				end
			end
		end
	end)
end

function TrustSystem.Init()
	TrustSystem.StartRegeneration()
end

return TrustSystem
