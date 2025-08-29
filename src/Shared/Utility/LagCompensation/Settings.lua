local Settings = {}

Settings.VoxelSize = 32
Settings.HitboxSize = Vector3.new(6, 6, 6) / 2
Settings.SnapshotLifetime = 1
-- TODO: Do something about or add warnings for entities outside of the voxel grid
Settings.VoxelGridSize = Vector3.new(4096, 512, 4096)
Settings.VoxelGridCorner = CFrame.new(-Settings.VoxelGridSize / 2)
-- Character parts for hitbox detection (Using R6 parts)
-- Changed from separate Names/Sizes arrays to a direct map
Settings.Parts = {
    ["Head"] = Vector3.new(1.161, 1.181, 1.161) / 2,
    ["Torso"] = Vector3.new(2, 2, 1) / 2,
    ["Left Arm"] = Vector3.new(1, 2, 1) / 2,
    ["Right Arm"] = Vector3.new(1, 2, 1) / 2,
    ["Left Leg"] = Vector3.new(1, 2, 1) / 2,
    ["Right Leg"] = Vector3.new(1, 2, 1) / 2
}

return Settings

