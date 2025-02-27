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
		
		ServerEntity.new(rig)
		
		rig:PivotTo(cframe or CFrame.new(0,50,0))
	else
		warn(`Rig directory "{rigDirectory}" does not exist. Failed to spawn mob.`)
	end

	return rig
end

return MobSpawner
