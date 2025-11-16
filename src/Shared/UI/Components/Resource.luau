local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.fusion)

local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

local function Resource(
	scope: Fusion.Scope<typeof(Fusion)>,
	props: {
		Parent: GuiObject?,
		LayoutOrder: UsedAs<number>?,
		Size: UsedAs<UDim2>,

		Name: UsedAs<string>,
		Amount: UsedAs<number>,
		MaxAmount: UsedAs<number>,
	}
)
	local resourceText = scope:Computed(function(use)
		local amount = use(props.Amount)
		local maxAmount = use(props.MaxAmount)
		return string.format("%d/%d", amount, maxAmount)
	end)

	local resourceColor = scope:Computed(function(use)
		local amount = use(props.Amount)
		return amount ~= 0 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 9, 9)
	end)

	return scope:New("Frame")({
		Parent = props.Parent,
		Size = props.Size,
		LayoutOrder = props.LayoutOrder,
		BackgroundTransparency = 0.3,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),

		[Children] = {
			scope:New("UICorner")({
				CornerRadius = UDim.new(0.2, 0),
			}),
			scope:New("UIPadding")({
				PaddingLeft = UDim.new(0, 4),
				PaddingRight = UDim.new(0, 4),
				PaddingTop = UDim.new(0, 4),
				PaddingBottom = UDim.new(0, 4),
			}),
			scope:New("UIListLayout")({}),
			scope:New("TextLabel")({
				Name = "Amount",
				Text = resourceText,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0.6, 0),
				Position = UDim2.new(0, 0, 0.6, 0),
				BackgroundTransparency = 1,
				Font = Enum.Font.RobotoMono,
				TextColor3 = resourceColor,
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
			}),
			scope:New("TextLabel")({
				Name = "Name",
				Text = string.upper(props.Name),
				Size = UDim2.new(1, 0, 0.4, 0),
				Position = UDim2.new(0, 0, 0, 0),
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Font = Enum.Font.Roboto,
				TextColor3 = Color3.fromRGB(179, 179, 179),
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
			}),
		},
	})
end

return Resource
