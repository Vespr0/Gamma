local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Trove = require(ReplicatedStorage.Packages.trove)
local Signal = require(ReplicatedStorage.Packages.signal)

export type ResourceData = {
	displayName: string,
	type: string, -- e.g., "Ammo", "Grenade"
	amount: number,
	maxAmount: number,
}

local BaseResources = {}
BaseResources.__index = BaseResources

function BaseResources.new(entity)
	local self = setmetatable({}, BaseResources)

	self.trove = Trove.new()
	self.entity = entity

	self.resourcesData = {}
	self.resourcesDataChanged = Signal.new()

	return self
end

function BaseResources:setResource(resourceName, resourceData: ResourceData)
	self.resourcesData[resourceName] = resourceData
	self:onResourceChanged(resourceName, self.resourcesData[resourceName])
end

function BaseResources:incrementResource(resourceName: string, amount: number)
	local resourceData = self.resourcesData[resourceName] :: ResourceData
	if not resourceData then
		warn("Cannot increment non-existent resource: " .. resourceName)
		return
	end
	resourceData.amount = math.min(resourceData.amount + (amount or 1), resourceData.maxAmount)
	self:onResourceChanged(resourceName, resourceData)
end

function BaseResources:decrementResource(resourceName, amount)
	self:incrementResource(resourceName, -amount)
end

function BaseResources:restoreResource(resourceName)
	local resource = self.resourcesData[resourceName] :: ResourceData
	if not resource then
		warn("Cannot restore non-existent resource: " .. resourceName)
		return
	end
	resource.amount = resource.maxAmount
	self:onResourceChanged(resourceName, resource)
end

function BaseResources:onResourceChanged(resourceName, resourceData)
	-- TODO: Add error checking
	self.resourcesDataChanged:Fire(resourceName, resourceData)
end

function BaseResources:destroy() end

return BaseResources
