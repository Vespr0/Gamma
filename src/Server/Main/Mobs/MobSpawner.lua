--!strict
local MobSpawner = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
-- Modules
local AssetsDealer = require(ReplicatedStorage.AssetsDealer)
local ServerEntity = require(ServerScriptService.Main.Entities.ServerEntity)

function MobSpawner.Spawn(rigDirectory: string, cframe: CFrame?, className: string?)
	assert(cframe, `Rig directory cannot be nil.`)
	assert(cframe, `CFrame directory cannot be nil.`)
	
	local rig = AssetsDealer.GetDir("Rigs",rigDirectory,"Clone")
	
	if rig then
		rig.Name = "Mob"
		rig:PivotTo(cframe or CFrame.new(0,50,0))

		local entity = ServerEntity.new(rig)		
		entity.humanoid.WalkSpeed = 8

		task.spawn(function()
			while true do
				rig.Humanoid:MoveTo(Vector3.new(math.random(-30,30),0,math.random(-30,30)))
				task.wait(2)
			end
		end)
		task.spawn(function()
			task.wait(15)
			entity.backpack:equipTool(1)
		end)
	else
		warn(`Rig directory "{rigDirectory}" does not exist. Failed to spawn mob.`)
	end

	return rig
end

return MobSpawner
