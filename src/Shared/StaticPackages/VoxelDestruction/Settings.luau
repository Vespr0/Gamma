local Settings = {}

Settings.Tag = "Breakable" -- Name of attribute to check for

Settings.OnClient = false -- Client sided destruction
	Settings.OnServer = false -- Used only if onClient is true. Non replicated server sided destruction for npcs
Settings.RecordDestruction = false -- Records destruction and loads it to clients who join. Can affect memory when used.

Settings.ResetModel = false -- Whether or not the reset timer applies to a tagged model as a whole
Settings.ResetYields = false -- Yields the reset until no humanoids are within the bounds of the wall
Settings.ResetDefault = 60 -- Time it takes for the wall to repair itself since last break
Settings.ResetMinimum = 3 -- Minimum reset timer, passing a value less than this will use this

Settings.CutoutSize = 1 -- Cutout size determines the size of destruction radius, lower it slightly for more detail or increase it for less.
Settings.GridLock = false -- Grid locking prevents small slivers of parts left after destruction

Settings.DebrisContainer = workspace.Map.Debris -- Debris storage
Settings.DebrisDefaultBehavior = false -- Use default behavior for debris, used for automatic cleanup on client
	Settings.DebrisAnchored = false -- Whether or not debris are anchored by default
	Settings.DebrisReset = 10 -- The time until debris will be automatically cleaned up by default

Settings.Relativity = true -- If true relativity will be applied instead of default size when size is not specified
	Settings.VoxelRelative = 1/8 -- Voxel size relative to hitbox size
Settings.VoxelDefault = 1 -- Default voxel size
Settings.VoxelMinimum = 1 -- Minimum voxel size
Settings.HitboxRelative = 1/3 -- If voxel size is not specified hitboxes will use a relative size applied to the part size
-- *this only applies to movement, to have your intersection sizes match your part size keep this at 1

Settings.GreedyMeshing = true -- Recommended to leave this on for reduced part count to combat lag
Settings.RunService = false -- Use RunService instead of detecting changed position, more accurate at the cost of server performance
Settings.PartCache = true -- Use PartCache so instancing parts does not create lag
Settings.CachePrecreated = 10000 -- The original cache ceiling
Settings.CacheExtra = 100 -- The amount of extra parts created everytime the cache ceiling is reached

return Settings
