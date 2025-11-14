return function()
	local MobSpawner = require(script.Parent.Parent.Parent.Main.Mobs.MobSpawner)
	local SoldierSpiri = require(script.Parent.Parent.Mobs.Spiri.Classes.Soldier)

	-- for i = 1, 2 do
	-- 	task.wait(1)
	-- 	local _, entity, _ =
	-- 		MobSpawner.Spawn("HockeyMaskGuy", CFrame.new(i * 2, 5, 0), i % 2 == 0 and "Yellow" or "Blue")

	-- 	SoldierSpiri.new(entity, "Soldier", {})
	-- end

	-- local _, entity, _ = MobSpawner.Spawn("HockeyMaskGuy", CFrame.new(0, 5, 5), "Blue")

	-- local walkers = {}
	-- for i = 1, 3 do
	-- 	task.spawn(function()
	-- 		local _,mobEntity, _ = MobSpawner.Spawn("HockeyMaskGuy", CFrame.new(0,50,i*2),"Yellow")
	-- 		table.insert(walkers, mobEntity)
	-- 		while true do
	-- 			mobEntity.humanoid:MoveTo(mobEntity.root.Position + Vector3.new(30,0,0))
	-- 			mobEntity.humanoid.MoveToFinished:Wait()
	-- 			mobEntity.humanoid:MoveTo(mobEntity.root.Position - Vector3.new(30,0,0))
	-- 			mobEntity.humanoid.MoveToFinished:Wait()
	-- 		end
	-- 	end)
	-- end

	-- for i = 1, 1 do
	-- 	local _,mobEntity, _ = MobSpawner.Spawn("HockeyMaskGuy", CFrame.new(i*3+10,50,40))

	-- 	task.spawn(function()
	-- 		task.wait(1)
	-- 		mobEntity.backpack:equipTool(1)
	-- 	end)

	-- 	-- Fire MindController event for NPCs
	-- 			-- task.spawn(function()
	-- 			-- 	task.wait(3)
	-- 			-- 	while true do
	-- 			-- 		local root = mobEntity.root
	-- 			-- 		local direction = CFrame.lookAt(root.Position, walkers[1].root.Position).LookVector
	-- 			-- 		mobEntity.rig:SetAttribute("LookDirection", direction)

	-- 			-- 		local mindController = mobEntity.backpack.abilities:getMindController("Minigun", "Projectile", 1)
	-- 			-- 		mindController:Fire("Fire", direction,root.Position+Vector3.yAxis*1.5)
	-- 			-- 		task.wait(.2) -- Fire every 2 seconds
	-- 			-- 	end
	-- 			-- end)
	-- end

	-- -- local ProjectileManager = require(game.ReplicatedStorage.Abilities.ProjectileManager)

	-- -- while true do
	-- -- 	task.spawn(function()
	-- -- 		ProjectileManager.Dynamic({
	-- -- 			["StartingPosition"] = Vector3.new(0,5,0),
	-- -- 			["Direction"] = Vector3.new(math.random(-10,10)/10,0,math.random(-10,10)/10),
	-- -- 			["Amplitude"] = 10,
	-- -- 			["Thickness"] = .1
	-- -- 		})
	-- -- 	end)
	-- -- 	task.wait(.1)
	-- -- end

	-- local VoxelDestruction = require(game.ReplicatedStorage.StaticPackages.VoxelDestruction)
end
