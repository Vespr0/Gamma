--!strict
local Hotbar = {}

-- Signal
local Signal = require(game:GetService("ReplicatedStorage").Packages.signal)
-- Event
Hotbar.Event = Signal.new()
-- Constants
local NUMBER_KEYS = {
    Enum.KeyCode.One,
    Enum.KeyCode.Two,
    Enum.KeyCode.Three,
    Enum.KeyCode.Four,
    Enum.KeyCode.Five,
    Enum.KeyCode.Six,
    Enum.KeyCode.Seven,
    Enum.KeyCode.Eight,
    Enum.KeyCode.Nine
}

local GAMEPAD_KEYS = {
    RIGHT = Enum.KeyCode.DPadRight,
    LEFT = Enum.KeyCode.DPadLeft,
}

function Hotbar.Start(inputs)
   inputs.events.InputBegan:Connect(function(input)
        local index = table.find(NUMBER_KEYS, input.KeyCode)
        if index then
            Hotbar.Event:Fire(false,index)
        end

        local controllerForward = GAMEPAD_KEYS.RIGHT == input.KeyCode
        local controllerBackward = GAMEPAD_KEYS.LEFT == input.KeyCode
        if controllerForward then
            Hotbar.Event:Fire(true,1)
        end
        if controllerBackward then
            Hotbar.Event:Fire(true,-1)
        end
   end)
end

return Hotbar