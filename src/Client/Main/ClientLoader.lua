local ClientLoader = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
-- Modules
local Game = require(ReplicatedStorage.Utility.Game)
local Loading = require(ReplicatedStorage.Utility.Loading)
local Conch = require(ReplicatedStorage.Packages.conch)
local ConchUi = require(ReplicatedStorage.Packages.conch_ui)

-- Variables
local context = ""
local progress = 0

-- Functions
local function setContext(value)
    context = value
end

local function setProgress(value: number)
    print("⌛ "..context,(value*100).."%")
    progress = value
end

local function preload()
    setContext("Loading assets")
    setProgress(0)
    local assets = Game.Assets:GetChildren()
    local totalAssets = #assets
    for a = 1,totalAssets do
        local folder = assets[a]
        ContentProvider:PreloadAsync({folder})
        setContext("Loading "..folder.Name)
        setProgress(a/totalAssets)
    end
    print("Assets loaded")
end

local function load()
    setContext("Loading modules")
    setProgress(0)
    -- Load Assets
	Loading.LoadAssetsDealer()
    -- Load Modules
    Loading.LoadModules(script.Parent,{script})
    -- Load Ui
    require(script.Parent.Parent.Ui.Ui).Init()
    -- Load Conch
    Conch.initiate_default_lifecycle()
    ConchUi.bind_to(Enum.KeyCode.F4)
    setProgress(1)
    print("Modules loaded")
end
	
ClientLoader.Init = function()
	if Game.Assets then
		preload()
	end
    load()
end

return ClientLoader