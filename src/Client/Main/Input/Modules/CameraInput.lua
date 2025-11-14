local Camera = {}

-- Event
Camera.Event = require(game:GetService("ReplicatedStorage").Packages.signal).new()

-- Modules
local ClientAnima = require(script.Parent.Parent.Parent.Player.ClientAnima):get()

local KEYS = {
	-- PC
	Enum.KeyCode.M,
	-- Controller
	Enum.KeyCode.ButtonR3, -- RSB (Right Stick Button)
}

local function getMatch(input)
	return table.find(KEYS, input.KeyCode)
end

function Camera.Start(inputs)
	local camera = ClientAnima.camera
	inputs.events.InputBegan:Connect(function(input)
		if not getMatch(input) then
			return
		end

		local mode = camera.mode
		if mode == "FirstPerson" then
			camera:setMode("ThirdPerson")
		else
			camera:setMode("FirstPerson")
		end
	end)
end

return Camera
