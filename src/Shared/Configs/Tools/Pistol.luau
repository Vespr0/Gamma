return {
	displayName = "Pistol",
	description = "She weighs one hundred fifty kilograms and fires two hundred dollar, custom-tooled cartridges at ten thousand rounds per minute. It costs four hundred thousand dollars to fire this weapon...for twelve seconds.",

	abilities = {
		shoot = {
			name = "Projectile",
			cooldownDuration = 0.4,
			spread = 2,
			damage = 10,
			inputs = {
				activate = { Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2 },
			},
			recoil = {
				vertical = 1,
				horizontal = 0.1,
			},
			maxAmmo = 6,
			sound = "Tools/Generic/GunShot",
			continuousFire = false,
		},
		reload = {
			name = "ResourceRegeneration",
			cooldownDuration = 2,
			regenerationType = "Full",
			resource = "Ammo",
			inputs = {
				activate = { Enum.KeyCode.R },
			},
			sound = "Tools/Generic/Reload",
			animation = "Tools/Generic/Pistol/Reload",
		},
	},

	animations = {
		hold = "Tools/Generic/Pistol/Hold",
	},
}
