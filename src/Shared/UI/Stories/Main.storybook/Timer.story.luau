local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.fusion)
local Timer = require(ReplicatedStorage.UI.Components.Timer)

local controls = {
	Title = "INTERMISSION",
	Start = os.clock() + 15,
}

return {
	fusion = Fusion,
	controls = controls,
	story = function(props)
		local scope = props.scope

		local _component = Timer(scope, {
			Parent = props.target,
			Size = UDim2.new(0.25, 0, 0.65, 0),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Title = props.controls.Title,
			Start = props.controls.Start,
		})
	end,
}
