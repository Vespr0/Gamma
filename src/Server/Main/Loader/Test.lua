return function()
	local MobSpawner = require(script.Parent.Parent.Parent.Main.Mobs.MobSpawner)

	for i = 1, 3 do
		MobSpawner.Spawn("Noob",CFrame.new(0,50,i*2))
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