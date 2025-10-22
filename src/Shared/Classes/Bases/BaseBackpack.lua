local BaseBackpack = {}
BaseBackpack.__index = BaseBackpack

-- Services
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Packages.signal)
local PlayerUtility = require(ReplicatedStorage.Utility.Player)
local AssetsDealer = require(ReplicatedStorage.AssetsDealer)
local ToolUtility = require(ReplicatedStorage.Utility.ToolUtility)
local TypeEntity = require(ReplicatedStorage.Types.TypeEntity)
-- Constants
local IS_SERVER = RunService:IsServer()

-- Modify to receive a BaseEntity (or something that implements a baseEntity interface)
function BaseBackpack.new(entity: TypeEntity.BaseEntity)
	local self = setmetatable({}, BaseBackpack)

	self.entity = entity

	if self.entity == nil then
		error("Entity is missing")
		return
	end
	--if not PlayerUtility.IsValidPlayerValue(entity) then error(`Entity is not a Player"`) return end -- no longer a player

	if IS_SERVER then
		self.tools = Instance.new("Folder")
		self.tools.Name = tostring(entity.id)
		self.tools.Parent = ReplicatedStorage.ToolsDeposit -- Place under the entity's rig
	else
		--Look for it under the player instance instead of the rig.
		self.tools = ReplicatedStorage.ToolsDeposit:WaitForChild(tostring(entity.id), 3) :: Backpack
	end

	self.equippedTool = nil :: Tool?

	self.events = {
		ToolAdded = Signal.new(),
		ToolRemoved = Signal.new(),
		ToolEquip = Signal.new(),
		ToolUnequip = Signal.new(),
	}

	return self
end

function BaseBackpack:getTools()
	local tools = {}
	for _, tool in self.tools:GetChildren() do
		if tool:IsA("Tool") then
			table.insert(tools, tool)
		end
	end
	return tools
end

function BaseBackpack:getTool(toolName: string)
	local tool = self.tools:FindFirstChild(toolName)

	if tool and tool:IsA("Tool") then
		return tool :: Tool
	else
		warn(`Tool not found with name {toolName} in backpack for entity {self.entity.rig.Name}`)
		return nil
	end
end

function BaseBackpack:getToolFromIndex(index: number)
	for _, tool in self:getTools() do
		if not tool or not tool:IsA("Tool") then
			continue
		end

		if tool:GetAttribute("Index") == index then
			return tool :: Tool
		end
	end
	return nil
end

function BaseBackpack:destroyBase()
	self.tools:Destroy()
	for _, signal in pairs(self.events) do
		signal:Destroy()
	end
end

return BaseBackpack
