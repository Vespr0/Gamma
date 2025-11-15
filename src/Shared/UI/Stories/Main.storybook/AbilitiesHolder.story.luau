local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.fusion)
local AbilitiesHolder = require(ReplicatedStorage.UI.Components.AbilitiesHolder)

local ABILITIES = {
	{ InputKey = "Q", Icon = "RevolverHolster" },
	{ InputKey = "F", Icon = "RevolverShoot", Disabled = true },
	{ InputKey = "R", Icon = "RevolverReload", Disabled = true },
}

local controls = {}

return {
	fusion = Fusion,
	controls = controls,
	story = function(props)
		local scope = props.scope

		local _component = AbilitiesHolder(scope, {
			Parent = props.target,
			Abilities = ABILITIES,
		})
	end,
}
