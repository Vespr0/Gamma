local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.fusion)
local TopBar = require(ReplicatedStorage.UI.Components.TopBar)

local PLAYERS = {
	{ Image = "rbxassetid://0" },
	{ Image = "rbxassetid://0", OverlayText = "RIP", OverlayColor = Color3.fromRGB(255, 0, 0) },
	{ Image = "rbxassetid://0" },
	{ Image = "rbxassetid://0" },
}

local controls = {
	Title = "INTERMISSION",
	Start = os.clock() + 120,
	PlayerListVisible = true,
}

return {
	fusion = Fusion,
	controls = controls,
	story = function(props)
		local scope = props.scope

		local eventState = scope:Computed(function(use)
			return {
				Title = use(props.controls.Title),
				Start = use(props.controls.Start),
			}
		end)

		local _component = TopBar(scope, {
			Parent = props.target,
			Players = PLAYERS,
			Event = eventState,
			PlayerListVisible = props.controls.PlayerListVisible,
		})
	end,
}
