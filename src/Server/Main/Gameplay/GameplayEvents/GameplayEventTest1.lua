local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameplayEvent = {}

function GameplayEvent.Trigger()
	local MobSpawner = require(script.Parent.Parent.Parent.Parent.Main.Mobs.MobSpawner)
	local SoldierSpiri = require(script.Parent.Parent.Parent.Mobs.Spiri.Classes.Soldier)

	local debugCFrame = workspace.DebugSpawn.CFrame
	for i = 1, 1 do
		local _, entity, _ =
			MobSpawner.Spawn("HockeyMaskGuy", debugCFrame + Vector3.new(i * 2, 5, 0), i % 2 == 0 and "Yellow" or "Blue")

		SoldierSpiri.new(entity, "Soldier", {})
		task.wait(1)
	end
end

function GameplayEvent.Init() end

return GameplayEvent
