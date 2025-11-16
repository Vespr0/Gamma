local ClientResources = {}
ClientResources.__index = ClientResources

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Modules
local Trove = require(ReplicatedStorage.Packages.trove)
local BridgeNet2 = require(ReplicatedStorage.Packages.BridgeNet2)
local UpdateEntityResourceBridge = BridgeNet2.ClientBridge("UpdateEntityResource")

function ClientResources.new(entity)
	local self = setmetatable({}, ClientResources)

	-- Components
	self.entity = entity
	self.trove = Trove.new()

	self:setup()

	return self
end

function ClientResources:setup()
	self.trove:Connect(UpdateEntityResourceBridge, function(data)
		local entityId = data.entityId
		local resourceName = data.resourceName
		local resourceData = data.resourceData

		if self.entity.entityId ~= entityId then
			return
		end

		self.entity.resources[resourceName] = resourceData
		-- Fire the signal to notify listeners that resources have changed
		self.entity.resourcesChanged:Fire(self.entity.resources)
	end)
end

function ClientResources:destroy()
	self.trove:Destroy()
end

return ClientResources
