-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local BaseResources = require(ReplicatedStorage.Classes.Bases.BaseResources)
local BridgeNet2 = require(ReplicatedStorage.Packages.BridgeNet2)

-- Variables
local UpdateEntityResourceBridge = BridgeNet2.ServerBridge("UpdateEntityResource")

local ServerResources = setmetatable({}, BaseResources)
ServerResources.__index = ServerResources

function ServerResources.new(entity)
	local self = setmetatable(BaseResources.new(entity), ServerResources)

	self:setup()

	return self
end

function ServerResources:setup()
	self.trove:Connect(self.resourcesDataChanged, function(resourceName, resourceData)
		UpdateEntityResourceBridge:Fire(BridgeNet2.AllPlayers(), {
			entityId = self.entity.id,
			resourceName = resourceName,
			resourceData = resourceData,
		})
	end)
end

return ServerResources
