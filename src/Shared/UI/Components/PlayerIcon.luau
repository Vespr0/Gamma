local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.fusion)

local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

local function PlayerIcon(
	scope: Fusion.Scope<typeof(Fusion)>,
	props: {
		Parent: GuiObject?,
		Size: UsedAs<UDim2>,
		Image: UsedAs<string>,
		OverlayText: UsedAs<string>?,
		OverlayColor: UsedAs<Color3>?,
	}
)
	return scope:New("ImageLabel")({
		Parent = props.Parent,
		Size = props.Size,
		Image = props.Image,
		BackgroundTransparency = 1,

		[Children] = {
			scope:New("UICorner")({
				CornerRadius = UDim.new(1, 0),
			}),
			scope:New("UIAspectRatioConstraint")({}),
			scope:New("TextLabel")({
				Visible = props.OverlayText and true or false,
				Text = props.OverlayText or "",
				TextColor3 = props.OverlayColor or Color3.fromRGB(255, 255, 255),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.5,
				Size = UDim2.fromScale(1, 1),
				Font = Enum.Font.RobotoMono,
				TextScaled = true,
				[Children] = {
					scope:New("UICorner")({
						CornerRadius = UDim.new(1, 0),
					}),
				},
			}),
		},
	})
end

return PlayerIcon
