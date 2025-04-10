--!strict
local Game = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Assets
Game.Assets = ReplicatedStorage:WaitForChild("Assets")
-- Folders
Game.Folders = {
    Map = workspace:WaitForChild("Map"),
	Structures = workspace:WaitForChild("Map"):WaitForChild("Structures"),
	Entities = workspace:WaitForChild("Entities"),
	Voxels = workspace:WaitForChild("Map"):WaitForChild("Voxels"),
	Liquids = workspace:WaitForChild("Nodes"):WaitForChild("Liquids"),
	Debug = workspace:WaitForChild("Nodes"):WaitForChild("Debug"),
	Projectiles = workspace:WaitForChild("Nodes"):WaitForChild("Projectiles")
}
-- Tags
Game.Tags = {
	Entity = "Entity",
	Viewmodel = "Viewmodel"
}
-- Gameplay
Game.Gameplay = {
	ChargeIncrement = 0.01
}
-- Teams
Game.Teams = {
	Red = {
		Name = "Red",
		PrimaryColor = Color3.fromRGB(215, 30, 0),
		SecondaryColor = Color3.fromRGB(43, 30, 30)
	},
	Blue = {
		Name = "Blue",
		PrimaryColor = Color3.fromRGB(91, 109, 244),
		SecondaryColor = Color3.fromRGB(35, 38, 53)
	},
	Neutral = {
		Name = "Neutral",
		PrimaryColor = Color3.fromRGB(230, 229, 229),
		SecondaryColor = Color3.fromRGB(34, 34, 34)
	}
}
-- Rig
Game.RespawnTime = 3
Game.Limbs = {
	RightArm = "Right Arm",
	LeftArm = "Left Arm",
	Torso = "Torso",
	Head = "Head",
	RightLeg = "Right Leg",
	LeftLeg = "Left Leg"
}
-- Generation
Game.Generation = {
	WORLD_SIZE = 1000,
	PART_WIDTH = 10,
	PART_HEIGHT = 2
}


return Game