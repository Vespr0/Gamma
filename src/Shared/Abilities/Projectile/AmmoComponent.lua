--!nocheck
local AmmoComponent = {}
AmmoComponent.__index = AmmoComponent

function AmmoComponent.new(ability, entity)
	local self = setmetatable({}, AmmoComponent)
	self.ability = ability
	self.entity = entity
	return self
end

function AmmoComponent:setupResource()
	local ability = self.ability
	ability.resourceName = ability.tool.Name .. "Ammo"

	if ability.isServer and ability.abilityConfig.maxAmmo then
		local displayName = ability.abilityConfig.resourceDisplayName or ability.tool.Name .. " Ammo"
		self.entity.resources:setResource(ability.resourceName, {
			displayName = displayName,
			type = "Ammo",
			amount = ability.abilityConfig.maxAmmo,
			maxAmount = ability.abilityConfig.maxAmmo,
		})
	end
end

function AmmoComponent:isOutOfAmmo()
	local ability = self.ability
	if ability.abilityConfig.maxAmmo then
		return self.entity.resources:isResourceEmpty(ability.resourceName)
	end
	return false
end

function AmmoComponent:decrementAmmo()
	local ability = self.ability
	if not ability.isServer then
		return
	end
	if ability.abilityConfig.maxAmmo then
		self.entity.resources:decrementResource(ability.resourceName, 1)
	end
end

return AmmoComponent
