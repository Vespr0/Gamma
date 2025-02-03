local Item = {}
Item.__index = Item
Item.__type = "Item"

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
-- Modules
local AssetsDealer = require(ReplicatedStorage.AssetsDealer)
local TypeItem = require(ReplicatedStorage.Types.TypeItem)
local TypeEntity = require(ReplicatedStorage.Types.TypeEntity)
local Signal = require(ReplicatedStorage.Packages.signal)
-- Folders
local Abilities = ReplicatedStorage.Abilities
-- Constants
local IS_SERVER = RunService:IsServer()

local function getName(name)
    local errorString = "Item instance must have a valid name"

    if type(name) ~= "string" then error(errorString) end
    if tostring(name) == "nil" then error(errorString) end

    return name or error(errorString)
end

function Item.new(name,hasModel)
    name = getName(name)

	local self = setmetatable({}, Item) :: TypeItem.Item
	
	-- Basic info
	self.name = name 

	-- Config
	self.asset = AssetsDealer.Get("Tools",name,hasModel and "Clone")
	self.asset.Parent = workspace -- TODO: remove, it's only for debug
	self.config = require(self.asset.Config)
	
	-- Physical info
    self.model = hasModel and self.asset.Model :: Model
	self.motor = self.asset:FindFirstChildOfClass("Motor6D") :: Motor6D
	self.bodyPart = self.motor.Part0 :: BasePart
	self.C0 = hasModel and self.motor and self.motor.C0 :: CFrame
	self.C1 = hasModel and self.motor and self.motor.C1 :: CFrame
	
	-- Misc info
	self.displayName = self.config.DisplayName :: string
	self.description = self.config.Description :: string
    self.throwable = self.config.Throwable or true :: boolean
	self.animations = self.config.Animations :: { [string]: AnimationTrack }
	self.owner = nil :: TypeEntity.BaseEntity?
	self.equipped = false :: boolean
    self.mass = self.config.mass or 1
	
	-- Events
	self.events = {
		Destroyed = Signal.new(),
	}

	-- Abilities
	self.abilities = {}
	self:setupAbilities()

	-- If the model is destroyed, the item is destroyed also.
	self.model.Destroying:Connect(function()
		print("Item model destroyed")
		self:destroy()
	end)
	
    return self
end

function Item:setupAbilities()
	local abilitiesConfig = self.config.Abilities or {}
	if self.throwable then
		abilitiesConfig.Throw = {}
	end
	
	for abilityName,extraAbilityConfig in abilitiesConfig do
		local abilityClassName = (extraAbilityConfig.ClassName or abilityName) or error(`No ClassName found in the ability configuration for {abilityName}`)
		
		local folder = Abilities[abilityClassName]
		if not folder then warn(`No ability folder found in Abilities named {abilityClassName}`) continue end

		local prefix = IS_SERVER and "Server" or "Client"
		local abilityClass = require(folder[prefix..abilityClassName])

		--[[
		In this proccess the configuration file in the ability folder is merged with the extra configuration in the abilities table 
		in the item configuration 
		]]
		local originalConfig = folder:FindFirstChild("Config")
		if not originalConfig then warn(`No {string.lower(prefix)} ability base config found with name {abilityName}`) continue end
		originalConfig = require(originalConfig)

		local abilityConfig = {}

		-- Replace the original
		for key, value in originalConfig do
			if extraAbilityConfig[key] then
				abilityConfig[key] = extraAbilityConfig[key]
			else
				abilityConfig[key] = value
			end
		end

		-- Add the extra
		for key, value in extraAbilityConfig do
			if abilityConfig[key] then continue end
			abilityConfig[key] = value
		end

		if not abilityClass then warn(`No {string.lower(prefix)} ability class found with name {abilityName}`) continue end
		
		-- Create the ability instance and store it in the abilities table of the item
		self.abilities[abilityName] = abilityClass.new(self,abilityName,abilityConfig)
	end 
end

function Item:destroy()
	self.events.Destroyed:Fire()
    if self.model then
        self.model:Destroy()
	end
	if self.abilities then
		for _,ability in self.abilities do
			ability:destroy()
		end
	else
		warn("Item is destroyed before its abilities could be instantiated")
	end
    table.clear(self)
end

return Item

