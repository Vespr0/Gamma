Trove

A Trove is helpful for tracking any sort of object during runtime that needs to get cleaned up at some point.
Types
Trackable
</>
type Trackable = Instance
 | RBXScriptConnection
 | ConnectionLike | PromiseLike | thread | ((...any) → ...any) | Destroyable | DestroyableLowercase | Disconnectable | DisconnectableLowercase

Represents all trackable objects by Trove.
ConnectionLike
</>
interface ConnectionLike {
Connected: boolean
Disconnect: (self) → ()
}
SignalLike
</>
interface SignalLike {
Connect: (
self,
callback: (...any) → ...any
) → ConnectionLike
Once: (
self,
callback: (...any) → ...any
) → ConnectionLike
}
PromiseLike
</>
interface PromiseLike {
getStatus: (self) → string
finally: (
self,
callback: (...any) → ...any
) → PromiseLike
cancel: (self) → ()
}
Constructable
</>
type Constructable = {new: (A...) → T} | (A...) → T
Destroyable
</>
interface Destroyable {
disconnect: (self) → ()
}
DestroyableLowercase
</>
interface DestroyableLowercase {
disconnect: (self) → ()
}
Disconnectable
</>
interface Disconnectable {
disconnect: (self) → ()
}
DisconnectableLowercase
</>
interface DisconnectableLowercase {
disconnect: (self) → ()
}
Functions
new
</>
Trove.new() → Trove

Constructs a Trove object.

local trove = Trove.new()

Add
</>
Trove:Add(
object: any,--

Object to track
cleanupMethod: string?--

Optional cleanup name override
) → object: any

Adds an object to the trove. Once the trove is cleaned or destroyed, the object will also be cleaned up.

The following types are accepted (e.g. typeof(object)):
Type 	Cleanup
Instance 	object:Destroy()
RBXScriptConnection 	object:Disconnect()
function 	object()
thread 	task.cancel(object)
table 	object:Destroy() or object:Disconnect() or object:destroy() or object:disconnect()
table with cleanupMethod 	object:<cleanupMethod>()

Returns the object added.

-- Add a part to the trove, then destroy the trove,
-- which will also destroy the part:
local part = Instance.new("Part")
trove:Add(part)
trove:Destroy()

-- Add a function to the trove:
trove:Add(function()
	print("Cleanup!")
end)
trove:Destroy()

-- Standard cleanup from table:
local tbl = {}
function tbl:Destroy()
	print("Cleanup")
end
trove:Add(tbl)

-- Custom cleanup from table:
local tbl = {}
function tbl:DoSomething()
	print("Do something on cleanup")
end
trove:Add(tbl, "DoSomething")

Clone
</>
Trove:Clone() → Instance

Clones the given instance and adds it to the trove. Shorthand for trove:Add(instance:Clone()).

local clonedPart = trove:Clone(somePart)

Construct
</>
Trove:Construct(
class: {new(Args...) → T} | (Args...) → T,
...: Args...
) → T

Constructs a new object from either the table or function given.

If a table is given, the table's new function will be called with the given arguments.

If a function is given, the function will be called with the given arguments.

The result from either of the two options will be added to the trove.

This is shorthand for trove:Add(SomeClass.new(...)) and trove:Add(SomeFunction(...)).

local Signal = require(somewhere.Signal)

-- All of these are identical:
local s = trove:Construct(Signal)
local s = trove:Construct(Signal.new)
local s = trove:Construct(function() return Signal.new() end)
local s = trove:Add(Signal.new())

-- Even Roblox instances can be created:
local part = trove:Construct(Instance, "Part")

Connect
</>
Trove:Connect(
signal: RBXScriptSignal
,
fn: (...: any) → ()
) → RBXScriptConnection

Connects the function to the signal, adds the connection to the trove, and then returns the connection.

This is shorthand for trove:Add(signal:Connect(fn)).

trove:Connect(workspace.ChildAdded, function(instance)
	print(instance.Name .. " added to workspace")
end)

BindToRenderStep
</>
Trove:BindToRenderStep(
name: string,
priority: number,
fn: (dt: number) → ()
) → ()

Calls RunService:BindToRenderStep and registers a function in the trove that will call RunService:UnbindFromRenderStep on cleanup.

trove:BindToRenderStep("Test", Enum.RenderPriority.Last.Value, function(dt)
	-- Do something
end)

AddPromise
</>
Trove:AddPromise(promise: Promise) → Promise

Gives the promise to the trove, which will cancel the promise if the trove is cleaned up or if the promise is removed. The exact promise is returned, thus allowing chaining.

trove:AddPromise(doSomethingThatReturnsAPromise())
	:andThen(function()
		print("Done")
	end)
-- Will cancel the above promise (assuming it didn't resolve immediately)
trove:Clean()

local p = trove:AddPromise(doSomethingThatReturnsAPromise())
-- Will also cancel the promise
trove:Remove(p)

Promise v4 Only

This is only compatible with the roblox-lua-promise library, version 4.
Remove
</>
Trove:Remove(object: any) → ()

Removes the object from the Trove and cleans it up.

local part = Instance.new("Part")
trove:Add(part)
trove:Remove(part)

Extend
</>
Trove:Extend() → Trove

Creates and adds another trove to itself. This is just shorthand for trove:Construct(Trove). This is useful for contexts where the trove object is present, but the class itself isn't.
NOTE

This does not clone the trove. In other words, the objects in the trove are not given to the new constructed trove. This is simply to construct a new Trove and add it as an object to track.

local trove = Trove.new()
local subTrove = trove:Extend()

trove:Clean() -- Cleans up the subTrove too

Clean
</>
Trove:Clean() → ()

Cleans up all objects in the trove. This is similar to calling Remove on each object within the trove. The ordering of the objects removed is not guaranteed.

trove:Clean()

WrapClean
</>
Trove:WrapClean() → ()

Returns a function that wraps the trove's Clean() method. Calling the returned function will clean up the trove.

This is often useful in contexts where functions are the primary mode for cleaning up an environment, such as in many "observer" patterns.

local cleanup = trove:WrapClean()

-- Sometime later...
cleanup()

-- Common observer pattern example:
someObserver(function()
	local trove = Trove.new()
	-- Foo
	return trove:WrapClean()
end)

AttachToInstance
</>
Trove:AttachToInstance(instance: Instance
) → RBXScriptConnection

Attaches the trove to a Roblox instance. Once this instance is removed from the game (parent or ancestor's parent set to nil), the trove will automatically clean up.

This inverses the ownership of the Trove object, and should only be used when necessary. In other words, the attached instance dictates when the trove is cleaned up, rather than the trove dictating the cleanup of the instance.
CAUTION

Will throw an error if instance is not a descendant of the game hierarchy.

trove:AttachToInstance(somePart)
trove:Add(function()
	print("Cleaned")
end)

-- Destroying the part will cause the trove to clean up, thus "Cleaned" printed:
somePart:Destroy()

Destroy
</>
Trove:Destroy() → ()

Alias for trove:Clean().

trove:Destroy()

Show raw api

