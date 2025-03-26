--!strict
local function validateToolRig(asset)
	local rig = asset:FindFirstChild("Rig")
	
	assert(rig, `Tool asset: "{asset.Name}" has no rig`)
	
	local rootPart = rig:FindFirstChild("HumanoidRootPart") or rig.PrimaryPart
	assert(rootPart, `Tool asset: "{asset.Name}" has no root part`)
	
	local isAnchored = rootPart.Anchored
	
	-- Check if the rig root part is anchored
	assert(isAnchored, `Tool asset: "{asset.Name}"'s root part is not anchored.`)
	rootPart.Anchored = true

	-- Check if any parts have collisions on
	local tool = rig:FindFirstChildOfClass("Tool")

	assert(tool, "Tool asset has no tool")

	local model = tool:FindFirstChild("Model")
	for i, part in model:GetDescendants() do
		if part:IsA("BasePart") then
			if part.CanCollide then
				warn(`Tool "{asset.Name}" has a part with collisions on, it has collisions off now. Set the collisions off in studio to remove this warning`)
				part.CanCollide = false
			end
		end
	end

	rootPart.Anchored = true
end

return function(asset)
	local isTool = asset:FindFirstChild("Config")
	if isTool then validateToolRig(asset) end
end