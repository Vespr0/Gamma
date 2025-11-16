local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.fusion)
local ResourcesHolder = require(ReplicatedStorage.UI.Components.ResourcesHolder)

local RESOURCES = {
	{ Name = "Ammo", Amount = 15, MaxAmount = 30 },
	{ Name = "Grenades", Amount = 2, MaxAmount = 3 },
	{ Name = "Medkits", Amount = 0, MaxAmount = 1 },
}

local controls = {}

return {
	fusion = Fusion,
	controls = controls,
	story = function(props)
		local scope = props.scope

		local _component = ResourcesHolder(scope, {
			Parent = props.target,
			Resources = RESOURCES,
		})
	end,
}
