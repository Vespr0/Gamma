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
	local trove = Trove.new()
	local resourcesState = rootScope:Value({})

	-- Listen for EntityAdded events to update the currentClientEntity Fusion Value
	local function updateEntity(entity)
		local entityResourcesComponent = entity.resources

		entityResourcesComponent.trove:Add(entityResourcesComponent.resourcesDataChanged:Connect(function()
			resourcesState:set(entityResourcesComponent.resourcesData)
			warn(entityResourcesComponent.resourcesData)
		end))

		-- Also set the initial state from the new entity's resources (or empty if no entity)
		resourcesState:set(entityResourcesComponent.resourcesData or {})
	end
	if ui.entity then
		updateEntity(ui.entity)
	end
	ui.events.EntityAdded:Connect(function(entity)
		updateEntity(entity)
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
