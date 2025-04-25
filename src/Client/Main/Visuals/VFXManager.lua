local VFXManager = {}

local instances = {}

function VFXManager.GetModule(moduleName: string)
    if instances[moduleName] then
        return instances[moduleName]
    end

    local module = require(script.Parent.VFXModules[moduleName.."VFX"])

    if not module then
        warn("VFXManager: Module '"..moduleName.."' not found.")
        return nil
    end

    instances[moduleName] = module.new()
    return instances[moduleName]
end

return VFXManager