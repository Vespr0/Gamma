-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local BaseResources = require(ReplicatedStorage.Classes.Bases.BaseResources)
local Trove = require(ReplicatedStorage.Packages.trove)
local BridgeNet2 = require(ReplicatedStorage.Packages.BridgeNet2)

-- Variables
local GetAllEntityResourcesBridge = BridgeNet2.ClientBridge("GetAllEntityResources")
local UpdateEntityResourceBridge = BridgeNet2.ClientBridge("UpdateEntityResource")

local ClientResources = setmetatable({}, BaseResources)
ClientResources.__index = ClientResources

function ClientResources.new(entity)
	local self = setmetatable(BaseResources.new(entity), ClientResources)

	self:setup()

	return self
end

function ClientResources:setup()
	GetAllEntityResourcesBridge:Fire(self.entity.id)

	self.trove:Connect(GetAllEntityResourcesBridge, function(payload)
		if self.entity.id ~= payload.entityId then
			return
		end

		for resourceName, resourceData in payload.data do
			self:setResource(resourceName, resourceData)
		end
	end)

	self.trove:Connect(UpdateEntityResourceBridge, function(update)
		if self.entity.id ~= update.entityId then
			return
		end

		self:setResource(update.resourceName, update.resourceData)
	end)
end

return ClientResources
