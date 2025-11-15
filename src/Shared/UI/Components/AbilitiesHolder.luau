local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.fusion)
local Ability = require(ReplicatedStorage.UI.Components.Ability)

local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

type AbilityData = {
	InputKey: string,
	Icon: string,
	Disabled: boolean?,
}

local function AbilitiesHolder(
	scope: Fusion.Scope<typeof(Fusion)>,
	props: {
		Parent: GuiObject?,
		Abilities: UsedAs<{ AbilityData }>,
	}
)
	return scope:New("Frame")({
		Parent = props.Parent,
		Size = UDim2.new(0.3, 0, 0.1, 5),
		Position = UDim2.new(1, 0, 1, 0),
		AnchorPoint = Vector2.new(1, 1),
		BackgroundTransparency = 1,

		[Children] = {
			scope:New("UIPadding")({
				PaddingBottom = UDim.new(0, 5),
				PaddingRight = UDim.new(0, 5),
			}),
			scope:New("UIListLayout")({
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10),
			}),
			scope:ForValues(props.Abilities, function(use, scope, abilityData, index)
				return Ability(scope, {
					Size = UDim2.fromScale(0.3, 1),
					InputKey = abilityData.InputKey,
					Icon = abilityData.Icon,
					Disabled = abilityData.Disabled,
					LayoutOrder = index,
				})
			end),
		},
	})
end
return AbilitiesHolder
