local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.fusion)
local Assets = require(ReplicatedStorage.Assets) -- Require Assets module

local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

local function InputInfo(
	scope: Fusion.Scope<typeof(Fusion)>,
	props: {
		Parent: GuiObject?,
		Size: UsedAs<UDim2>,
		Position: UsedAs<UDim2>,
		AnchorPoint: UsedAs<Vector2>,
		InputKey: UsedAs<string>,
		Disabled: UsedAs<boolean>,
	}
)
	local imageUrl = scope:Computed(function(use)
		local key = use(props.InputKey)
		return Assets.GetTexture(key)
	end)

	local imageColor = scope:Computed(function(use)
		local isDisabled = use(props.Disabled)
		return isDisabled and Color3.fromRGB(49, 5, 5) or Color3.fromRGB(255, 255, 255)
	end)

	return scope:New("ImageLabel")({
		Parent = props.Parent,
		Size = props.Size,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		Image = imageUrl,
		ImageColor3 = imageColor,
		BackgroundTransparency = 1,

		[Children] = {
			scope:New("UIAspectRatioConstraint")({
				AspectRatio = 1,
			}),
		},
	})
end

return InputInfo
