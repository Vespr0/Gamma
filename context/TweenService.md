========================
CODE SNIPPETS
========================
TITLE: Check Tween Instance Type in Lua
DESCRIPTION: A Lua code sample demonstrating how to create a Tween and then check if its associated Instance is a BasePart using the IsA method. This snippet utilizes the TweenService to create a tween for a Part instance.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/Tween

LANGUAGE: Lua
CODE:
```
local TweenService = game:GetService("TweenService")

localfunctionisInstanceAPart(tween)
  local instance = tween.Instance
  return instance:IsA("BasePart")
end

local tweenInfo = TweenInfo.new()
local instance = Instance.new("Part")

local tween = TweenService:Create(instance, tweenInfo, {
  Transparency = 1,
})

print(isInstanceAPart(tween))
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/WedgePart

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/VirtualUser

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/TaskScheduler

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Handle Tween Conflict
DESCRIPTION: Illustrates a scenario with two conflicting tweens animating the same Part. When both tweens are played, the first is cancelled and overwritten by the second. The output shows the completion states of both tweens.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/TweenBase

LANGUAGE: Lua
CODE:
```
local TweenService = game:GetService("TweenService")

local part = Instance.new("Part")

part.Position = Vector3.new(0, 10, 0)

part.Anchored = true
part.Parent = game.Workspace

local tweenInfo = TweenInfo.new(5)

-- create two conflicting tweens (both trying to animate part.Position)
local tween1 = TweenService:Create(part, tweenInfo, { Position = Vector3.new(0, 10, 20) })

local tween2 = TweenService:Create(part, tweenInfo, { Position = Vector3.new(0, 30, 0) })

-- listen for their completion status
tween1.Completed:Connect(function(playbackState)
print("tween1: " .. tostring(playbackState))
end)

tween2.Completed:Connect(function(playbackState)
print("tween2: " .. tostring(playbackState))
end)

-- try to play them both
tween1:Play()

tween2:Play()
```

----------------------------------------

TITLE: Tween Conflict Demonstration
DESCRIPTION: This sample illustrates tween conflict by creating two tweens that attempt to animate the same property (Position) of a part in conflicting directions. When played concurrently, the first tween is cancelled by the second, demonstrating how the Tween.Completed event fires with Enum.PlaybackState.Cancelled for the interrupted tween.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/TweenBase

LANGUAGE: lua
CODE:
```
local TweenService = game:GetService("TweenService")

local part = Instance.new("Part")
part.Position = Vector3.new(0, 10, 0)
part.Anchored = true
part.Parent = game.Workspace

local tweenInfo = TweenInfo.new(5)

-- create two conflicting tweens (both trying to animate part.Position)
local tween1 = TweenService:Create(part, tweenInfo, { Position = Vector3.new(0, 10, 20) })
local tween2 = TweenService:Create(part, tweenInfo, { Position = Vector3.new(0, 30, 0) })

-- listen for their completion status
tween1.Completed:Connect(function(playbackState)
	print("tween1: " .. tostring(playbackState))
end)

tween2.Completed:Connect(function(playbackState)
	print("tween2: " .. tostring(playbackState))
end)

-- try to play them both
tween1:Play()
tween2:Play()
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/TweenService

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/WorldRoot

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/ReflectionMetadataMember

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/AudioTextToSpeech

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/AudioCompressor

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Pause and Resume Roblox Tween
DESCRIPTION: This snippet illustrates how to pause and resume a tween's playback. While the tween is paused, other properties of the Part, such as its BrickColor, can be modified. The tween then resumes from its current state.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/TweenService

LANGUAGE: lua
CODE:
```
local TweenService = game:GetService("TweenService")

local part = Instance.new("Part")

part.Position = Vector3.new(0, 10, 0)

part.Anchored = true
part.BrickColor = BrickColor.new("Bright green")

part.Parent = workspace

local goal = {}

goal.Position = Vector3.new(50, 10, 0)

local tweenInfo = TweenInfo.new(10, Enum.EasingStyle.Linear)

local tween = TweenService:Create(part, tweenInfo, goal)

tween:Play()

task.wait(3)

part.BrickColor = BrickColor.new("Bright red")

tween:Pause()

task.wait(2)

part.BrickColor = BrickColor.new("Bright green")

tween:Play()

```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/Torque

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/AudioPitchShifter

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/SurfaceLight

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/ReflectionMetadataEnum

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/AudioDeviceOutput

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/VideoPlayer

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/Vector3Value

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/Backpack

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox: Tween Conflict Demonstration
DESCRIPTION: This sample illustrates tween conflicts where two tweens attempt to animate the same property (Position) of an object in different directions. It shows how the second tween cancels the first, and how the Tween.Completed event reports 'Cancelled' for the interrupted tween and 'Completed' for the successful one.

