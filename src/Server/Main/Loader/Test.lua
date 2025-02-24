return function()
	local MobSpawner = require(script.Parent.Parent.Parent.Main.Mobs.MobSpawner)

	local mob1 = MobSpawner.Spawn("Noob",CFrame.new(0,50,0))
	local mob2 = MobSpawner.Spawn("TohatGuy",CFrame.new(0,50,10))
end