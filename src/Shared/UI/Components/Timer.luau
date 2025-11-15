local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.fusion)

local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

local function Timer(
	scope: Fusion.Scope<typeof(Fusion)>,
	props: {
		Parent: GuiObject?,
		Size: UsedAs<UDim2>,
		Title: UsedAs<string>,
		Start: UsedAs<number>,
		LayoutOrder: UsedAs<number>,
	}
)
	local now = scope:Value(os.clock())

	table.insert(
		scope,
		RunService.RenderStepped:Connect(function()
			now:set(os.clock())
		end)
	)

	return scope:New("Frame")({
		BackgroundTransparency = 1,
		Parent = props.Parent,
		Size = props.Size,
		LayoutOrder = props.LayoutOrder,

		[Children] = {
			scope:New("UIListLayout")({
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
			scope:New("TextLabel")({
				Text = props.Title,
				TextColor3 = Color3.fromRGB(200, 200, 200),
				TextXAlignment = Enum.TextXAlignment.Center,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0.4),
				Font = Enum.Font.Roboto,
				TextScaled = true,
			}),
			scope:New("TextLabel")({
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextXAlignment = Enum.TextXAlignment.Center,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0.6),
				Font = Enum.Font.RobotoMono,
				TextScaled = true,

				Text = scope:Computed(function(use)
					local time = use(props.Start) - use(now)
					local remainingTime = math.max(0, time)

					local minutes = math.floor(remainingTime / 60)
					local seconds = math.floor(remainingTime % 60)
					return string.format("%02d:%02d", minutes, seconds)
				end),
			}),
		},
	})
end

return Timer