SOURCE: https://create.roblox.com/docs/en-us/reference/engine/classes/TweenBase

LANGUAGE: lua
CODE:
```
local TweenService = game:GetService("TweenService")

local part = Instance.new("Part")
part.Position = Vector3.new(0, 10, 0)
part.Anchored = true
part.Parent = game.Workspace

local tweenInfo = TweenInfo.new(5)

-- create two conflicting tweens (both trying to animate part.Position)
local tween1 = TweenService:Create(part, tweenInfo, { Position = Vector3.new(0, 10, 20) })
local tween2 = TweenService:Create(part, tweenInfo, { Position = Vector3.new(0, 30, 0) })

-- listen for their completion status
tween1.Completed:Connect(function(playbackState)
	print("tween1: " .. tostring(playbackState))
end)

tween2.Completed:Connect(function(playbackState)
	print("tween2: " .. tostring(playbackState))
end)

-- try to play them both
tween1:Play()
tween2:Play()
```

----------------------------------------

TITLE: Pause Tween Playback in Roblox
DESCRIPTION: Halts the playback of a tween, allowing it to be resumed from the paused point. This method only affects tweens in the PlaybackState.Playing state. Attempting to pause a tween in other states, like Delayed, will fail.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/TweenBase

LANGUAGE: Lua
CODE:
```
local TweenService = game:GetService("TweenService")

local part = Instance.new("Part")

part.Position = Vector3.new(0, 10, 0)

part.Anchored = true
part.BrickColor = BrickColor.new("Bright green")

part.Parent = workspace

local goal = {}
goal.Position = Vector3.new(50, 10, 0)

local tweenInfo = TweenInfo.new(10, Enum.EasingStyle.Linear)

local tween = TweenService:Create(part, tweenInfo, goal)

tween:Play()

task.wait(3)

part.BrickColor = BrickColor.new("Bright red")

tween:Pause()

task.wait(2)

part.BrickColor = BrickColor.new("Bright green")

tween:Play()
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/ReflectionMetadataEnums

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/AudioAnalyzer

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/WorldModel

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Tween Position and Rotation for UI Object
DESCRIPTION: Demonstrates how to create a tween that simultaneously animates both the Position and Rotation properties of a UI element. This combines multiple target properties into a single tween operation.

SOURCE: https://create.roblox.com/docs/ui/animation

LANGUAGE: lua
CODE:
```
local TweenService = game:GetService("TweenService")

local Players = game:GetService("Players")

local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = PlayerGui:WaitForChild("ScreenGui")

local object = ScreenGui:WaitForChild("ImageLabel")

object.AnchorPoint = Vector2.new(0.5, 0.5)

local targetPosition = UDim2.new(0.5, 0, 0.5, 0)

local targetRotation = 45


local tweenInfo = TweenInfo.new(2)

local tween = TweenService:Create(object, tweenInfo, {Position = targetPosition, Rotation = targetRotation})


tween:Play()

```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/Workspace

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/SessionCheckService

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Pause and Resume Roblox Tween
DESCRIPTION: Demonstrates pausing and resuming a tween's playback. This example also shows how to change a Part's BrickColor while the tween is paused, illustrating that the tween state is maintained.

SOURCE: https://create.roblox.com/docs/en-us/reference/engine/classes/TweenService

LANGUAGE: lua
CODE:
```
local TweenService = game:GetService("TweenService")

local part = Instance.new("Part")

part.Position = Vector3.new(0, 10, 0)

part.Anchored = true
part.BrickColor = BrickColor.new("Bright green")
part.Parent = workspace

local goal = {}

goal.Position = Vector3.new(50, 10, 0)

local tweenInfo = TweenInfo.new(10, Enum.EasingStyle.Linear)

local tween = TweenService:Create(part, tweenInfo, goal)

tween:Play()

task.wait(3)

part.BrickColor = BrickColor.new("Bright red")

tween:Pause()

task.wait(2)

