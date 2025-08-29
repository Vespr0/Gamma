local Hotbar = {}

-- Services
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Modules
local Viewports = require(script.Parent.Parent.Viewports)
local Trove = require(ReplicatedStorage.Packages.trove)

Hotbar.CharacterDependant = true

function Hotbar.InitUi(ui)
    -- Ui Elements
    local HotbarGui = ui.GetGui("Hotbar")
    -- Main frames
    local HotbarFrame = HotbarGui:WaitForChild("Main")
    -- Templates
    local Slot = ui.MakeTemplate(HotbarFrame.Slot)
	-- Trove
	local trove = Trove.new()
	-- Variables
    local lastFocusedIndex = nil

    -- Functions
    local function addSlot(tool: Tool,index)
        local slot = Slot:Clone()
        slot.Parent = HotbarFrame
        slot.Name = "Slot"..index
        slot.Inner.Number.Text = index
        slot.LayoutOrder = index

        Viewports.GetItemViewport(tool,slot.Inner.Viewport)
    end

	local function getSlot(index)
		assert(index, `Index must not be nil.`)
		
        return HotbarFrame:FindFirstChild("Slot"..index)
    end

	local function removeSlot(index)
		assert(index, `Index must not be nil.`)
		
        local slot = getSlot(index)
        if slot then
            slot:Destroy()
        end
    end

    local function unfocusSlot(_,index)
		assert(index, `Index must not be nil.`)
		
        local slot = getSlot(index)
        if slot then
            local inner = slot.Inner  
            local goal = {Position = UDim2.fromScale(0.5, 0.5)}
            local tween = TweenService:Create(inner, TweenInfo.new(0.3), goal)
            tween:Play()
        end

        lastFocusedIndex = nil
	end

	local function focusSlot(_,index)
		assert(index, `Index must not be nil.`)
		
        local slot = getSlot(index)
        if slot then
            local inner = slot.Inner
            local goal = {Position = UDim2.new(0.5, 0, 0.5, -10)}
            local tween = TweenService:Create(inner, TweenInfo.new(0.2), goal)
            tween:Play() 
        end

        -- Unfocus the previous slot
        if lastFocusedIndex then
            unfocusSlot(nil,lastFocusedIndex)
        end

        lastFocusedIndex = index
    end
	
    -- If the backpack already has tools, add them to the hotbar
    if ui.backpack then
        for _,tool in ui.backpack.tools:GetChildren() do
            addSlot(tool,tool:GetAttribute("Index"))
        end
    end
	
	trove:Add(ui.events.ToolAdded:Connect(addSlot))
	trove:Add(ui.events.ToolRemoved:Connect(removeSlot))
	trove:Add(ui.events.ToolEquip:Connect(focusSlot))
	trove:Add(ui.events.ToolUnequip:Connect(unfocusSlot))
	
	return trove
end

return Hotbar