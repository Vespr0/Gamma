local Motor6DCrouching = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Modules
local TypeRig = require(ReplicatedStorage.Types.TypeRig)
local Trove = require(ReplicatedStorage.Packages.trove)
local EntityUtility = require(ReplicatedStorage.Utility.Entity)

local BIAS_NAME = "Crouching"
local SMOOTHNESS = 10

function Motor6DCrouching.Connect(utility, rig: TypeRig.Rig)
    local self = {}

    self.connection = nil
    utility:checkMotors("RootJoint", "Right Hip", "Left Hip")

    local function animate(mode: boolean)
        if not EntityUtility.IsAlive(rig) then
            self.connection:Disconnect()
            return 
        end

        if mode then
            -- Add biases
            local rootC1Bias = { offset = Vector3.zAxis / 1.5, angles = CFrame.Angles(0, 0, 0) }
            local rightC1Bias = { offset = -Vector3.yAxis / 1.5 - Vector3.xAxis / 4, angles = CFrame.Angles(0, 0, math.rad(30)) }
            local leftC1Bias = { offset = -Vector3.yAxis / 1.5 + Vector3.xAxis / 4, angles = CFrame.Angles(0, 0, math.rad(-30)) }

            utility:addBias("RootJoint", BIAS_NAME, "C1", rootC1Bias, SMOOTHNESS)
            utility:addBias("Right Hip", BIAS_NAME, "C1", rightC1Bias, SMOOTHNESS)
            utility:addBias("Left Hip", BIAS_NAME, "C1", leftC1Bias, SMOOTHNESS)
        else
            -- Remove biases
            utility:removeBias("RootJoint", BIAS_NAME, SMOOTHNESS)
            utility:removeBias("Right Hip", BIAS_NAME, SMOOTHNESS)
            utility:removeBias("Left Hip", BIAS_NAME, SMOOTHNESS)
        end
    end

    self.connection = rig.AttributeChanged:Connect(function(attribute: string)
        local fromLocalPlayer = utility.isLocalPlayerInstance and attribute == BIAS_NAME
        local fromEntity = not utility.isLocalPlayerInstance and attribute == "Synced"..BIAS_NAME
        
        if fromLocalPlayer or fromEntity then
            local mode = rig:GetAttribute(attribute)
            animate(mode)
        end
    end)

    return self
end

return Motor6DCrouching
