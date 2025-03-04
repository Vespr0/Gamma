--!strict
local function validateToolRig(asset)
	local rig = asset:FindFirstChild("Rig")
	
	if not rig then warn(`Tool "{asset.Name}" has no rig.`) return end
	
	local rootPart = rig:FindFirstChild("HumanoidRootPart") or rig.PrimaryPart
	if not rootPart then warn(`Tool "{asset.Name}"'s rig has no root part.`) end 
	
	local isAnchored = rootPart.Anchored
	
	-- Check if the rig root part is anchored
	if not isAnchored then warn(`Tool {asset.Name}" has it's rig's root part unanchored, it has now been anchored. Anchor it in studio to remove this warning.`) end
	rootPart.Anchored = true

	-- Check if any parts have collisions on
	local model = asset:FindFirstChild("Tool"):FindFirstChild("Model")
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