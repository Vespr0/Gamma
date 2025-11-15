local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Fusion = require(Packages.fusion)

local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

type UsedAs<T> = Fusion.UsedAs<T>

local function Slot(
	scope: Fusion.Scope<typeof(Fusion)>,
	props: {
		Parent: GuiObject?,
		LayoutOrder: UsedAs<number>,
		Number: UsedAs<number>,
		Tool: UsedAs<Instance>,
		Focused: UsedAs<boolean>,
		GetItemViewport: (Instance, ViewportFrame) -> (),
	}
)
	local position = scope:Computed(function(use)
		return if use(props.Focused) then UDim2.new(0.5, 0, 0.5, -10) else UDim2.fromScale(0.5, 0.5)
	end)

	local viewport = scope:New("ViewportFrame")({
		Name = "Viewport",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.5,
		[Children] = {
			scope:New("UICorner")({
				CornerRadius = UDim.new(0.5, 0),
			}),
		},
	})

	local numberString = scope:Computed(function(use)
		local number = use(props.Number)
		return tostring(number)
	end)

	local slotName = scope:Computed(function(use)
		local number = use(props.Number)
		return "Slot" .. tostring(number)
	end)

	props.GetItemViewport(props.Tool, viewport)

	return scope:New("Frame")({
		Name = slotName,
		Parent = props.Parent,
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.new(0.5, 0, 1, 0),
		BackgroundTransparency = 1,
		[Children] = {
			scope:New("UIAspectRatioConstraint")({}),
			scope:New("Frame")({
				Name = "Inner",
				Position = position,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,

				[Children] = {
					scope:New("TextLabel")({
						Name = "Number",
						Text = numberString,
						Size = UDim2.fromScale(0.4, 0.4),
						Position = UDim2.fromScale(0.5, 1),
						AnchorPoint = Vector2.new(0.5, 1),
						ZIndex = 3,
						BackgroundTransparency = 1,
						TextColor3 = Color3.new(1, 1, 1),
						Font = Enum.Font.RobotoMono,
						TextScaled = true,
					}),
					viewport,
				},
			}),
		},
	})
end

return Slot
