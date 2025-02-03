--!strict
local Item = {}

-- Signal
local Signal = require(game:GetService("ReplicatedStorage").Packages.signal)
-- Event
Item.BeganEvent = Signal.new()
Item.EndedEvent = Signal.new()
-- Constants
local KEYBOARD_KEYS = {
	THROW = Enum.KeyCode.Q
}

local GAMEPAD_KEYS = {
    THROW = Enum.KeyCode.ButtonL1
}

local function checkInput(input)
	for name,key in KEYBOARD_KEYS do
		local pressed = false
		if input.KeyCode == key then
			pressed = true
		end
		if GAMEPAD_KEYS[name] == input.KeyCode then
			pressed = true
		end

		if pressed then
			return name
		end
	end
end

function Item.Start(inputs)
	inputs.events.InputBegan:Connect(function(input)
		local name = checkInput(input)
		if name then
			Item.BeganEvent:Fire(name)
		end
	end)
	
	inputs.events.InputEnded:Connect(function(input)
		local name = checkInput(input)
		if name then
			Item.EndedEvent:Fire(name)
		end
	end)
end

return Item