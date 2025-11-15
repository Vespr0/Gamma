local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.fusion)
local Cursor = require(ReplicatedStorage.UI.Components.Cursor)

local controls = {
	Spread = 4,
	Color = Color3.new(1, 1, 1),
	SegmentSizeX = 2,
	SegmentSizeY = 5,
	StrokeColor = Color3.new(0, 0, 0),
	StrokeThickness = 1,
	StrokeTransparency = 0.5,
	ZIndex = 10,
}

return {
	fusion = Fusion,
	controls = controls,
	story = function(props)
		local scope = props.scope

		local strokeProps = scope:Computed(function(use)
			return {
				Color = use(props.controls.StrokeColor),
				Thickness = use(props.controls.StrokeThickness),
				Transparency = use(props.controls.StrokeTransparency),
			}
		end)

		local segmentSize = scope:Computed(function(use)
			return Vector2.new(use(props.controls.SegmentSizeX), use(props.controls.SegmentSizeY))
		end)

		local _component = Cursor(scope, {
			Parent = props.target,
			Position = UDim2.fromScale(0.5, 0.5), -- Center it in the story view
			Spread = props.controls.Spread,
			Color = props.controls.Color,
			SegmentSize = segmentSize,
			ZIndex = props.controls.ZIndex,
			Stroke = strokeProps,
		})
	end,
}
