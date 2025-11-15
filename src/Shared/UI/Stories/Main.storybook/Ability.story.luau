local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.fusion)
local Ability = require(ReplicatedStorage.UI.Components.Ability)

local controls = {
	InputKey = "Q",
	Icon = "RevolverHolster",
	Disabled = true,
}

return {
	fusion = Fusion,
	controls = controls,
	story = function(props)
		local scope = props.scope

		local _component = Ability(scope, {
			Parent = props.target,
			Size = UDim2.new(0, 100, 0, 100),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			InputKey = props.controls.InputKey,
			Icon = props.controls.Icon,
			Disabled = props.controls.Disabled,
		})
	end,
}
