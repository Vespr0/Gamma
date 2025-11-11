# ProceduralAnimationSystem 

## 1.0 Overview

This document refines version 3.0. It maintains the **composition-based, additive** architecture designed to layer procedural effects on top of existing `Animator`-driven animations.

The key change in this version is the integration of **`trove`** (assumed to be at `ReplicatedStorage.Packages.trove`) for robust garbage collection. The `ProceduralAnimationController` will use `trove` to manage its update loop connection and the lifecycle of all loaded components, simplifying cleanup and preventing memory leaks.

## 2.0 Core Class: ProceduralAnimationController

This class manages the rig, coordinates components, and now uses `trove` to manage its resources.

### 2.1 Properties

  * **`rig` (Model):** A reference to the R6 character model.
  * **`humanoid` (Humanoid):** A reference to the rig's Humanoid.
  * **`motors` (Dictionary\<string, Motor6D\>):** A dictionary mapping joint names to their `Motor6D` instances (e.g., "Waist", "Neck").
  * **`components` (Dictionary\<string, Component\>):** A dictionary of all active, loaded component instances.
  * **`trove` (Trove):** An instance of `trove` used for garbage collection.

### 2.2 Constructor: `new(rig)`

1.  **Arguments:** Takes the `rig` (Model).
2.  **Validation:** Asserts the existence of a `Humanoid`, `HumanoidRootPage`, and R6 body parts.
3.  **Dependencies:** Requires `trove` from `ReplicatedStorage.Packages.trove`.
4.  **Initialization:**
      * `self.trove = trove.new()`
      * `self.components = {}`
5.  **Motor Indexing:** Scans the rig and populates `self.motors` with all R6 `Motor6D`s (e.g., "Waist", "Neck", "Left Hip").
6.  **Bind Update Loop:** The `RenderStepped` connection is now managed by `trove`.
      * `self.trove:Connect(game:GetService("RunService").RenderStepped, function(dt) self:_onUpdate(dt) end)`
7.  Returns the `self` instance.

### 2.3 Public Methods

  * **`LoadComponent(componentModule: ModuleScript, params: table?)`**

      * This is the core of the composition system.
      * **Logic:**
        1.  Requires the `componentModule`.
        2.  Calls the component's `new()` constructor, passing `self` (the controller) and `params`.
        3.  Stores the new component instance: `self.components[component.Name] = componentInstance`
        4.  **Adds the component to the trove for cleanup:**
              * `self.trove:Add(componentInstance)`
              * This assumes the component instance has a `:Destroy()` method, as defined by the component interface.
        5.  Returns the `componentInstance` to the calling script.

  * **`GetComponent(componentName: string)`**

      * Returns the active component instance from `self.components` matching `componentName`.

  * **`Destroy()`**

      * **Cleanup:** The `Destroy` method is now greatly simplified.
        1.  `self.trove:Destroy()`
              * This automatically disconnects the `RenderStepped` connection.
              * This automatically calls `:Destroy()` on all component instances added via `LoadComponent`.
      * **Reset Pose:** After `trove` has run, manually reset motor transforms to clear visual effects.
          * `for _, motor in pairs(self.motors) do motor.Transform = CFrame.new() end`
      * **Clear References:**
          * `self.rig = nil`
          * `self.humanoid = nil`
          * `self.motors = nil`
          * `self.components = nil`

-----

## 3.0 Controller Update Logic (Private)

### 3.1 Main Update Loop: `_onUpdate(deltaTime)`

This logic remains unchanged from V3.0. It runs every frame on `RenderStepped`.

1.  **Initialize Offset Buffer:** `local combinedOffsets = {}`
2.  **Poll Components:**
      * Iterates through `self.components`.
      * Calls `local componentOffsets = component:Update(deltaTime)`.
3.  **Aggregate Offsets:**
      * Multiplies all returned offsets for each motor.
      * `combinedOffsets[motorName] = (combinedOffsets[motorName] or CFrame.new()) * offsetCFrame`
4.  **Apply to Rig (Additive):**
      * Iterates through `self.motors`.
      * Gets the `finalOffset` from `combinedOffsets`.
      * Reads the `Animator`'s current pose: `local animationTransform = motor.Transform`
      * **Applies the procedural offset additively:**
          * `motor.Transform = animationTransform * finalOffset`

-----

## 4.0 Component Architecture (Interface)

The component interface remains the same. Components that create their own connections (e.g., to `UserInputService`) are **highly encouraged** to use their *own* `trove` instance for internal cleanup, which will be triggered by the controller's `trove`.

  * **`Component.Name` (string):** A static property.
  * **`Component.new(controller, params)`:** The constructor.
  * **`ComponentInstance:Update(deltaTime)`:** Called every frame. Must return a dictionary of `[motorName] = CFrameOffset`. Must handle its own smoothing.
  * **`ComponentInstance:Destroy()`:** Called by the controller's `trove` during cleanup. Used to clear references (like `self.controller = nil`) and call its own `trove:Destroy()` if it has one.

-----

## 5.0 Example Component: `ProceduralCrouching.lua`

This simple component does not require its own `trove`, as it creates no internal connections. Its `Destroy` method is just for breaking references.

```lua
-- In ReplicatedStorage/ProceduralCrouching.lua
local Component = {}
Component.Name = "ProceduralCrouching"
Component.__index = Component

local function lerp(a, b, t)
    return a + (b - a) * t
end

-- Constructor
function Component.new(controller, params)
    local self = setmetatable({}, Component)
    
    self.Name = Component.Name
    self.controller = controller -- Store reference
    
    self.params = {
        crouchHeight = (params and params.crouchHeight) or -1.5,
        hipAngle = (params and params.hipAngle) or 45,
        lerpSpeed = (params and params.lerpSpeed) or 10,
    }
    
    self.state = {
        isCrouching = false,
        currentAlpha = 0,
    }
    
    return self
end

-- Public method for external scripts to call
function Component:SetCrouching(isCrouching)
    self.state.isCrouching = isCrouching
end

-- Main update logic, called by the controller
function Component:Update(deltaTime)
    local targetAlpha = self.state.isCrouching and 1.0 or 0.0
    
    -- Smooth the alpha value
    local t = 1 - math.exp(-self.params.lerpSpeed * deltaTime)
    self.state.currentAlpha = lerp(self.state.currentAlpha, targetAlpha, t)
    
    if self.state.currentAlpha < 0.001 then
        return {} 
    end
    
    -- Calculate CFrame offsets
    local waistY = self.state.currentAlpha * self.params.crouchHeight
    local hipRad = math.rad(self.state.currentAlpha * self.params.hipAngle)
    
    return {
        ["Waist"] = CFrame.new(0, waistY, 0),
        ["Left Hip"] = CFrame.Angles(hipRad, 0, 0),
        ["Right Hip"] = CFrame.Angles(hipRad, 0, 0),
    }
end

-- Cleanup method, called by the controller's trove
function Component:Destroy()
    -- Break circular reference
    self.controller = nil 
end

return Component
```