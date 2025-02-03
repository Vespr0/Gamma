--!strict
local function validateItemRig(item)
	local rig = item:FindFirstChild("Rig")
	
	if not rig then warn(`Item "{item.Name}" has no rig.`) return end
	
	local rootPart = rig:FindFirstChild("HumanoidRootPart") or rig.PrimaryPart
	if not rootPart then warn(`Item "{item.Name}"'s rig has no root part.`) end 
	
	local isAnchored = rootPart.Anchored
	
	if not isAnchored then warn(`Item {item.Name}" has it's rig's root part unanchored. Please anchor it in studio to avoid any issues.`) end
	
	rootPart.Anchored = true
end

return function(asset)
	local isItem = asset:FindFirstChild("Config")
	if isItem then validateItemRig(asset) end
end