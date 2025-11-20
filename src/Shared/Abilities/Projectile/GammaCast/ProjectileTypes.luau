local DEFAULT_SETTINGS = {
	hitscan = true,
	range = 200,
	length = 10,
	timeStep = 1 / 60,
	thickness = 0.2,
	color = Color3.new(1, 1, 0),
	material = Enum.Material.Neon,
}

return {
	Default = DEFAULT_SETTINGS,
	Brick = {
		range = DEFAULT_SETTINGS.range,
		speed = 100,
		gravity = 100,
		length = DEFAULT_SETTINGS.range,
		timeStep = DEFAULT_SETTINGS.timeStep,
		hitscan = false,
		thickness = 0.8,
		color = Color3.fromRGB(200, 80, 80),
		material = Enum.Material.Plastic,
	},
}
