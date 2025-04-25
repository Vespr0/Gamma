return function()
	local MobSpawner = require(script.Parent.Parent.Parent.Main.Mobs.MobSpawner)

	-- for i = 1, 1 do
	-- 	local _,mobEntity = MobSpawner.Spawn("HockeyMaskGuy", CFrame.new(i*3+10,50,40))

	-- 	-- Fire MindController event for NPCs
	-- 	task.spawn(function()
	-- 		task.wait(10)
	-- 		while true do
	-- 			mobEntity.backpack.abilities:getMindController("Minigun", "Projectile", 1):Fire("Fire", mobEntity.root.CFrame.LookVector)
	-- 			task.wait(.2) -- Fire every 2 seconds
	-- 		end
	-- 	end)

	-- 	task.spawn(function()
	-- 		task.wait(5)
	-- 		mobEntity.backpack:equipTool(1)
	-- 	end)
	-- end

	for i = 1, 1 do
		task.spawn(function()
			local _,mobEntity = MobSpawner.Spawn("HockeyMaskGuy", CFrame.new(0,50,i*2),"Yellow")
			while true do
				mobEntity.humanoid:MoveTo(mobEntity.root.Position + Vector3.new(30,0,0))
				mobEntity.humanoid.MoveToFinished:Wait()
				mobEntity.humanoid:MoveTo(mobEntity.root.Position - Vector3.new(30,0,0))
				mobEntity.humanoid.MoveToFinished:Wait()
			end
		end)
	end
	-- local ProjectileManager = require(game.ReplicatedStorage.Abilities.ProjectileManager)
	
	-- while true do
	-- 	task.spawn(function()
	-- 		ProjectileManager.Dynamic({
	-- 			["StartingPosition"] = Vector3.new(0,5,0),
	-- 			["Direction"] = Vector3.new(math.random(-10,10)/10,0,math.random(-10,10)/10),
	-- 			["Amplitude"] = 10,
	-- 			["Thickness"] = .1
	-- 		})
	-- 	end)
	-- 	task.wait(.1)
	-- end
end