local DEFAULT_SETTINGS = {
	hitscan = true,
	range = 200,
	length = 10,
	timeStep = 1 / 60,
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
	},
}
