local DEFAULT_SETTINGS = {
    hitscan = true,
    range = 200,
    length = 10,
    timeStep = 1/60
}

return {
    Default = DEFAULT_SETTINGS,
    Rocket = {
        range = DEFAULT_SETTINGS.range,
        speed = 150,
        gravity = 20,
        length = DEFAULT_SETTINGS.range,
        timeStep = DEFAULT_SETTINGS.timeStep,
        hitscan = false,
    },
}