--!strict

local Settings = {}

-- Name of the RemoteEvent used for server-client communication
Settings.RemoteEventName = "GammaCastEvent"
-- Folder in Workspace where client visuals will be parented
Settings.VisualsFolder = "GammaCastVisuals"

-- Default ranges and speeds (in studs)
Settings.DefaultRange = 100
Settings.DefaultSpeed = 100

-- Base interpolation offset (added to ping) to account for client-side character interpolation
Settings.INTERPOLATION_OFFSET = 0.048

return Settings