part.BrickColor = BrickColor.new("Bright green")

tween:Play()
```

----------------------------------------

TITLE: Roblox Lua: Check Tween Instance Type
DESCRIPTION: A Lua code sample demonstrating how to check if the Instance associated with a Roblox Tween is a BasePart. This involves accessing the tween's Instance property and using the IsA method. It's a common pattern for conditional logic based on the tweened object.

SOURCE: https://create.roblox.com/docs/en-us/reference/engine/classes/Tween

LANGUAGE: lua
CODE:
```
local TweenService = game:GetService("TweenService")

local function isInstanceAPart(tween)
  local instance = tween.Instance
  return instance:IsA("BasePart")
end

local tweenInfo = TweenInfo.new()
local instance = Instance.new("Part")

local tween = TweenService:Create(instance, tweenInfo, {
  Transparency = 1,
})

print(isInstanceAPart(tween))
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/AudioSearchParams

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Create and Play a Basic Tween
DESCRIPTION: Demonstrates creating a Tween to animate the position and color of a Roblox Part using TweenService. It sets up initial properties, defines goal properties, and plays the tween.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/TweenBase

LANGUAGE: Lua
CODE:
```
local TweenService = game:GetService("TweenService")

local part = Instance.new("Part")

part.Position = Vector3.new(0, 10, 0)

part.Color = Color3.new(1, 0, 0)

part.Anchored = true
part.Parent = game.Workspace

local goal = {}

goal.Position = Vector3.new(10, 10, 0)

goal.Color = Color3.new(0, 1, 0)

local tweenInfo = TweenInfo.new(5)

local tween = TweenService:Create(part, tweenInfo, goal)

tween:Play()
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/AudioChannelMixer

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/AudioEqualizer

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/TremoloSoundEffect

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/MemoryStoreService

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Tween GUI Position with Callback (Lua)
DESCRIPTION: This Lua code sample demonstrates tweening a GUI object's position to a target UDim2. It includes a callback function to detect tween completion or cancellation and checks if the tween will play.

SOURCE: https://create.roblox.com/docs/en-us/reference/engine/classes/GuiObject

LANGUAGE: Lua
CODE:
```
local START_POSITION = UDim2.new(0, 0, 0, 0)

local GOAL_POSITION = UDim2.new(1, 0, 1, 0)

local guiObject = script.Parent

local function callback(state)
    if state == Enum.TweenStatus.Completed then
        print("The tween completed uninterrupted")
    elseif state == Enum.TweenStatus.Canceled then
        print("Another tween cancelled this one")
    end
end

-- Initialize the GuiObject position, then start the tween:
guiObject.Position = START_POSITION

local willPlay = guiObject:TweenPosition(
    GOAL_POSITION, -- Final position the tween should reach
    Enum.EasingDirection.In, -- Direction of the easing
    Enum.EasingStyle.Sine, -- Kind of easing to apply
    2, -- Duration of the tween in seconds
    true, -- Whether in-progress tweens are interrupted
    callback -- Function to be callled when on completion/cancelation
)

if willPlay then
    print("The tween will play")
else
    print("The tween will not play")
end

```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/Atmosphere

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/MaterialVariant

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/ProcessInstancePhysicsService

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/AtmosphereSensor

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Demonstrate TweenBase:Cancel()
DESCRIPTION: This sample illustrates the behavior of the TweenBase:Cancel() method. A tween is played, then cancelled midway. Upon resuming, it's observed that the tween takes its full duration to complete, highlighting the reset of tween variables.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/TweenBase

LANGUAGE: Lua
CODE:
```
local TweenService = game:GetService("TweenService")

local part = Instance.new("Part")
part.Position = Vector3.new(0, 10, 0)
part.Anchored = true
part.Parent = workspace

local goal = {}
goal.Position = Vector3.new(0, 50, 0)

local tweenInfo = TweenInfo.new(5)
local tween = TweenService:Create(part, tweenInfo, goal)

tween:Play()
task.wait(2.5)

tween:Cancel()

local playTick = tick()
tween:Play()
tween.Completed:Wait()

local timeTaken = tick() - playTick
print("Tween took " .. tostring(timeTaken) .. " secs to complete")

