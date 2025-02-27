local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BaseAbility = require(ReplicatedStorage.Classes.Bases.BaseAbility)
local TypeAbility = require(ReplicatedStorage.Types.TypeAbility)
local Inputs = require(Players.LocalPlayer.PlayerScripts:WaitForChild("Main").Input.Inputs):get()

local ClientThrow = setmetatable({}, {__index = BaseAbility})
ClientThrow.__index = ClientThrow

function ClientThrow.new(tool,name: string,config)
	local self = setmetatable(BaseAbility.new(tool,name,config) :: TypeAbility.BaseAbility, ClientThrow)
	
	self:setup()
	
	warn(self.config)

	-- Events
	tool.Destroyed:Connect(function()
		self:destroy()
	end)
	
	return self
end

function ClientThrow:setup()
	
	local lastChargeBegan = 0
	
	Inputs.events.ProcessedInputBegan:Connect(function(input)
		if not self:isToolEquipped() then return end
		if not Inputs.IsValidKey(self.config.keybinds,input.KeyCode) then return end
		
		lastChargeBegan = os.clock()
	end)
	
	Inputs.events.ProcessedInputEnded:Connect(function(input)
		if not self:isToolEquipped() then return end
		if not Inputs.IsValidKey(self.config.keybinds,input.KeyCode) then return end
		
		local chargeDuration = os.clock() - lastChargeBegan
		self:sendAction(chargeDuration)
	end)
	
end

function ClientThrow:destroy()
	self:destroyBase()
	table.clear(self)
end
return ClientThrow