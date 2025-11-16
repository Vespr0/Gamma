local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.fusion)
local Resource = require(script.Parent.Resource)

local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

type ResourceData = {
	Name: string,
	Amount: number,
	MaxAmount: number,
}

local function ResourcesHolder(
	scope: Fusion.Scope<typeof(Fusion)>,
	props: {
		Parent: GuiObject?,
		Resources: UsedAs<{ ResourceData }>,
	}
)
	return scope:New("Frame")({
		Parent = props.Parent,
		Size = UDim2.new(0.05, 30, 0.3, 0),
		Position = UDim2.new(1, -5, 1, -5),
		AnchorPoint = Vector2.new(1, 1),
		BackgroundTransparency = 1,

		[Children] = {
			scope:New("UIListLayout")({
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10),
			}),
			scope:ForValues(props.Resources, function(use, scope, resourceData, index)
				return Resource(scope, {
					Size = UDim2.new(1, 0, 0, 40),
					Name = resourceData.Name,
					Amount = resourceData.Amount,
					MaxAmount = resourceData.MaxAmount,
					LayoutOrder = index,
				})
			end),
		},
	})
end

return ResourcesHolder
