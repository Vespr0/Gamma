-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local BaseResources = require(ReplicatedStorage.Classes.Bases.BaseResources)
local Trove = require(ReplicatedStorage.Packages.trove)
local BridgeNet2 = require(ReplicatedStorage.Packages.BridgeNet2)

-- Variables
local UpdateEntityResourceBridge = BridgeNet2.ClientBridge("UpdateEntityResource")

local ClientResources = setmetatable({}, BaseResources)
ClientResources.__index = ClientResources

function ClientResources.new(entity)
	local self = setmetatable(BaseResources.new(entity), ClientResources)

	self:setup()

	return self
end

function ClientResources:setup()
	self.trove:Connect(UpdateEntityResourceBridge, function(data)
		warn(data)

		local entityId = data.entityId
		local resourceName = data.resourceName
		local resourceData = data.resourceData

		if self.entity.id ~= entityId then
			return
		end

		self:setResource(resourceName, resourceData)
		warn(resourceName, resourceData)
	end)
end

return ClientResources
