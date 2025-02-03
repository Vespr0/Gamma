--!strict
local Safety = {}

-- Services
local RunService = game:GetService("RunService")

local TIMEOUT = 50

-- Function to wait for a instance that may not be instanced yet
function Safety.WaitForInstance(source,name)
	local t = 0
	local value
	repeat
		RunService.RenderStepped:Wait()
		t += 1
		value = source[name]
	until value or t > TIMEOUT
	
	if t > TIMEOUT then
		error(`Timeout while looking for instance from source "{source}" named "{name}" `)
	end
	if not value then
		error(`No instance found from source "{source}" named "{name}" `)
	end
end

return Safety
