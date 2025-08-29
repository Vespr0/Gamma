local ConfigUtility = {}

local Configs = script.Parent

function ConfigUtility.GetConfig(folderName, entryName)
	local folder = Configs:FindFirstChild(folderName)
    assert(folder, "Folder not found: " .. folderName)

    -- Search all descendants
    local module = folder:FindFirstChild(entryName, true)
    if module then
        return require(module)
    end

    warn(`Couldn't find config for "{entryName}" in Configs/{folderName}/`)
    return nil
end

return ConfigUtility