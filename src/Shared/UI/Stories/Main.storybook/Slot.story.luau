local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.fusion)
local Slot = require(ReplicatedStorage.UI.Components.Slot)

local controls = {
	Number = 1,
	Focused = true,
}

return {
	fusion = Fusion,
	controls = controls,
	story = function(props)
		local scope = props.scope

		local _component = Slot(scope, {
			Parent = props.target,
			Number = props.controls.Number,
			Focused = props.controls.Focused,
			GetItemViewport = function()
				return true
			end,
		})
	end,
}
