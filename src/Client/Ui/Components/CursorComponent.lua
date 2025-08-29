local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local CENTERED_ANCHOR_POINT = Vector2.new(.5,.5)

--[[
	A customizable cursor component with four segments that can spread.
	@param scope Fusion.Scope
	@param props {
		Spread: Fusion.Value<number>,
		SpreadGoal: Fusion.Value<number>,
		Color: Color3?,
		SegmentSize: Vector2?,
		ZIndex: number?,
		Stroke: {
			Color: Color3?,
			Thickness: number?,
			Transparency: number?
		}?,
		Utility: table?
	}
	@returns Frame
]]
return function(scope, props)
	local utility = props.Utility
	local Children = utility.Fusion.Children
	local peek = utility.Fusion.peek
	local spread = props.Spread
	local color = props.Color or Color3.new(1, 1, 1)
	local segmentSize = props.SegmentSize or Vector2.new(2, 5)
	local zIndex = props.ZIndex or 10
	local strokeProps = props.Stroke or {}
	local strokeColor = strokeProps.Color or Color3.new(0, 0, 0)
	local strokeThickness = strokeProps.Thickness or 1
	local strokeTransparency = strokeProps.Transparency or 0.5

	-- Helper function to create a segment with stroke
	local function createSegment(name, size, position)
		return scope:New "Frame" {
			Name = name,
			Size = size,
			AnchorPoint = CENTERED_ANCHOR_POINT,
			Position = position,
			BackgroundColor3 = color,
			[Children] = {
				scope:New "UIStroke" {
					Color = strokeColor,
					Thickness = strokeThickness,
					Transparency = strokeTransparency,
				}
			}
		}
	end

	local container = scope:New "Frame" {
		Name = "CursorContainer",
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = CENTERED_ANCHOR_POINT,
		Position = UDim2.fromScale(.5, .5),
		BackgroundTransparency = 1,
		ZIndex = zIndex,

		[Children] = {
			-- Top Segment
			createSegment(
				"TopSegment",
				UDim2.fromOffset(segmentSize.X, segmentSize.Y),
				scope:Computed(function(use)
					return UDim2.new(0.5, 0, 0.5, -use(spread)-segmentSize.Y)
				end)
			),
			-- Bottom Segment
			createSegment(
				"BottomSegment",
				UDim2.fromOffset(segmentSize.X, segmentSize.Y),
				scope:Computed(function(use)
					return UDim2.new(0.5, 0, 0.5, use(spread)+segmentSize.Y)
				end)
			),
			-- Left Segment
			createSegment(
				"LeftSegment",
				UDim2.fromOffset(segmentSize.Y, segmentSize.X),
				scope:Computed(function(use)
					return UDim2.new(0.5, -use(spread)-segmentSize.Y, 0.5, 0)
				end)
			),
			-- Right Segment
			createSegment(
				"RightSegment",
				UDim2.fromOffset(segmentSize.Y, segmentSize.X),
				scope:Computed(function(use)
					return UDim2.new(0.5, use(spread)+segmentSize.Y, 0.5, 0)
				end)
			),
		},
	}

	local component = {}

	component.Container = container
	component.Spread = spread

	return component
end