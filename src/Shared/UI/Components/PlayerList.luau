local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.fusion)
local PlayerIcon = require(ReplicatedStorage.UI.Components.PlayerIcon)

local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>
type PlayerData = {
	Image: UsedAs<string>,
	OverlayText: UsedAs<string>?,
	OverlayColor: UsedAs<Color3>?,
}

local function PlayerList(
	scope: Fusion.Scope<typeof(Fusion)>,
	props: {
		Parent: GuiObject?,
		Size: UsedAs<UDim2>,
		Position: UsedAs<UDim2>,
		AnchorPoint: UsedAs<Vector2>,
		Players: UsedAs<{ PlayerData }>,
		LayoutOrder: UsedAs<number>,
		Visible: UsedAs<boolean>,
	}
)
	return scope:New("Frame")({
		Parent = props.Parent,
		Size = props.Size,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		Visible = props.Visible,
		[Children] = {
			scope:New("UIListLayout")({
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 5),
			}),
			scope:ForValues(props.Players, function(use, scope, playerData)
				return PlayerIcon(scope, {
					Size = UDim2.fromScale(0.5, 1),
					Image = playerData.Image,
					OverlayText = playerData.OverlayText or "",
					OverlayColor = playerData.OverlayColor or Color3.new(1, 1, 1),
				})
			end),
		},
	})
end

return PlayerList
