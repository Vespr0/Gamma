--!strict
local Crouching = {}

-- Event
Crouching.Event = require(game:GetService("ReplicatedStorage").Packages.signal).new()

local KEYS = {
    -- PC
    --Enum.KeyCode.LeftControl,
    Enum.KeyCode.LeftControl,
    -- Controller
    Enum.KeyCode.ButtonL3, -- LSB (Left Stick Button)
}

local function getMatch(input)
    return table.find(KEYS, input.KeyCode)
end

function Crouching.Start(inputs)
   inputs.events.InputBegan:Connect(function(input)
        if not getMatch(input) then return end
        Crouching.Event:Fire(true)
   end)
   inputs.events.InputEnded:Connect(function(input)
        if not getMatch(input) then return end
        Crouching.Event:Fire(false)
   end)
end

return Crouching