-- The tween will take 5 seconds to complete as the tween variables have been reset by tween:Cancel()
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/WrapLayer

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/BackpackItem

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox: Verify Tween Completion for Effects
DESCRIPTION: This example shows how to use the Tween.Completed event to check if a tween finished successfully. If the tween's final PlaybackState is 'Completed', an explosion effect is created at the part's position, and the part is destroyed. This pattern is useful for chaining tweens or linking them to other game events.

SOURCE: https://create.roblox.com/docs/en-us/reference/engine/classes/TweenBase

LANGUAGE: lua
CODE:
```
local TweenService = game:GetService("TweenService")

local part = Instance.new("Part")
part.Position = Vector3.new(0, 50, 0)
part.Anchored = true
part.Parent = workspace

local goal = {}
goal.Position = Vector3.new(0, 0, 0)

local tweenInfo = TweenInfo.new(3)

local tween = TweenService:Create(part, tweenInfo, goal)

local function onTweenCompleted(playbackState)
	if playbackState == Enum.PlaybackState.Completed then
		local explosion = Instance.new("Explosion")
		explosion.Position = part.Position
		explosion.Parent = workspace
		part:Destroy()

		task.delay(2, function()
			if explosion then
				explosion:Destroy()
			end
		end)
	end
end

tween.Completed:Connect(onTweenCompleted)

tween:Play()
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/RenderingTest

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox TweenService: Handling Tween Conflicts
DESCRIPTION: Demonstrates how Roblox TweenService handles conflicts when multiple tweens attempt to animate the same property on an object. The first tween is cancelled and overwritten by the second.

SOURCE: https://create.roblox.com/docs/en-us/reference/engine/classes/TweenBase

LANGUAGE: lua
CODE:
```
local TweenService = game:GetService("TweenService")

local part = Instance.new("Part")

part.Position = Vector3.new(0, 10, 0)

part.Anchored = true

part.Parent = game.Workspace

local tweenInfo = TweenInfo.new(5)

-- create two conflicting tweens (both trying to animate part.Position)

local tween1 = TweenService:Create(part, tweenInfo, { Position = Vector3.new(0, 10, 20) })

local tween2 = TweenService:Create(part, tweenInfo, { Position = Vector3.new(0, 30, 0) })

-- listen for their completion status

tween1.Completed:Connect(function(playbackState)

print("tween1: " .. tostring(playbackState))

end)


tween2.Completed:Connect(function(playbackState)

print("tween2: " .. tostring(playbackState))

end)

-- try to play them both

tween1:Play()

tween2:Play()

```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/ReflectionMetadata

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/TimerService

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/Wire

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Loop Roblox Tween
DESCRIPTION: This sample shows how to create a tween that loops indefinitely. By setting RepeatCount to -1 and Reverses to true in TweenInfo, the animation will play forward, reverse, and repeat continuously. It also demonstrates cancelling a tween after a delay.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/TweenService

LANGUAGE: lua
CODE:
```
local TweenService = game:GetService("TweenService")

local part = Instance.new("Part")

part.Position = Vector3.new(0, 10, 0)

part.Anchored = true
part.Parent = workspace

local tweenInfo = TweenInfo.new(
  2, -- Time
  Enum.EasingStyle.Linear, -- EasingStyle
  Enum.EasingDirection.Out, -- EasingDirection
  -1, -- RepeatCount (when less than zero the tween will loop indefinitely)
  true, -- Reverses (tween will reverse once reaching its goal)
  0-- DelayTime
)

local tween = TweenService:Create(part, tweenInfo, { Position = Vector3.new(0, 30, 0) })

tween:Play()

task.wait(10)

tween:Cancel() -- cancel the animation after 10 seconds

```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/WrapTarget

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/Weld

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/AudioPlayer

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/DataStorePages

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/UIScale

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/ServerStorage

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Tween PlaybackState Monitoring
DESCRIPTION: Demonstrates how to monitor and react to changes in a Tween's PlaybackState using GetPropertyChangedSignal. Connects a function to print the current state whenever it changes, such as when the tween starts, pauses, or ends.

SOURCE: https://create.roblox.com/docs/en-us/reference/engine/classes/TweenBase

LANGUAGE: Lua
CODE:
```
local TweenService = game:GetService("TweenService")

local part = Instance.new("Part")

part.Position = Vector3.new(0, 10, 0)

part.Anchored = true
part.Parent = workspace

local goal = {}

gOal.Orientation = Vector3.new(0, 90, 0)

local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 2, true, 0.5)

