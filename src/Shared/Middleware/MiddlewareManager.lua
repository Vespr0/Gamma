--!strict
local MiddlewareManager = {}

-- Services
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Folders
local Remotes = ReplicatedStorage.Remotes
local Modules = script.Parent.Modules
-- Modules
local Loading = require(ReplicatedStorage.Utility.Loading)
local Signal = require(ReplicatedStorage.Packages.signal)
-- Variables
local initialized = false

local function getOrCreateRemote(name)
	local remote = Remotes:FindFirstChild(name)
	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = Remotes
	end
	return remote
end

local function getRemotes()
	local remotes = {}
	for _, remote in Remotes:GetChildren() do
		if remote:IsA("RemoteEvent") then
			remotes[remote.Name] = remote
		end
	end
	return remotes
end

local function initializeModules()
	for _, module in Modules:GetChildren() do
		if module:IsA("ModuleScript") then
			local required = require(module)

			if required.Init then
				local util = MiddlewareManager.GetUtility({
					name = module.Name,
				})
				required.Init(util)
			end
		end
	end
end

function MiddlewareManager.GetUtility(args: {name: string})
	local utility = {}

	utility.name = args.name
	utility.isServer = RunService:IsServer()
	utility.remotes = getRemotes()
	utility.remote = getOrCreateRemote(args.name) -- Ensure the remote exists
	utility.signal = Signal

	return utility
end

function MiddlewareManager.Get(name: string)
	MiddlewareManager.Init()

	local module = Modules:FindFirstChild(name.."Middleware")

	if not module then error("Module not found") end

	return require(module)
end

function MiddlewareManager.Init() 
	if initialized then return end

	initializeModules()

	initialized = true
end

return MiddlewareManager
