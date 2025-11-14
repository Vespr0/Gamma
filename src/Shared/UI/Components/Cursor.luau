local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.fusion)

local Children = Fusion.Children
local Computed = Fusion.Computed

type UsedAs<T> = Fusion.UsedAs<T>

local CENTERED_ANCHOR_POINT = Vector2.new(0.5, 0.5)

type CursorProps = {
	Parent: GuiObject?,
	Position: UsedAs<UDim2>?,
	Spread: UsedAs<number>,
	Color: UsedAs<Color3>?,
	SegmentSize: UsedAs<Vector2>?,
	ZIndex: UsedAs<number>?,
	Stroke: UsedAs<{
		Color: Color3?,
		Thickness: number?,
		Transparency: number?,
	}>?,
}

--[[
	A customizable cursor component with four segments that can spread.
]]
local function Cursor(scope: Fusion.Scope<typeof(Fusion)>, props: CursorProps)
	local color = props.Color or Color3.new(1, 1, 1)
	local segmentSize = props.SegmentSize or Vector2.new(2, 5)
	local zIndex = props.ZIndex or 10
	local strokeProps = props.Stroke or {}
	local strokeColor = strokeProps.Color or Color3.new(0, 0, 0)
	local strokeThickness = strokeProps.Thickness or 1
	local strokeTransparency = strokeProps.Transparency or 0.5

	-- Helper function to create a segment with stroke
	local function createSegment(name, size, position)
		return scope:New("Frame")({
			Name = name,
			Size = size,
			AnchorPoint = CENTERED_ANCHOR_POINT,
			Position = position,
			BackgroundColor3 = color,
			[Children] = {
				scope:New("UIStroke")({
					Color = strokeColor,
					Thickness = strokeThickness,
					Transparency = strokeTransparency,
				}),
			},
		})
	end

	return scope:New("Frame")({
		Name = "CursorContainer",
		Parent = props.Parent,
		Position = props.Position,
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = CENTERED_ANCHOR_POINT,
		BackgroundTransparency = 1,
		ZIndex = zIndex,

		[Children] = {
			-- Top Segment
			createSegment(
				"TopSegment",
				UDim2.fromOffset(segmentSize.X, segmentSize.Y),
				scope:Computed(function(use)
					return UDim2.new(0.5, 0, 0.5, -use(props.Spread) - segmentSize.Y)
				end)
			),
			-- Bottom Segment
			createSegment(
				"BottomSegment",
				UDim2.fromOffset(segmentSize.X, segmentSize.Y),
				scope:Computed(function(use)
					return UDim2.new(0.5, 0, 0.5, use(props.Spread) + segmentSize.Y)
				end)
			),
			-- Left Segment
			createSegment(
				"LeftSegment",
				UDim2.fromOffset(segmentSize.Y, segmentSize.X),
				scope:Computed(function(use)
					return UDim2.new(0.5, -use(props.Spread) - segmentSize.Y, 0.5, 0)
				end)
			),
			-- Right Segment
			createSegment(
				"RightSegment",
				UDim2.fromOffset(segmentSize.Y, segmentSize.X),
				scope:Computed(function(use)
					return UDim2.new(0.5, use(props.Spread) + segmentSize.Y, 0.5, 0)
				end)
			),
		},
	})
end

return Cursor
