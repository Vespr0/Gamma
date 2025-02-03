--!strict
local Sprinting = {}

-- Event
Sprinting.Event = require(game:GetService("ReplicatedStorage").Packages.signal).new()

local KEYS = {
    -- PC
    --Enum.KeyCode.LeftControl,
    Enum.KeyCode.LeftShift,
    -- Controller
    Enum.KeyCode.ButtonL2,
}

local function getMatch(input)
    return table.find(KEYS, input.KeyCode)
end

function Sprinting.Start(inputs)
   inputs.events.InputBegan:Connect(function(input)
        if not getMatch(input) then return end
        Sprinting.Event:Fire(true)
   end)
   inputs.events.InputEnded:Connect(function(input)
        if not getMatch(input) then return end
        Sprinting.Event:Fire(false)
   end)
end

return Sprinting