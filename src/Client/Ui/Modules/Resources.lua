-- src/Client/Ui/Modules/Resources.lua

local ResourcesModule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.fusion)
local ResourcesHolder = require(ReplicatedStorage.UI.Components.ResourcesHolder)
local Trove = require(ReplicatedStorage.Packages.trove) -- Added Trove

local Children = Fusion.Children

ResourcesModule.CharacterDependant = true

function ResourcesModule.InitUi(ui)
	local MainGui = ui.GetGui("MainGui")
	local rootScope = Fusion.scoped(Fusion)

	-- Create a Fusion Value to hold the current ClientEntity instance
	local currentClientEntity = rootScope:Value(ui.entity)

	-- Listen for EntityAdded events to update the currentClientEntity Fusion Value
	ui.events.EntityAdded:Connect(function(newEntity)
		currentClientEntity:set(newEntity)
	end)

	-- Create a Computed value for resources that reacts to currentClientEntity changes
	local resourcesState = rootScope:Value({})

	-- Observe the currentClientEntity to manage dynamic signal connections
	local connectionTrove = Trove.new()
	rootScope:Observer(currentClientEntity):onBind(function(entity)
		connectionTrove:Clean()

		if not entity then
			return
		end

		if entity.resources and entity.resourcesChanged then
			connectionTrove:Add(entity.resourcesChanged:Connect(function(newResources)
				resourcesState:set(newResources)
			end))
			-- Also set the initial state from the new entity's resources (or empty if no entity)
			resourcesState:set(entity.resources or {})
		end
	end)

	-- Create ResourcesHolder component
	ResourcesHolder(rootScope, {
		Parent = MainGui,
		Resources = resourcesState,
	})

	local cleanup = {
		Destroy = function()
			rootScope:doCleanup()
		end,
	}

	return cleanup
end

return ResourcesModule
