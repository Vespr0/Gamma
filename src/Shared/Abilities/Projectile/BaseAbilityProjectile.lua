--!nocheck
local BaseAbilityProjectile = {}

function BaseAbilityProjectile:setupResource()
	self.resourceName = self.tool.Name .. "Ammo"

	if self.isServer and self.abilityConfig.maxAmmo then
		local displayName = self.abilityConfig.resourceDisplayName or self.tool.Name .. " Ammo"
		self.entity.resources:setResource(self.resourceName, {
			displayName = displayName,
			type = "Ammo",
			amount = self.abilityConfig.maxAmmo,
			maxAmount = self.abilityConfig.maxAmmo,
		})
	end
end

function BaseAbilityProjectile:isOutOfAmmo()
	if self.abilityConfig.maxAmmo then
		return self.entity.resources:isResourceEmpty(self.resourceName)
	end
	return false
end

function BaseAbilityProjectile:decrementAmmo()
	if not self.isServer then
		return
	end
	if self.abilityConfig.maxAmmo then
		self.entity.resources:decrementResource(self.resourceName, 1)
	end
end

return BaseAbilityProjectile
