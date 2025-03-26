local ContextActionService = game:GetService "ContextActionService"
local Players = game:GetService "Players"

local app = require "./app"
local conch = require "../roblox_packages/conch"
local state = require "./state"
local vide = require "../roblox_packages/vide"

local mounted = false
local opened, focused = state.opened, state.focused

local function mount()
	if mounted then return end
	mounted = true
	return vide.mount(app, Players.LocalPlayer:WaitForChild "PlayerGui")
end

local function bind_to(input: Enum.KeyCode | Enum.UserInputType)
	mount()
	ContextActionService:BindAction("Trigger Conch", function(_, state)
		if state == Enum.UserInputState.Begin then
			opened(not opened())
			focused(opened())
		end
	end, false, input)
end

return {

	app = app,
	mount = mount,
	opened = opened,

	bind_to = bind_to,

	conch = conch,
}
