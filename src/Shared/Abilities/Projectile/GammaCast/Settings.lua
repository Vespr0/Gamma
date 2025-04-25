--!strict

local Settings = {}

-- Name of the RemoteEvent used for server-client communication
Settings.RemoteEventName = "GammaCastEvent"
-- Folder in Workspace where client visuals will be parented
Settings.VisualsFolder = "GammaCastVisuals"

-- Default ranges and speeds (in studs)
Settings.DefaultRange = 100
Settings.DefaultSpeed = 100

-- Snapshot settings
Settings.SnapshotLifetime = 1

-- Hitbox size (in studs)
Settings.HitboxSize = Vector3.new(6, 6, 6) / 2

-- Voxels
Settings.VoxelSize = 32

-- TODO: Do something about or add warnings for entities outside of the voxel grid
Settings.VoxelGridSize = Vector3.new(4096, 512, 4096)
Settings.VoxelGridCorner = CFrame.new(-Settings.VoxelGridSize / 2)

-- Base interpolation offset (added to ping) to account for client-side character interpolation
Settings.INTERPOLATION_OFFSET = 0.048

-- Character parts for hitbox detection (Using R6 parts)
-- Changed from separate Names/Sizes arrays to a direct map
Settings.Parts = {
	["Head"] = Vector3.new(1.161, 1.181, 1.161) / 2,
	["Torso"] = Vector3.new(2, 2, 1) / 2,
	["Left Arm"] = Vector3.new(1, 2, 1) / 2,
	["Right Arm"] = Vector3.new(1, 2, 1) / 2,
	["Left Leg"] = Vector3.new(1, 2, 1) / 2,
	["Right Leg"] = Vector3.new(1, 2, 1) / 2,
}

return Settings
