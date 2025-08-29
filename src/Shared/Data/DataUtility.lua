local DataUtility = {}

-- History:

--[[

    ??

]]

local DATA_SCOPES = {
	Player = "PLAYER#1", 
}

function DataUtility.GetDataScope(name)
	return DATA_SCOPES[name]
end

return DataUtility
