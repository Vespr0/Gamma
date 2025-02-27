local BaseAnima = {}
BaseAnima.__index = BaseAnima

-- Services 
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local TypeRig = require(ReplicatedStorage.Types.TypeRig)
local Trove = require(ReplicatedStorage.Packages.trove)

function BaseAnima.new(player)
	local self = setmetatable({}, BaseAnima)

	assert(player, "Player is nil")

	self.player = player :: Player
	self.userId = player.UserId :: number

	-- Physical propieties
	self.character = nil :: TypeRig.Rig?
	self.humanoid = nil :: Humanoid?
	self.moving = false :: boolean
	self.root = nil :: BasePart?
	self.height = 0 :: number

	-- Events
	self.events = {
		Added = Signal.new(),
		Removed = Signal.new(),
		CharacterAdded = Signal.new(),
		CharacterDied = Signal.new(),
		CharacterAttributeChanged = Signal.new()
	}

	self:setupBase()

	return self
end

function BaseAnima:SetAttribute(name: string,value: any,playerDependent: boolean?)
	if not name then warn("nil value as name for SetAttribute") end
	if not value then warn("nil value as input for SetAttribute") end
	
	if playerDependent and not self.character then return end
	
	if playerDependent then
		return self.player:SetAttribute(name,value)
	else
		return self.character:SetAttribute(name,value)
	end
end

function BaseAnima:GetAttribute(name: string,playerDependent: boolean?)
	if not name then warn("nil value as name for SetAttribute") end
	
	if playerDependent and not self.character then return end

	if playerDependent then
		return self.player:GetAttribute(name)
	else
		return self.character:GetAttribute(name)
	end
end

function BaseAnima:IncrementAttribute(name: string,value: any,playerDependent: boolean)
	local originalValue = self:GetAttribute(name,playerDependent) or 0
	return self:SetAttribute(name,originalValue+value,playerDependent)
end

function BaseAnima:setupBase()
	-- Fire the Added event
	self.events.Added:Fire(self)

	-- Handle character setup when a new character is added
	self.player.CharacterAdded:Connect(function(character: Model)
		self:setupCharacter(character :: TypeRig.Rig)
	end)

	-- If the character already exists (player joined before this script ran), set it up
	local character = self.player.Character :: TypeRig.Rig
	if character then
		self:setupCharacter(character)
	end

	-- Handle player removal
	Players.PlayerRemoving:Connect(function(player: Player)
		if player == self.player then
			self:destroyBase()
		end
	end)
end

function BaseAnima:setupCharacter(character: TypeRig.Rig)
	local trove = Trove.new()

	self.humanoid = character:WaitForChild("Humanoid",3) :: Humanoid
	
	if not self.humanoid then error("Character humanoid is missing.") return end
	local rootPart = character:FindFirstChild("HumanoidRootPart") or warn(`Character "{character.Name}" has no "HumanoidRootPart".`)
	if character.PrimaryPart ~= character:FindFirstChild("HumanoidRootPart") then character.PrimaryPart = character:FindFirstChild("HumanoidRootPart") end

	-- Make character archivable
	character.Archivable = true

	self.root = character.PrimaryPart :: BasePart
	self.height = character:GetExtentsSize().Y :: number

	self.humanoid.WalkSpeed = 10

	-- Died
	self.humanoid.Died:Connect(function()
		self.events.CharacterDied:Fire()
	end)
	-- The rig could also be destroyed
	character.Destroying:Connect(function()
		self.events.CharacterDied:Fire()
	end)
	
	self.humanoid.Running:Connect(function(speed)
		self.moving = speed > 0
	end)

	character.AttributeChanged:Connect(function(name: string)
		local value = self.character:GetAttribute(name) -- AttributeChanged doesn't return the value
		self.events.CharacterAttributeChanged:Fire(name, value)
	end)

	self.character = character
	self.events.CharacterAdded:Fire(character)
end

function BaseAnima:destroyBase()
	-- Fire the Removed event
	self.events.Removed:Fire()

	-- Clean up signals
	for _, event: any in self.events do
		event:Destroy()
	end
	
	table.clear(self)
end

return BaseAnima