local tween = TweenService:Create(part, tweenInfo, goal)

local function onPlaybackChanged()
    print("Tween status has changed to:", tween.PlaybackState)
end

local playbackChanged = tween:GetPropertyChangedSignal("PlaybackState")

playbackChanged:Connect(onPlaybackChanged)

tween:Play()

```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/ShirtGraphic

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Tween Completed Event
DESCRIPTION: Details the 'Completed' event for the Roblox Tween class. This event fires when a tween finishes playing naturally or is stopped using the Cancel method. It provides the final playback state as an argument.

SOURCE: https://create.roblox.com/docs/en-us/reference/engine/classes/Tween

LANGUAGE: APIDOC
CODE:
```
Tween Events:

Completed(playbackState : Enum.PlaybackState):
  Fires when the tween finishes playing or is stopped with TweenBase:Cancel().
  Parameters:
    playbackState: The final state of the tween playback.
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/VectorForce

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/ReflectionMetadataClasses

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/WrapDeformer

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/Texture

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/ReplicatedStorage

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/FloorWire

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Looping a Tween
DESCRIPTION: Demonstrates creating a looped tween animation for a Roblox Part. Achieved by setting TweenInfo's RepeatCount to -1 and Reverses to true for indefinite, back-and-forth animation. Includes cancelling the tween.

SOURCE: https://create.roblox.com/docs/en-us/reference/engine/classes/TweenService

LANGUAGE: Lua
CODE:
```
local TweenService = game:GetService("TweenService")

local part = Instance.new("Part")

part.Position = Vector3.new(0, 10, 0)

part.Anchored = true
part.Parent = workspace

local tweenInfo = TweenInfo.new(
  2, -- Time
  Enum.EasingStyle.Linear, -- EasingStyle
  Enum.EasingDirection.Out, -- EasingDirection
  -1, -- RepeatCount (when less than zero the tween will loop indefinitely)
  true, -- Reverses (tween will reverse once reaching its goal)
  0-- DelayTime
)

local tween = TweenService:Create(part, tweenInfo, { Position = Vector3.new(0, 30, 0) })

tween:Play()

task.wait(10)

tween:Cancel() -- cancel the animation after 10 seconds
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/WireframeHandleAdornment

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/TextService

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox TweenService API: Play Method
DESCRIPTION: Starts playback of a tween. If playback has already started, calling Play() has no effect unless the tween has finished or is stopped. Multiple tweens can animate the same object if they don't animate the same property.

SOURCE: https://create.roblox.com/docs/en-us/reference/engine/classes/TweenBase

LANGUAGE: apidoc
CODE:
```
TweenBase:Play()
  Starts playback of a tween.

  Note: If playback has already started, calling Play() has no effect unless the tween has finished or is stopped (either by TweenBase:Cancel() or TweenBase:Pause()).
  Multiple tweens can be played on the same object at the same time, but they must not animate the same property. If two tweens attempt to modify the same property, the initial tween is cancelled and overwritten by the most recent tween.

  Returns:
    (void)

  Related Methods:
    - TweenBase:Pause()
    - TweenBase:Cancel()
    - TweenService:Create()

```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/WorkspaceAnnotation

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/Visit

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/UIStroke

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/TouchTransmitter

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/Tween

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/ViewportFrame

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/VideoCapture

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/VoiceChatService

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/ReflectionMetadataClass

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/Seat

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/ReflectionMetadataEvents

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/VisualizationModeService

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/WeldConstraint

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/VideoCaptureService

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/ReflectionMetadataItem

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/DataStoreSetOptions

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/VideoService

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/AudioSpeechToText

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/VideoDisplay

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/VisualizationModeCategory

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/ReflectionMetadataEnumItem

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/UIGradient

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/MemoryStoreSortedMap

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/TextFilterResult

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/AudioEmitter

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/VisibilityCheckDispatcher

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/ReflectionMetadataFunctions

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```

----------------------------------------

TITLE: Roblox Engine Class: Tween
DESCRIPTION: Represents a specific tween animation, allowing control over its playback, duration, and easing.

SOURCE: https://create.roblox.com/docs/reference/engine/classes/VisualizationMode

LANGUAGE: APIDOC
CODE:
```
RobloxEngineClass: Tween
  Description: Represents a tween animation.
  Category: Animation
  Reference: https://create.roblox.com/docs/reference/engine/classes/Tween
```