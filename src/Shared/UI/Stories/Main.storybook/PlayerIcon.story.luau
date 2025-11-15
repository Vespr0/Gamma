local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.fusion)
local PlayerIcon = require(ReplicatedStorage.UI.Components.PlayerIcon)

local controls = {
	Image = "rbxassetid://0",
	OverlayText = "RIP",
	OverlayColor = Color3.fromRGB(255, 0, 0),
}

return {
	fusion = Fusion,
	controls = controls,
	story = function(props)
		local scope = props.scope

		local _component = PlayerIcon(scope, {
			Parent = props.target,
			Size = UDim2.new(0, 100, 0, 100),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Image = props.controls.Image,
			OverlayText = props.controls.OverlayText,
			OverlayColor = props.controls.OverlayColor,
		})
	end,
}
