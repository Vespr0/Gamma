local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.fusion)
local PlayerList = require(ReplicatedStorage.UI.Components.PlayerList)
local Timer = require(ReplicatedStorage.UI.Components.Timer)

local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

type PlayerData = {
	Image: UsedAs<string>,
	OverlayText: UsedAs<string>?,
	OverlayColor: UsedAs<Color3>?,
}

type EventData = {
	Title: string,
	Start: number,
}

local function TopBar(
	scope: Fusion.Scope<typeof(Fusion)>,
	props: {
		Parent: GuiObject?,
		Players: { PlayerData },
		Event: UsedAs<EventData>,
		PlayerListVisible: UsedAs<boolean>,
	}
)
	local titleState = scope:Computed(function(use)
		local event = use(props.Event)
		return event and event.Title
	end)
	local startState = scope:Computed(function(use)
		local event = use(props.Event)
		return event and event.Start
	end)
	local barSize = scope:Computed(function(use)
		local playerListVisible = use(props.PlayerListVisible)
		local barWidth = playerListVisible and 0.4 or 0.2
		return UDim2.new(barWidth, 20, 0.01, 40)
	end)

	return scope:New("Frame")({
		Name = "TopBar",
		Parent = props.Parent,
		Position = UDim2.new(0.5, 0, 0, 5),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.5,
		Size = barSize,

		[Children] = {
			scope:New("UIListLayout")({
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10),
			}),
			-- scope:New("TextLabel")({
			-- 	Text = "🌻",
			-- 	Size = UDim2.new(0.1, 0, 1, 0),
			-- 	TextScaled = true,
			-- 	BackgroundTransparency = 1,
			-- 	[Children] = {
			-- 		scope:New("UIAspectRatioConstraint")({}),
			-- 	},
			-- }),
			scope:New("UICorner")({
				CornerRadius = UDim.new(1, 0),
			}),
			Timer(scope, {
				Size = UDim2.new(0.3, 20, 0.8, 0),
				Title = titleState,
				Start = startState,
				LayoutOrder = 0,
			}),
			PlayerList(scope, {
				Size = UDim2.new(0.4, 0, 1, 0),
				Players = props.Players,
				LayoutOrder = 1,
				Visible = props.PlayerListVisible,
			}),
		},
	})
end

return TopBar
