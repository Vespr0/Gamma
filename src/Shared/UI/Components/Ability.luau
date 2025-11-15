local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.fusion)
local InputInfo = require(ReplicatedStorage.UI.Components.InputInfo)
local Assets = require(ReplicatedStorage.Assets) -- Require Assets module

local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

local function Ability(
	scope: Fusion.Scope<typeof(Fusion)>,
	props: {
		Parent: GuiObject?,
		Size: UsedAs<UDim2>,
		Position: UsedAs<UDim2>?,
		AnchorPoint: UsedAs<Vector2>?,
		LayoutOrder: UsedAs<number>?,

		InputKey: UsedAs<string>,
		Icon: UsedAs<string>, -- New prop for the icon name
	}
)
	local iconImage = scope:Computed(function(use)
		local iconName = use(props.Icon)
		return Assets.GetTexture(iconName)
	end)

	local imageColor = scope:Computed(function(use)
		local isDisabled = use(props.Disabled)
		return if isDisabled then Color3.fromRGB(53, 53, 53) else Color3.fromRGB(255, 255, 255)
	end)

	local imageBackgroundColor = scope:Computed(function(use)
		local isDisabled = use(props.Disabled)
		return if isDisabled then Color3.fromRGB(7, 7, 7) else Color3.fromRGB(43, 43, 43)
	end)

	return scope:New("Frame")({
		Parent = props.Parent,
		Size = props.Size,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		LayoutOrder = props.LayoutOrder,
		BackgroundTransparency = 1,

		[Children] = {
			scope:New("UIAspectRatioConstraint")({}),
			scope:New("ImageLabel")({ -- Replaced ViewportFrame with ImageLabel
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = imageBackgroundColor,
				Image = iconImage, -- Set image from Assets.GetTexture
				ImageColor3 = imageColor, -- Set color based on disabled state
				BackgroundTransparency = 0,

				[Children] = {
					scope:New("UICorner")({
						CornerRadius = UDim.new(1, 0),
					}),
				},
			}),
			InputInfo(scope, {
				Size = UDim2.fromScale(0.4, 0.4),
				Position = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(1, 1),
				InputKey = props.InputKey,
				Disabled = props.Disabled,
			}),
		},
	})
end

return Ability
