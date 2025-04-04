-- Services 
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BaseAbility = require(ReplicatedStorage.Abilities.BaseAbility)
local BaseClientAbility = setmetatable({}, {__index = BaseAbility})
BaseClientAbility.__index = BaseClientAbility

-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local Trove = require(ReplicatedStorage.Packages.trove)
local TypeEntity = require(ReplicatedStorage.Types.TypeEntity)
local ViewmodelManager = require(script.Parent.Parent.Character.ViewmodelManager)
local Loading = require(ReplicatedStorage.Utility.Loading)
-- Network
local AbilitiesMiddleware = require(ReplicatedStorage.Middleware.MiddlewareManager).Get("Abilities")
-- Constants
local IS_SERVER = RunService:IsServer()

function BaseClientAbility.new(name: string, entity: TypeEntity.BaseEntity, tool: Tool, abilityConfig)
    assert(typeof(name) == "string", "Invalid call, ability name must be a string.")

    local self = setmetatable(BaseAbility.new(name,entity,tool,abilityConfig) :: TypeAbility.BaseClientAbility, BaseClientAbility)

	self:setup()

    return self
end

function BaseClientAbility:checkInputConditions()
	local dummyTool = self.entity.backpack:getDummyTool()
	if not dummyTool then return false end
		
	if dummyTool:GetAttribute("ID") ~= self.tool:GetAttribute("ID") then return false end

	return true
end

function BaseClientAbility:loadAnimation(name: string,animationDirectory: string)
	return self.entity.animator:load(self.animationPreamble, name, animationDirectory)
end

function BaseClientAbility:playAnimation(name: string, fadeTime: number, weight: number, speed: number)
	self.entity.animator:play(self.animationPreamble, name, fadeTime, weight, speed)
end

function BaseClientAbility:stopAnimation(name: string, fadeTime: number)
	self.entity.animator:stop(self.animationPreamble, name, fadeTime)
end

function BaseClientAbility:getViewmodelTool()
	return ViewmodelManager.Singleton.currentFakeTool
end

function BaseClientAbility:getFireEndPosition()
	local viewmodelTool = self:getViewmodelTool()
	assert(viewmodelTool, "Viewmodel tool is missing")
	local fireEnd = viewmodelTool.model:FindFirstChild("Handle"):FindFirstChild("FireEnd")
	assert(fireEnd, "FireEnd attachment is missing")
	return fireEnd.WorldPosition
end

function BaseClientAbility:setup()
	self.animationPreamble = "Tool".."-"..self.tool:GetAttribute("ID").."-"..self.tool.Name
	task.spawn(function()
		local backpack, err = Loading.waitFor(function()
			return self.entity.backpack
		end, 5)

		if not backpack then
			warn("Failed to get backpack for ability:", err)
			return
		end

		-- Tool events
		self.trove:Add(backpack.events.ToolEquip:Connect(function(_,index: number)
			if index ~= self.tool:GetAttribute("Index") then return end
			self.events.Equipped:Fire()
		end))
		self.trove:Add(backpack.events.ToolUnequip:Connect(function(_,index: number)
			if index ~= self.tool:GetAttribute("Index") then return end
			self.events.Unequipped:Fire()
		end))
		-- Hold animation
		assert(self.toolConfig.animations.hold, `Hold animation is missing from tool "{self.tool.Name}".`)
		self:loadAnimation("Hold",self.toolConfig.animations.hold)
		self.events.Equipped:Connect(function()
			self:playAnimation("Hold",0)
		end)
		self.events.Unequipped:Connect(function()
			self:stopAnimation("Hold",0)
		end)
	end)
end

function BaseClientAbility:destroySub()
	self:destroyBase()
end

return BaseClientAbility
