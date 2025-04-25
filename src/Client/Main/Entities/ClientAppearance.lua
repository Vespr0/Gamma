local ClientAppearance = {}
ClientAppearance.__index = ClientAppearance

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

-- Modules
local Signal = require(ReplicatedStorage.Packages.signal)
local Game = require(ReplicatedStorage.Utility.Game)
local Trove = require(ReplicatedStorage.Packages.trove)

-- Variables
ClientAppearance.Instances = {}
-- ClientAppearance.GlobalAdded = Signal.new()

function ClientAppearance.new(entity)
    local self = setmetatable({}, ClientAppearance)
    
    self.entity = entity
    self.rig = entity.rig
    self.trove = Trove.new()
    
    self:setup()
    
    ClientAppearance.Instances[entity.id] = self
    -- ClientAppearance.GlobalAdded:Fire(self)
    
    return self
end

function ClientAppearance:setup()
    self:updateTeamColors()
    -- Listen for team changes
    self.trove:Add(self.rig:GetAttributeChangedSignal("Team"):Connect(function()
        self:updateTeamColors()
    end))
end

function ClientAppearance:updateTeamColors()
    local team = self.rig:GetAttribute("Team")
    local teamInfo = Game.Teams[team]
    
    assert(teamInfo, `Team "{team}" not found in Game.Teams`)
    
    local bodyColors = self.rig:FindFirstChildOfClass("BodyColors")
    if bodyColors then
        bodyColors.LeftLegColor3 = teamInfo.SecondaryColor
        bodyColors.RightLegColor3 = teamInfo.SecondaryColor
        bodyColors.TorsoColor3 = teamInfo.PrimaryColor
    end

    -- Update the color of instances with the "TeamColored" attribute
    for _, instance in self.rig:GetDescendants() do
        local teamColor = instance:GetAttribute("TeamColor")
        if teamColor then
            if teamColor == "Primary" then
                instance.Color = teamInfo.PrimaryColor
            elseif teamColor == "Secondary" then
                instance.Color = teamInfo.SecondaryColor
            end
        end
    end
end

function ClientAppearance:destroy()
    self.trove:Destroy()
    ClientAppearance.Instances[self.entity.id] = nil
end

return ClientAppearance 