local ServerResources = {}
ServerResources.__index = ServerResources

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Modules
local Trove = require(ReplicatedStorage.Packages.trove)
local BridgeNet2 = require(ReplicatedStorage.Packages.BridgeNet2)
local UpdateEntityResourceBridge = BridgeNet2.ClientBridge("UpdateEntityResource")

function ServerResources.new(entity)
	local self = setmetatable({}, ServerResources)

	-- Components
	self.entity = entity
	self.trove = Trove.new()

	self:setup()

	return self
end

function ServerResources:addResource() end

function ServerResources:setup()
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

function ServerResources:destroy()
	self.trove:Destroy()
end

return ServerResources
