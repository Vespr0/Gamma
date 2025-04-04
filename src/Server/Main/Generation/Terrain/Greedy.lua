local Greedy = {}

-- Services
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

-- Constants
local AXIS_ENUMS = Enum.Axis:GetEnumItems()
local MERGE_THRESHOLD = 0.1
local POSITION_THRESHOLD = 0.02
local MAX_PARALLEL_MERGES = 4

local function canMerge(part1: BasePart, part2: BasePart, excludeAxis: string?)
	if not part1 or not part2 then return false end
	if not part1.Parent or not part2.Parent then return false end
	
	local equalAxises = 0
	local equalPosAxises = 0

	-- Quick position check first
	for _, axisEnum in pairs(AXIS_ENUMS) do
		local axis = axisEnum.Name
		local diff = math.abs(part1.CFrame:ToObjectSpace(part2.CFrame).Position[axis])
		if diff <= POSITION_THRESHOLD then
			equalPosAxises += 1
			if equalPosAxises == 2 then break end
		end
	end

	if equalPosAxises < 2 then return false end

	-- Property comparison
	local compareProps = { "Color", "Material", "Transparency", "Shape" }
	for _, prop in pairs(compareProps) do
		if part1[prop] ~= part2[prop] then
			return false
		end
	end

	-- Size comparison
	for _, axisEnum in pairs(AXIS_ENUMS) do
		local axis = axisEnum.Name
		if axis == excludeAxis then continue end

		local diff = math.abs(part1.Size[axis] - part2.Size[axis])
		if diff <= MERGE_THRESHOLD then
			equalAxises += 1
			if equalAxises == 2 then return true end
		end
	end

	return false
end

function Greedy:MergeNearby(part: BasePart, OP: OverlapParams, mergeProperties: { [string]: any })
	if not part or not part.Parent then return end

	OP = OP or OverlapParams.new()
	OP.FilterType = Enum.RaycastFilterType.Include
	OP.FilterDescendantsInstances = { workspace }

	mergeProperties = mergeProperties or {}

	-- Cache part properties
	local partCFrame = part.CFrame
	local partSize = part.Size
	local partOrientation = CFrame.Angles(
		math.rad(part.Orientation.X),
		math.rad(part.Orientation.Y),
		math.rad(part.Orientation.Z)
	)

	for _, axisEnum in AXIS_ENUMS do
		local axis = axisEnum.Name
		local extend = CFrame.new(
			axis == "X" and partSize.X / 2 or 0,
			axis == "Y" and partSize.Y / 2 or 0,
			axis == "Z" and partSize.Z / 2 or 0
		)

		for _, mult in { -1, 1 } do
			local origin = partCFrame * (extend * partOrientation)
			local boundSize = mergeProperties.BoundSize or Vector3.new(0.001, 0.001, 0.001)
			local touching = workspace:GetPartBoundsInBox(origin, boundSize, OP)

			for _, touchPart in touching do
				if touchPart == part or not touchPart:IsA("Part") then continue end
				if not canMerge(part, touchPart, axis) then continue end
				if mergeProperties.Filter and not mergeProperties.Filter(part, touchPart, axis) then continue end

				-- Merge the parts
				local mergeSize = Vector3.new(
					axis == "X" and touchPart.Size.X or 0,
					axis == "Y" and touchPart.Size.Y or 0,
					axis == "Z" and touchPart.Size.Z or 0
				)

				local mergePosition = Vector3.new(
					axis == "X" and -touchPart.Size.X / 2 * -mult or 0,
					axis == "Y" and -touchPart.Size.Y / 2 * -mult or 0,
					axis == "Z" and -touchPart.Size.Z / 2 * -mult or 0
				)

				part.CFrame *= CFrame.new(mergePosition)
				part.Size += mergeSize
				touchPart:Destroy()

				self:MergeNearby(part, OP, mergeProperties)
				return
			end
		end
	end
end

function Greedy:MergeParts(parts: { BasePart }, mergeProperties: { [string]: any }? )
	local OP = OverlapParams.new()
	OP.FilterType = Enum.RaycastFilterType.Include
	OP.FilterDescendantsInstances = { parts }

	-- Split parts into chunks for parallel processing
	local chunkSize = math.ceil(#parts / MAX_PARALLEL_MERGES)
	local chunks = {}
	
	for i = 1, #parts, chunkSize do
		local chunk = {}
		for j = i, math.min(i + chunkSize - 1, #parts) do
			table.insert(chunk, parts[j])
		end
		table.insert(chunks, chunk)
	end

	-- Process chunks in parallel
	local threads = {}
	for _, chunk in ipairs(chunks) do
		local thread = task.spawn(function()
			for _, part in ipairs(chunk) do
				if not part or not part.Parent then continue end
				self:MergeNearby(part, OP, mergeProperties)
			end
		end)
		table.insert(threads, thread)
	end

	-- Wait for all threads to complete
	for _, thread in ipairs(threads) do
		task.wait(thread)
	end
end

return Greedy
