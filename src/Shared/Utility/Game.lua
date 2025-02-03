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
Game.Limbs = {
	RightArm = "Right Arm",
	LeftArm = "Left Arm",
	Torso = "Torso",
	Head = "Head",
	RightLeg = "Right Leg",
	LeftLeg = "Left Leg"
}

return Game