local BaseAnima = {}
BaseAnima.__index = BaseAnima

-- Services 
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local TypeEntity = require(ReplicatedStorage.Types.TypeEntity)
local Trove = require(ReplicatedStorage.Packages.trove)

function BaseAnima.new(player)
	local self = setmetatable({}, BaseAnima)

	assert(player, "Player is nil")

	self.player = player :: Player
	self.userId = player.UserId :: number

	-- Physical propieties
	self.entity = nil :: TypeEntity.BaseEntity?
	-- self.humanoid = nil :: Humanoid?
	-- self.moving = false :: boolean
	-- self.root = nil :: BasePart?
	-- self.height = 0 :: number

	-- Events
	self.trove = Trove.new()
	self.events = {
		Added = Signal.new(),
		Removed = Signal.new(),
		EntityAdded = Signal.new(),
		EntityDied = Signal.new(),
		EntityAttributeChanged = Signal.new()
	}

	self:setupBase()

	return self
end

-- function BaseAnima:SetAttribute(name: string,value: any,playerDependent: boolean?)
-- 	if not name then warn("nil value as name for SetAttribute") end
-- 	if not value then warn("nil value as input for SetAttribute") end
	
-- 	if playerDependent and not self.character then return end
	
-- 	if playerDependent then
-- 		return self.player:SetAttribute(name,value)
-- 	else
-- 		return self.character:SetAttribute(name,value)
-- 	end
-- end

-- function BaseAnima:GetAttribute(name: string,playerDependent: boolean?)
-- 	if not name then warn("nil value as name for SetAttribute") end
	
-- 	if playerDependent and not self.character then return end

-- 	if playerDependent then
-- 		return self.player:GetAttribute(name)
-- 	else
-- 		return self.character:GetAttribute(name)
-- 	end
-- end

-- function BaseAnima:IncrementAttribute(name: string,value: any,playerDependent: boolean)
-- 	local originalValue = self:GetAttribute(name,playerDependent) or 0
-- 	return self:SetAttribute(name,originalValue+value,playerDependent)
-- end

function BaseAnima:setupBase()
	-- Fire the Added event
	self.events.Added:Fire(self)

	self.events.EntityAdded:Connect(function(entity)
		entity.events.Died:Connect(function()
			self.events.EntityDied:Fire()
		end)
	end)
end

-- function BaseAnima:setupCharacter(character: TypeRig.Rig)
-- 	local trove = Trove.new()

-- 	self.humanoid = character:WaitForChild("Humanoid",3) :: Humanoid
	
-- 	if not self.humanoid then error("Character humanoid is missing.") return end
-- 	local rootPart = character:FindFirstChild("HumanoidRootPart") or warn(`Character "{character.Name}" has no "HumanoidRootPart".`)
-- 	if character.PrimaryPart ~= character:FindFirstChild("HumanoidRootPart") then character.PrimaryPart = character:FindFirstChild("HumanoidRootPart") end

-- 	-- Make character archivable
-- 	character.Archivable = true

-- 	self.root = character.PrimaryPart :: BasePart
-- 	self.height = character:GetExtentsSize().Y :: number

-- 	-- Died
-- 	self.humanoid.Died:Connect(function()
-- 		self.events.EntityDied:Fire()
-- 	end)
-- 	-- The rig could also be destroyed
-- 	character.Destroying:Connect(function()
-- 		self.events.EntityDied:Fire()
-- 	end)
	
-- 	self.humanoid.Running:Connect(function(speed)
-- 		self.moving = speed > 0
-- 	end)

-- 	character.AttributeChanged:Connect(function(name: string)
-- 		local value = self.character:GetAttribute(name) -- AttributeChanged doesn't return the value
-- 		self.events.EntityAttributeChanged:Fire(name, value)
-- 	end)

-- 	self.character = character
-- end

function BaseAnima:destroyBase()
	task.wait(0.1) -- Wait a frame to ensure all events are processed, TODO: hacky solution

	-- Fire the Removed event
	self.events.Removed:Fire()

	-- Clean up signals
	for _, event: any in self.events do
		event:Destroy()
	end
	
	table.clear(self)
end

return BaseAnima
