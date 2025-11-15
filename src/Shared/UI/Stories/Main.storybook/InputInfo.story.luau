local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.fusion)
local InputInfo = require(ReplicatedStorage.UI.Components.InputInfo)

local controls = {
	InputKey = "E",
}

return {
	fusion = Fusion,
	controls = controls,
	story = function(props)
		local scope = props.scope

		local _component = InputInfo(scope, {
			Parent = props.target,
			Size = UDim2.new(0, 50, 0, 50),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			InputKey = props.controls.InputKey,
		})
	end,
}
