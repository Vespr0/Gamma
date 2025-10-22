return {
	displayName = "Pistol",
	description = "She weighs one hundred fifty kilograms and fires two hundred dollar, custom-tooled cartridges at ten thousand rounds per minute. It costs four hundred thousand dollars to fire this weapon...for twelve seconds.",

	abilities = {
		shoot = {
			name = "Projectile",
			cooldownDuration = 1,
			spread = 2,
			damage = 10,
			inputs = {
				activate = { Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2 },
			},
			recoil = {
				vertical = 0.5,
				horizontal = 0.1,
			},
			sound = "Tools/Generic/GunShot",
			continuousFire = false,
			projectileConfig = {
				hitscan = false,
			},
		},
	},

	animations = {
		hold = "Tools/Generic/Pistol/Hold",
	},
}
