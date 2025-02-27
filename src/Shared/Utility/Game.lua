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
	Liquids = workspace:WaitForChild("Nodes"):WaitForChild("Liquids")
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