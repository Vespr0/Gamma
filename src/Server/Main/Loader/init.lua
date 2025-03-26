--!strict
local Loader = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
-- Modules
local Loading = require(ReplicatedStorage.Utility.Loading)
local Conch = require(ReplicatedStorage.Packages.conch)
local Test = require(script.Test)

local function loadModules()
	Loading.LoadAssetsDealer()
    Loading.LoadModules(script.Parent,{script})
	-- Conch
	Conch.initiate_default_lifecycle()
end
	
Loader.Init = function()
	loadModules()
	
	if RunService:IsStudio() then Test() end
end

return Loader