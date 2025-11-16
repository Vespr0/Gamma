return {
	displayName = "Minigun",
	description = "She weighs one hundred fifty kilograms and fires two hundred dollar, custom-tooled cartridges at ten thousand rounds per minute. It costs four hundred thousand dollars to fire this weapon...for twelve seconds.",

	abilities = {
		shoot = {
			name = "Projectile",
			cooldownDuration = 0.1,
			spread = 1,
			damage = 5,
			inputs = {
				activate = { Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2 },
			},
			recoil = {
				vertical = 0.5,
				horizontal = 0.1,
			},
			sound = "Tools/Minigun/FireLoop",
			continuousFire = true,
			projectileConfig = {
				hitscan = true,
			},
		},
	},

	walkSpeedBoost = -5,

	animations = {
		hold = "Tools/Minigun/Hold",
	},
}
