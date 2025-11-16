local Hotbar = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Modules
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Slot = require(ReplicatedStorage.UI.Components.Slot)
local HotbarComponent = require(ReplicatedStorage.UI.Components.Hotbar)
local Viewports = require(script.Parent.Parent.Viewports)

local Children = Fusion.Children
local peek = Fusion.peek

Hotbar.CharacterDependant = true

function Hotbar.InitUi(ui)
	local MainGui = ui.GetGui("MainGui")

	local rootScope = Fusion.scoped(Fusion)

	local focusedIndex = rootScope:Value(nil)
	local tools = rootScope:Value({})

	if ui.backpack and ui.backpack.tools then
		local initialTools = {}
		for _, tool in ipairs(ui.backpack.tools:GetChildren()) do
			local index = tool:GetAttribute("Index")
			if index then
				initialTools[index] = tool
			end
		end
		tools:set(initialTools)
	end

	local toolArray = rootScope:Computed(function(use)
		local asArray = {}
		for _, t in pairs(use(tools)) do
			table.insert(asArray, t)
		end
		table.sort(asArray, function(a, b)
			return a:GetAttribute("Index") < b:GetAttribute("Index")
		end)
		return asArray
	end)

	HotbarComponent(rootScope, {
		Parent = MainGui,
		Children = rootScope:ForValues(toolArray, function(use, scope, tool)
			local index = tool:GetAttribute("Index")
			return Slot(scope, {
				LayoutOrder = index,
				Number = tostring(index),
				Tool = tool,
				GetItemViewport = Viewports.GetItemViewport,
				Focused = scope:Computed(function(use)
					return use(focusedIndex) == index
				end),
			})
		end),
	})

	local function addSlot(tool: Tool, index: number)
		local currentTools = peek(tools)
		currentTools[index] = tool
		tools:set(currentTools)
	end

	local function removeSlot(index: number)
		local currentTools = peek(tools)
		currentTools[index] = nil
		tools:set(currentTools)
	end

	local function focusSlot(_, index: number)
		focusedIndex:set(index)
	end

	local function unfocusSlot(_, index: number)
		if peek(focusedIndex) == index then
			focusedIndex:set(nil)
		end
	end

	ui.events.ToolAdded:Connect(addSlot)
	ui.events.ToolRemoved:Connect(removeSlot)
	ui.events.ToolEquip:Connect(focusSlot)
	ui.events.ToolUnequip:Connect(unfocusSlot)

	local cleanup = {
		Destroy = function()
			rootScope:doCleanup()
		end,
	}

	return cleanup
end

return Hotbar
