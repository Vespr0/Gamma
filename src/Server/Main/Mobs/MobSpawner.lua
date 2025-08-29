--!strict
local MobSpawner = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local CollectionService = game:GetService("CollectionService")
-- Modules
local AssetsDealer = require(ReplicatedStorage.AssetsDealer)
local ServerEntity = require(ServerScriptService.Main.Entities.ServerEntity)
local Human = require(ServerScriptService.Main.Mobs.Spiri.Subclasses.Human) -- Import the Human subclass

function MobSpawner.Spawn(rigDirectory: string, cframe: CFrame?, team: string?)
	assert(rigDirectory, `Rig directory cannot be nil.`)
	assert(cframe, `CFrame directory cannot be nil.`)
	
	local rig = AssetsDealer.GetDir("Rigs",rigDirectory,"Clone")
	local entity = nil
    local ai = nil
	if rig then
		rig.Name = "Mob"
		rig:PivotTo(cframe or CFrame.new(0,50,0))

		entity = ServerEntity.new(rig,nil,team or "Red")
		entity.humanoid.WalkSpeed = 8

        -- Create the Spiri AI instance
                ai = Human.new(entity)
        
        		-- Add tag for lag compensation to the Model
        		CollectionService:AddTag(entity.model, "LagCompensatedEntity") -- Tag the Model
        
        		-- TODO: Only setting it for the root might be insufficient
        		-- Set network ownership to the server
        		entity.root:SetNetworkOwner(nil)
        
        		-- task.spawn(function()
        		-- 	while true do
        		-- 		rig.Humanoid:MoveTo(Vector3.new(math.random(-30,30),0,math.random(-30,30)))
        		-- 		task.wait(5)
        		-- 	end
        	-- end)
	else
		warn(`Rig directory "{rigDirectory}" does not exist. Failed to spawn mob.`)
	end

	return rig, entity, ai
end

return MobSpawner
