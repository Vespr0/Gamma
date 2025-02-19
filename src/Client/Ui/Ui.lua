--!strict
local Ui = {}

-- Services
local Players = game:GetService("Players")
local StarterGUI = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
-- Modules
local ClientAnima = require(script.Parent.Parent.Main.Player.ClientAnima)
local ClientBackpack = require(script.Parent.Parent.Main.Player.ClientBackpack)
local Fusion = require(ReplicatedStorage.Packages.fusion)
-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

Ui.Dependencies = { "ClientAnima", "ClientBackpack" }

local function disableCoreUi()
    repeat
        local success = pcall(function() 
            -- Disable resetting (client side)
            StarterGUI:SetCore("ResetButtonCallback", RunService:IsStudio()) 
            -- Disable backpack 
            StarterGUI:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
        end)
        task.wait() 
    until success
end

local function initializeCharacterDependantModule(module)
	task.spawn(function()
		-- Prepare a utility for character dependant ui modules 
		local utility = Ui.GetUtility(true)
		local trove = module.InitUi(utility, Player.Character)
		-- Make sure it's initialized again when the character respawns
		Player.CharacterAdded:Connect(function(character)
			trove:Destroy()
			module.InitUi(utility, character)
		end)
	end)
end

local function initiliazeModules()
    local Modules = script.Parent.Modules
    for _,module in pairs(Modules:GetChildren()) do
        if module:IsA("ModuleScript") then
			local success, err = pcall(function()
				local module = require(module)
				if module.CharacterDependant then
					initializeCharacterDependantModule(module)
				else
					local utility = Ui.GetUtility(false)
					module.InitUi(utility)
				end
			end)
			if success then
				print(`🖼️ Loaded "{module.Name}" ui module`)
			else
				error(`❌ Failed to load "{module.Name}" ui module: {err}`)
			end
        end
    end
end

local function setupIris()
	local Iris = require(game:GetService("ReplicatedStorage").Packages.iris).Init()
	Iris:Connect(function()
		Iris.Window({"My First Window!"})
			Iris.Text({"Hello, World"})
			Iris.Button({"Save"})
			Iris.InputNum({"Input"})
		Iris.End()
	end)
end

local function setup()
    disableCoreUi()
    initiliazeModules()
	setupIris()
end

function Ui.GetUtility(characterDependant: boolean)
    local utility = {}

    utility.player = Player
    utility.mouse = Mouse
    utility.playerGui = Player:WaitForChild("PlayerGui")

    -- Components
	utility.anima = ClientAnima:get()

    utility.Value = Fusion.Value
    utility.Computed = Fusion.Computed
	utility.Hydrate = Fusion.Hydrate
	utility.Spring = Fusion.Spring
	
	if characterDependant then
		if not ClientBackpack.LocalPlayerInstance then
			error("Client Backpack LocalPlayerInstance is nil, maybe it wasn't initialized yet?")
		end
		local backpack = ClientBackpack.LocalPlayerInstance
		utility.backpack = backpack
	end

    utility.GetGui = function(name)
        return utility.playerGui:WaitForChild(name)
    end

    utility.MakeTemplate = function(uiElement)
        local clone = uiElement:Clone()
        uiElement:Destroy()
        return clone
	end
	
	-- Update the player backpack TODO: Is this a memory leak?
	ClientBackpack.GlobalAdded:Connect(function()
		utility.backpack = ClientBackpack.LocalPlayerInstance
	end)

    return utility
end

function Ui.Init()
    setup()
end

return Ui