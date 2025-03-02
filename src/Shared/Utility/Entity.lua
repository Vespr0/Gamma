local Entity = {}

-- TODO: Typechecking

-- TODO: this is actually rig utility not entity utility

-- Healthy means with a humanoid and health above 0
function Entity.IsHealthy(rig)
	if not rig:FindFirstChild("Humanoid") then return false end
	if rig.Humanoid.Health <= 0 then return false end

	return true
end

-- Alive means not destroyed and healthy
function Entity.IsAlive(rig)
	if not rig or rig.Parent then return false end
	if not Entity.IsHealthy(rig) then return false end
	
	return true
end

return Entity
