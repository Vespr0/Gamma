local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.fusion)

local OnEvent = Fusion.OnEvent
local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

local function Button(
	scope: Fusion.Scope<typeof(Fusion)>,
	props: {
		Parent: GuiObject?,
		Size: UsedAs<UDim2>,

		Color: UsedAs<Color3>,
		Text: UsedAs<string>,
		TextColor: UsedAs<string>?,

		OnActivate: UsedAs<() -> ()>?,
	}
)
	return scope:New("TextButton")({
		Parent = props.Parent,
		Size = props.Size,

		BackgroundColor3 = props.Color,

		[OnEvent("Activated")] = props.OnActivate,

		[Children] = {
			scope:New("TextLabel")({
				BackgroundTransparency = 1,

				Font = Enum.Font.BuilderSans,
				TextColor3 = props.TextColor or Color3.fromRGB(255, 255, 255),
				Text = props.Text,
				TextScaled = true,

				Size = UDim2.fromScale(1, 1),

				[Children] = {
					scope:New("UIStroke")({
						Color = Color3.fromRGB(0, 0, 0),
						Thickness = 1,
						Transparency = 0.4,
					}),
				},
			}),
			scope:New("UIStroke")({
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(15, 15, 15),
				Thickness = 1.25,
				Transparency = 0.2,
			}),
			scope:New("UICorner")({
				CornerRadius = UDim.new(0.075, 0),
			}),
			scope:New("UIGradient")({
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(0.9, Color3.fromRGB(180, 180, 180)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(215, 215, 215)),
				}),
			}),
		},
	})
end

return Button
