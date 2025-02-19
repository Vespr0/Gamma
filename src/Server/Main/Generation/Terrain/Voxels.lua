local Voxels = {}
Voxels.__index = Voxels

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Packages
local Greedy = require(script.Parent.Greedy)
-- Modules
local Game = require(ReplicatedStorage.Utility.Game)
local Parts = require(ReplicatedStorage.Utility.Parts)

function Voxels.new(folderName)
	local self = setmetatable({}, Voxels)

	self.folder = Instance.new("Folder")
	self.folder.Name = folderName
	self.folder.Parent = Game.Folders.Voxels

	return self
end

function Voxels:place(position,type)
	local size = Vector3.new(Game.Generation.PART_WIDTH, Game.Generation.PART_HEIGHT, Game.Generation.PART_WIDTH)
	local part = Parts.New(CFrame.new(position), size, type or "Missing", self.folder)

	return part
end

function Voxels:merge(parts)
    local start = os.clock()
    local startPartsCount = #parts
	print(`Merging [{startPartsCount}] parts...`)

	Greedy:MergeParts(parts)

	local endParts = {}
	for _,part in parts do
		if not part or not part.Parent then continue end
		table.insert(endParts, part)
	end
	print(`Merged [{startPartsCount}] parts in [{os.clock() - start}] seconds. Part count reduced by [{((1 - (#endParts/startPartsCount)) * 100)} %].`)
end

function Voxels:mergeAll()
	local parts = self.folder:GetChildren()
	self:merge(parts)
end

return Voxels