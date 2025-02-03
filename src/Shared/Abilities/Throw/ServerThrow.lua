local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BaseAbility = require(ReplicatedStorage.Classes.Bases.BaseAbility)

local ClientThrow = setmetatable({}, {__index = BaseAbility})
ClientThrow.__index = ClientThrow

function ClientThrow.new(item,name: string,config)
	warn(item)
	local self = setmetatable(BaseAbility.new(item,name,config), ClientThrow)

	self:setup()

	-- Events
	warn(item)
	item.events.Destroyed:Connect(function()
		self:destroy()
	end)

	return self
end

function ClientThrow:setup()
	self:readAction(function(player: Player,chargeDuration: number)
		print(`My man {player.DisplayName} used throw.`)
	end)
end

function ClientThrow:destroy()
	self:destroyBase()
	table.clear(self)
end

return ClientThrow