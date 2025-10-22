return {
	displayName = "Brick",
	description = "High in calcium!",

	abilities = {
		shoot = {
			name = "Projectile",
			cooldownDuration = 5,
			spread = 2,
			damage = 40,
			inputs = {
				activate = { Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2 },
			},
			sound = "Tools/Generic/Throw",
			continuousFire = false,
			projectileType = "Brick",
			projectileConfig = {
				hitscan = false,
			},
		},
	},

	animations = {
		hold = "Tools/Generic/Hold",
	},
}
