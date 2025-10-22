-- ShapeCaster.lua
-- Utility for spatial hit detection using Roblox's OverlapParams API
-- Supports long (box), square (box), and sphere hitboxes for melee/projectile attacks

local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")

local ShapeCaster = {}

export type ShapeType = "long" | "square" | "sphere"

export type ShapeCastResult = {
	Entity: Instance?,    -- The entity hit (e.g. Model or Part tagged as entity)
	Instance: BasePart,   -- The part hit
	Position: Vector3,    -- The hit position (center of part or PrimaryPart)
	Normal: Vector3?,     -- Not available for overlap, but included for API symmetry
	Distance: number,     -- Distance from origin to hit
}

export type ShapeCastParams = {
	Origin: Vector3,
	Direction: Vector3?, -- For long shape
	Length: number?,     -- For long shape
	Size: Vector3?,      -- For box shapes (square/long)
	Radius: number?,     -- For sphere
	Shape: ShapeType,
	EntityTag: string?,  -- CollectionService tag to filter entities
	OverlapParams: OverlapParams?, -- Optional custom params
	HitMultiple: boolean?, -- If false, only return closest entity
	IgnoreList: {Instance}?,
}

local function getEntitiesFromParts(parts: {BasePart}, entityTag: string?): {Instance}
	local entities = {}
	local seen = {}
	for _, part in ipairs(parts) do
		local entity = part
		-- Walk up to find tagged entity if tag is provided
		if entityTag then
			while entity and not CollectionService:HasTag(entity, entityTag) do
				entity = entity.Parent
			end
		end
		if entity and (not entityTag or CollectionService:HasTag(entity, entityTag)) and not seen[entity] then
			seen[entity] = true
			table.insert(entities, entity)
		end
	end
	return entities
end

function ShapeCaster.Cast(params: ShapeCastParams): {ShapeCastResult}
	local shape = params.Shape
	local origin = params.Origin
	local overlapParams = params.OverlapParams or OverlapParams.new()
	if params.IgnoreList then
		overlapParams.FilterDescendantsInstances = params.IgnoreList
		overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	end
	local parts = {}
	if shape == "sphere" then
		local radius = params.Radius or 5
		parts = Workspace:GetPartBoundsInRadius(origin, radius, overlapParams)
	elseif shape == "square" then
		local size = params.Size or Vector3.new(5, 5, 5)
		local cframe = CFrame.new(origin)
		parts = Workspace:GetPartBoundsInBox(cframe, size, overlapParams)
	elseif shape == "long" then
		local direction = params.Direction or Vector3.new(0, 0, 1)
		local length = params.Length or 10
		local size = params.Size or Vector3.new(1, 1, length)
		local center = origin + direction.Unit * (length / 2)
		local cframe = CFrame.new(center, center + direction)
		parts = Workspace:GetPartBoundsInBox(cframe, size, overlapParams)
	else
		error("Unsupported shape type: " .. tostring(shape))
	end

	local results = {}
	for _, part in ipairs(parts) do
		local entity = part
		if params.EntityTag then
			while entity and not CollectionService:HasTag(entity, params.EntityTag) do
				entity = entity.Parent
			end
		end
		local pos = part.Position or (entity and entity:IsA("Model") and entity.PrimaryPart and entity.PrimaryPart.Position) or part.Position
		local dist = (pos - origin).Magnitude
		table.insert(results, {
			Entity = entity,
			Instance = part,
			Position = pos,
			Normal = nil, -- Overlap APIs do not provide surface normal
			Distance = dist,
		})
	end
	if not params.HitMultiple then
		-- Only return closest result
		local minDist, closest = math.huge, nil
		for _, result in ipairs(results) do
			if result.Distance < minDist then
				minDist, closest = result.Distance, result
			end
		end
		return closest and {closest} or {}
	end
	return results
end

return ShapeCaster
