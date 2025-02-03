--!strict
local Entity = {}

function Entity.IsAlive(character: any)
	if not character or character.Parent then return end

	if not character:FindFirstChild("Humanoid") then return end

	if character.Humanoid.Health <= 0 then return end
end

return Entity
