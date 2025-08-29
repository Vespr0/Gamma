========================
CODE SNIPPETS
========================
TITLE: Require Fusion Module from Source Code
DESCRIPTION: This snippet illustrates various ways to `require` the Fusion library when it's installed directly from source code. It covers common scenarios like Rojo, darklua, and vanilla Luau, showing how the path to the Fusion module might differ based on the project setup.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/get-started/installing-fusion.md#_snippet_1

----------------------------------------

TITLE: Require Fusion Module in Roblox Studio
DESCRIPTION: This snippet demonstrates how to `require` the Fusion module after it has been imported into `ReplicatedStorage` in Roblox Studio. It's used to verify a successful installation by checking for errors during runtime.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/get-started/installing-fusion.md#_snippet_0

LANGUAGE: Lua
CODE:
```
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Fusion)
```

----------------------------------------

TITLE: Complete Asynchronous Data Fetch Example with Fusion
DESCRIPTION: This comprehensive Lua example demonstrates how to handle asynchronous data fetching (simulated server call) within a Fusion application. It showcases managing loading states, preventing race conditions by canceling previous tasks, and updating reactive values (`currentUserBio`) using `Fusion.scoped`, `Fusion.Value`, `Fusion.Observer`, and Roblox's `task` scheduler.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/examples/cookbook/fetch-data-from-server.md#_snippet_0

LANGUAGE: Lua
CODE:
```
local Fusion = -- initialise Fusion here however you please!
local scoped = Fusion.scoped
local peek = Fusion.peek

local function fetchUserBio(
	userID: number
): string
	-- pretend this calls out to a server somewhere, causing this code to yield
	task.wait(1)
	return "This is the bio for user " .. userID .. "!"
end

-- Don't forget to pass this to `doCleanup` if you disable the script.
local scope = scoped(Fusion)

-- This doesn't have to be a `Value` - any kind of state object works too.
local currentUserID = scope:Value(1670764)

-- While the bio is loading, this is `nil` instead of a string.
local currentUserBio: Fusion.Value<string?> = scope:Value(nil)

do
	local fetchInProgress = nil
	local function performFetch()
		local userID = peek(currentUserID)
		currentUserBio:set(nil)
		if fetchInProgress ~= nil then
			task.cancel(fetchInProgress)
		end
		fetchInProgress = task.spawn(function()
			currentUserBio:set(fetchUserBio(userID))
			fetchInProgress = nil
		end)
	end
	scope:Observer(currentUserID):onBind(performFetch)
end

scope:Observer(currentUserBio):onBind(function()
	local bio = peek(currentUserBio)
	if bio == nil then
		print("User bio is loading...")
	else
		print("Loaded user bio:", bio)
	end
end)
```

----------------------------------------

TITLE: Example: Use ForPairs as a Scoped Method
DESCRIPTION: Demonstrates the recommended way to call `ForPairs` as a method on a `scope` object, simplifying its usage and adhering to best practices.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/api-reference/state/members/forpairs.md#_snippet_1

LANGUAGE: Lua
CODE:
```
local forObj = scope:ForPairs(inputTable, processor)
```

----------------------------------------

TITLE: Importing the Fusion Library in Lua
DESCRIPTION: This snippet demonstrates the initial setup for using Fusion in a Luau script. It retrieves the `ReplicatedStorage` service and then uses `require` to load the Fusion module, making its functionalities accessible for building reactive applications.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/fundamentals/your-first-project.md#_snippet_0

LANGUAGE: Lua
CODE:
```
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Fusion)
```

----------------------------------------

TITLE: Initialize a Simple Computed Object in Lua
DESCRIPTION: Illustrates the basic syntax for creating a `Computed` object using `scope:Computed()` with a simple, static calculation. This example shows the minimal setup for a computed value.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/fundamentals/computeds.md#_snippet_1

LANGUAGE: Lua
CODE:
```
local scope = scoped(Fusion)
local hardMaths = scope:Computed(function(_, _)
    return 1 + 1
end)
```

----------------------------------------

TITLE: Lua: Basic ForKeys Constructor and Key Transformation
DESCRIPTION: Illustrates the basic constructor call for `ForKeys`, taking an input table and a processor function. The processor function transforms each key, for example, converting it to uppercase.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/tables/forkeys.md#_snippet_1

LANGUAGE: Lua
CODE:
```
local data = {red = "foo", blue = "bar"}
local renamed = scope:ForKeys(data, function(use, scope, key)
	return string.upper(key)
end)
```

----------------------------------------

TITLE: Integrate PlayerList Component into Roblox ScreenGui
DESCRIPTION: Illustrates how the `PlayerList` component is instantiated and integrated into a Roblox `ScreenGui`. The `players` Fusion `Value` is passed to the component, enabling dynamic rendering of the player list within the GUI.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/examples/cookbook/player-list.md#_snippet_4

LANGUAGE: Lua
CODE:
```
local gui = scope:New "ScreenGui" {
	Name = "PlayerListGui",
	Parent = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui"),

	[Children] = scope:PlayerList {
		Players = players
	}
}
```

----------------------------------------

TITLE: Combine Different Child Parenting Methods in Fusion
DESCRIPTION: Shows a comprehensive example of combining various methods for parenting children using the `[Children]` key. This includes single instances, arrays of children, and computed state objects, providing flexible and dynamic child management.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/roblox/parenting.md#_snippet_7

LANGUAGE: Lua
CODE:
```
local modelChildren = workspace.Model:GetChildren()
local includeModel = scope:Value(true)

local folder = scope:New "Folder" {
    -- array of children
    [Children] = {
        -- single instance
        scope:New "Part" {
            Name = "Gregory",
            Color = Color3.new(1, 0, 0)
        },
        -- state object containing children (or nil)
        scope:Computed(function(use)
            return if use(includeModel)
                then modelChildren -- array of children
                else nil
        end)
    }
}
```

----------------------------------------

TITLE: Read Processed Table with peek()
DESCRIPTION: This example demonstrates how to retrieve the processed output from a `ForPairs` object using the `peek()` function. It shows the immediate result of the key-value transformation.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/tables/forpairs.md#_snippet_2

LANGUAGE: Lua
CODE:
```
local itemColours = { shoes = "red", socks = "blue" }
local swapped = scope:ForPairs(data, function(use, scope, item, colour)
	return colour, item
end)

print(peek(swapped)) --> { red = "shoes", blue = "socks" }
```

----------------------------------------

TITLE: Creating and Hydrating a TextLabel with Fusion's New Function
DESCRIPTION: This example demonstrates how to use `scope:New` to create a `TextLabel` instance, apply initial properties, and observe dynamic updates using `scope:Value`. It highlights how changes to the `scope:Value` propagate to the instance's properties.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/roblox/new-instances.md#_snippet_0

LANGUAGE: Lua
CODE:
```
local message = scope:Value("Hello there!")

local ui = scope:New "TextLabel" {
	Name = "Greeting",
	Parent = PlayerGui.ScreenGui,

	Text = message
}

print(ui.Name) --> Greeting
print(ui.Text) --> Hello there!

message:set("Goodbye friend!")
task.wait() -- important: changes are applied on the next frame!
print(ui.Text) --> Goodbye friend!
```

----------------------------------------

TITLE: Process Key-Value Pairs with ForPairs and State Objects
DESCRIPTION: This example demonstrates how `ForPairs` can process key-value pairs from a constant table while incorporating a state object (`owner`) into the transformation. It shows how changes to the state object dynamically update the output.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/tables/forpairs.md#_snippet_0

LANGUAGE: Lua
CODE:
```
local itemColours = { shoes = "red", socks = "blue" }
local owner = scope:Value("Janet")

local manipulated = scope:ForPairs(itemColours, function(use, scope, thing, colour)
	local newKey = colour
	local newValue = use(owner) .. "'s " .. thing
	return newKey, newValue
end)

print(peek(manipulated)) --> {red = "Janet's shoes", blue = "Janet's socks"}

owner:set("April")
print(peek(manipulated)) --> {red = "April's shoes", blue = "April's socks"}
```

----------------------------------------

TITLE: Luau Example: Demonstrating Fusion's Update Skipping with isEven Computed
DESCRIPTION: This Luau code demonstrates Fusion's update skipping mechanism. It sets up a 'number' value, a 'isEven' computed property, and an observer that prints when 'isEven' changes. The example shows how the observer only triggers when the computed value meaningfully changes, even if the underlying 'number' changes, illustrating Fusion's optimization.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/best-practices/optimisation.md#_snippet_0

LANGUAGE: Luau
CODE:
```
local number = scope:Value(1)
local isEven = scope:Computed(function(use)
	return use(number) % 2 == 0
end)
scope:Observer(isEven):onChange(function()
	print("-> isEven has changed to " .. peek(isEven))
end)

print("Number becomes 2")
number:set(2)
print("Number becomes 3")
number:set(3)
print("Number becomes 13")
number:set(13)
print("Number becomes 14")
number:set(14)
print("Number becomes 24")
number:set(24)
```

LANGUAGE: Output
CODE:
```
Number becomes 2
-> isEven has changed to true
Number becomes 3
-> isEven has changed to false
Number becomes 13
Number becomes 14
-> isEven has changed to true
Number becomes 24
```

----------------------------------------

TITLE: Main Application File Integrating Modular Fusion Components (Lua)
DESCRIPTION: This example shows a main application file that leverages Fusion's `scoped` function to manage dependencies and integrate components defined in separate modules. It demonstrates how to require and use a `PopUp` component, illustrating a clean, modular approach to building UI.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/best-practices/components.md#_snippet_10

LANGUAGE: Lua
CODE:
```
local Fusion = require(game:GetService("ReplicatedStorage").Fusion)
local scoped, doCleanup = Fusion.scoped, Fusion.doCleanup

local scope = scoped(Fusion, {
	PopUp = require(script.Parent.PopUp)
})

local ui = scope:New "ScreenGui" {
    -- ...some properties...

    [Children] = scope:PopUp {
        Message = "Hello, world!",
        DismissText = "Close"
    }
}
```

----------------------------------------

TITLE: Bulk Importing Fusion Methods with `scoped(Fusion)`
DESCRIPTION: This snippet demonstrates how to use `scoped(Fusion)` to gain access to all of Fusion's functions without needing to import each one individually. It creates a scope that includes all standard Fusion methods, simplifying setup and usage.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/fundamentals/scopes.md#_snippet_9

LANGUAGE: Lua
CODE:
```
local scope = scoped(Fusion)

-- all still works!
local thing1 = scope:Value("i am thing 1")
local thing2 = scope:Value("i am thing 2")
local thing3 = scope:Value("i am thing 3")

scope:doCleanup()
```

----------------------------------------

TITLE: Dynamically Render Player List Items with Fusion's ForValues
DESCRIPTION: Demonstrates how the `PlayerList` component leverages Fusion's `ForValues` to iterate over the `Players` list, creating a `TextLabel` for each player. This mechanism ensures the UI updates automatically when players join or leave.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/examples/cookbook/player-list.md#_snippet_2

LANGUAGE: Lua
CODE:
```
			scope:ForValues(props.Players, function(use, scope, player)
				return scope:New "TextLabel" {
					Name = "PlayerListRow: " .. player.DisplayName,

					Size = UDim2.new(1, 0, 0, 25),
					BackgroundTransparency = 1,

					Text = player.DisplayName,
					TextColor3 = Color3.new(1, 1, 1),
					Font = Enum.Font.GothamMedium,
					TextSize = 16,
					TextXAlignment = "Right",
					TextTruncate = "AtEnd",

					[Children] = scope:New "UIPadding" {
						PaddingLeft = UDim.new(0, 10),
						PaddingRight = UDim.new(0, 10)
					}
				}
			end)
```

----------------------------------------

TITLE: Lua: Example Usage of scope:insert Method
DESCRIPTION: Demonstrates how to use the `insert` function as a method on a `scope` object, illustrating the insertion of a `RunService.Heartbeat` connection and a new `Instance.new("Part")` into the scope for automatic cleanup.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/api-reference/memory/members/insert.md#_snippet_1

LANGUAGE: Lua
CODE:
```
local conn, ins = scope:insert(
	RunService.Heartbeat:Connect(doUpdate),
	Instance.new("Part", workspace)
)
```

----------------------------------------

TITLE: Adding a Callback for Change Detection with onChange()
DESCRIPTION: This snippet builds upon the basic observer by adding a callback function using `:onChange()`. The callback is executed whenever the observed value changes. In this example, the message is printed only when `numCoins` is updated, demonstrating event-driven change detection.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/fundamentals/your-first-project.md#_snippet_10

LANGUAGE: Lua
CODE:
```
local scope = Fusion:scoped()

local numCoins = scope:Value(50)

local message = scope:Computed(function(use)
	return "The number of coins is " .. use(numCoins)
end)

scope:Observer(message):onChange(function()
	print(Fusion.peek(message))
end)

numCoins:set(75)

--> The number of coins is 75
```

----------------------------------------

TITLE: Define Fusion PlayerList Component Function Signature
DESCRIPTION: Illustrates the function signature for the `PlayerList` component, detailing its `scope` and `props` parameters, including the `Players` property typed as `UsedAs<{Player}>` for dynamic updates.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/examples/cookbook/player-list.md#_snippet_1

LANGUAGE: Lua
CODE:
```
local function PlayerList(
	scope: Fusion.Scope,
	props: {
		Players: UsedAs<{Player}>
	}
): Fusion.Child
```

----------------------------------------

TITLE: Type Hinting for Fusion Scope Parameter (Lua)
DESCRIPTION: This example illustrates how to apply type hinting to the `scope` parameter in Fusion. By specifying `Fusion.Scope<YourMethodsHere>`, developers can clearly define the expected methods and properties available on the scope, improving code clarity and enabling static analysis.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/best-practices/components.md#_snippet_7

LANGUAGE: Lua
CODE:
```
scope: Fusion.Scope<YourMethodsHere>
```

----------------------------------------

TITLE: MkDocs Theme Header and Navigation Templating
DESCRIPTION: This snippet illustrates how MkDocs themes use Jinja2 templating to construct the header, handle sticky navigation, include logos, display page titles, manage color palettes, and integrate search and repository links. It demonstrates conditional logic (`if`), loops (`for`), variable assignment (`set`), and partial inclusions (`include`) for dynamic content generation.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/assets/overrides/partials/header.html#_snippet_0

LANGUAGE: Jinja2
CODE:
```
{% set class = "md-header" %} {% if "navigation.tabs.sticky" in features %} {% set class = class ~ " md-header--lifted" %} {% endif %}

[{% include "partials/logo.html" %}]({{ config.extra.homepage | d\(nav.homepage.url, true\) | url }} "{{ config.site_name | e }}") {% include ".icons/octicons/list-unordered-24" ~ ".svg" %}

{% if page and page.meta and page.meta.title %} {{ page.meta.title }} {% else %} {{ page.title }} {% endif %}

{% if not config.theme.palette is mapping %}

{% for option in config.theme.palette %} {% set primary = option.primary | replace(" ", "-") | lower %} {% set accent = option.accent | replace(" ", "-") | lower %}  {% if option.toggle %} {% include ".icons/" ~ option.toggle.icon ~ ".svg" %} {% endif %} {% endfor %}

{% endif %} {% if config.extra.alternate %}

{% set icon = config.theme.icon.alternate or "octicons/globe-24" %} {% include ".icons/" ~ icon ~ ".svg" %}

{% for alt in config.extra.alternate %}*   [{{ alt.name }}]({{ alt.link | url }})
{% endfor %}

{% endif %} {% if "search" in config\["plugins"\] %} {% include ".icons/octicons/search-24.svg" %} {% include "partials/search.html" %} {% endif %} {% if config.repo\_url %}

{% include "partials/source.html" %}

{% endif %}

{% if "navigation.tabs.sticky" in features %} {% if "navigation.tabs" in features %} {% include "partials/tabs.html" %} {% endif %} {% endif %}
```

----------------------------------------

TITLE: Basic Hydration with Two-Part Call
DESCRIPTION: This Lua example illustrates the standard two-part calling convention for `scope:Hydrate`. It first takes the instance to be hydrated, then a separate call with the property table to apply a constant `Color3` value to a `Part` in `workspace`.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/roblox/hydration.md#_snippet_1

LANGUAGE: Lua
CODE:
```
local instance = workspace.Part

scope:Hydrate(instance)({
	Color = Color3.new(1, 0, 0)
})
```

----------------------------------------

TITLE: Query Current Contextual Value in Lua
DESCRIPTION: Shows how to retrieve the current value of a contextual using the `:now()` method. This example prints the default value.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/best-practices/sharing-values.md#_snippet_3

LANGUAGE: Lua
CODE:
```
local myContextual = Contextual("foo")
print(myContextual:now()) --> foo
```

----------------------------------------

TITLE: Define Theme with Contextual Value in Lua
DESCRIPTION: Example of defining a `Theme` module where the `currentTheme` is managed by a `Contextual` value, allowing for flexible theme switching without global state.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/best-practices/sharing-values.md#_snippet_5

LANGUAGE: Lua
CODE:
```
local Fusion = require("path/to/Fusion.luau")
local Contextual = Fusion.Contextual

local Theme = {}

Theme.colours = {
	background = {
		light = Color3.fromHex("FFFFFF"),
		dark = Color3.fromHex("222222")
	},
	text = {
		light = Color3.fromHex("FFFFFF"),
		dark = Color3.fromHex("222222")
	},
	-- etc.
}

Theme.currentTheme = Contextual("light")

return Theme
```

----------------------------------------

TITLE: Manage Player List State with Fusion Value and Event Listeners
DESCRIPTION: Shows how to create a Fusion `Value` object to hold the current list of players and update it using `Players.PlayerAdded` and `Players.PlayerRemoving` events. This ensures the `Value` is always synchronized with the game's player list.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/examples/cookbook/player-list.md#_snippet_3

LANGUAGE: Lua
CODE:
```
local players = scope:Value(Players:GetPlayers())
local function updatePlayers()
	players:set(Players:GetPlayers())
end
table.insert(scope, {
	Players.PlayerAdded:Connect(updatePlayers),
	Players.PlayerRemoving:Connect(updatePlayers)
})
```

----------------------------------------

TITLE: Reading Fusion Value Object with peek() in Lua
DESCRIPTION: Illustrates how to use the global `peek()` function provided by Fusion to read the current value stored in a Fusion Value object. It demonstrates the setup and a simple print operation.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/fundamentals/values.md#_snippet_2

LANGUAGE: Lua
CODE:
```
local Fusion = require(ReplicatedStorage.Fusion)
local doCleanup, scoped = Fusion.doCleanup, Fusion.scoped
local peek = Fusion.peek

local scope = scoped(Fusion)
local health = scope:Value(5)
print(peek(health)) --> 5
```

----------------------------------------

TITLE: Scoped Tween Method Syntax (Lua)
DESCRIPTION: Example of how to access the `Tween` function as a method on a scope object, which is the recommended usage.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/api-reference/animation/members/tween.md#_snippet_1

LANGUAGE: Lua
CODE:
```
local tween = scope:Tween(goal, info)
```

----------------------------------------

TITLE: Lua: Reading ForValues Output with peek()
DESCRIPTION: Shows how to retrieve the current processed values from a `ForValues` object using the `peek()` function. This example applies a simple doubling operation to each number in the input table and then displays the result.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/tables/forvalues.md#_snippet_2

LANGUAGE: Lua
CODE:
```
local numbers = {1, 2, 3, 4, 5}
local doubled = scope:ForValues(numbers, function(use, scope, num)
	return num * 2
end)

print(peek(doubled)) --> {2, 4, 6, 8, 10}
```

----------------------------------------

TITLE: Implement Dynamic Player List Component in Roblox with Fusion
DESCRIPTION: This comprehensive Lua snippet demonstrates how to build a dynamically updating player list using the Fusion framework in Roblox. It defines a reusable `PlayerList` component, handles UI layout, styling, and automatically manages player entries based on game events.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/examples/cookbook/player-list.md#_snippet_0

LANGUAGE: Lua
CODE:
```
local Players = game:GetService("Players")

local Fusion = -- initialise Fusion here however you please!
local scoped = Fusion.scoped
local Children = Fusion.Children
type UsedAs<T> = Fusion.UsedAs<T>

local function PlayerList(
	scope: Fusion.Scope,
	props: {
		Players: UsedAs<{Player}>
	}
): Fusion.Child
	return scope:New "Frame" {
		Name = "PlayerList",

		Position = UDim2.fromScale(1, 0),
		AnchorPoint = Vector2.new(1, 0),
		Size = UDim2.fromOffset(300, 0),
		AutomaticSize = "Y",

		BackgroundTransparency = 0.5,
		BackgroundColor3 = Color3.new(0, 0, 0),

		[Children] = {
			scope:New "UICorner" {
				CornerRadius = UDim.new(0, 8)
			},
			scope:New "UIListLayout" {
				SortOrder = "Name",
				FillDirection = "Vertical"
			},

			scope:ForValues(props.Players, function(use, scope, player)
				return scope:New "TextLabel" {
					Name = "PlayerListRow: " .. player.DisplayName,

					Size = UDim2.new(1, 0, 0, 25),
					BackgroundTransparency = 1,

					Text = player.DisplayName,
					TextColor3 = Color3.new(1, 1, 1),
					Font = Enum.Font.GothamMedium,
					TextSize = 16,
					TextXAlignment = "Right",
					TextTruncate = "AtEnd",

					[Children] = scope:New "UIPadding" {
						PaddingLeft = UDim.new(0, 10),
						PaddingRight = UDim.new(0, 10)
					}
				}
			end)
		}
	}
end

-- Don't forget to pass this to `doCleanup` if you disable the script.
local scope = scoped(Fusion, {
	PlayerList = PlayerList
})

local players = scope:Value(Players:GetPlayers())
local function updatePlayers()
	players:set(Players:GetPlayers())
end
table.insert(scope, {
	Players.PlayerAdded:Connect(updatePlayers),
	Players.PlayerRemoving:Connect(updatePlayers)
})

local gui = scope:New "ScreenGui" {
	Name = "PlayerListGui",
	Parent = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui"),

	[Children] = scope:PlayerList {
		Players = players
	}
}
```

----------------------------------------

TITLE: Extend Jinja2 Base Template
DESCRIPTION: This snippet illustrates how to extend a base Jinja2 template named 'main.html'. It defines a 'content' block where new content can be added, and uses 'super()' to include content from the parent template's 'content' block.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/assets/overrides/home.html#_snippet_0

LANGUAGE: Jinja2
CODE:
```
{% extends "main.html" %} {% block content %}  {{ super() }} {% endblock %}
```

----------------------------------------

TITLE: Instantiate a Spring object using scope method syntax in Lua
DESCRIPTION: This Lua example demonstrates the recommended way to create a `Spring` object by calling it as a method on a `scope` instance. This syntax simplifies the creation of spring state objects within a defined scope.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/api-reference/animation/members/spring.md#_snippet_1

LANGUAGE: Lua
CODE:
```
local spring = scope:Spring(goal, speed, damping)
```

----------------------------------------

TITLE: Concise Computed Dependency Tracking with use() in Lua
DESCRIPTION: Refines the `use()` example by showing that `use()` not only registers a dependency but also returns the value of the state object, making `peek()` redundant inside the callback. This results in more concise and readable computed definitions.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/fundamentals/computeds.md#_snippet_5

LANGUAGE: Lua
CODE:
```
local scope = scoped(Fusion)
local number = scope:Value(2)
local double = scope:Computed(function(use, _)
    return use(number) * 2
end)

print(peek(number), peek(double)) --> 2 4

number:set(10)
print(peek(number), peek(double)) --> 10 20
```

----------------------------------------

TITLE: Inspecting Fusion Value Content with Fusion.peek in Lua
DESCRIPTION: This example demonstrates using `Fusion.peek()` to retrieve the current content of a Fusion value object. `peek` is a utility function primarily for debugging, allowing direct inspection of a reactive object's state without triggering any reactive updates or side effects.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/fundamentals/your-first-project.md#_snippet_3

LANGUAGE: Lua
CODE:
```
local scope = Fusion:scoped()

local numCoins = scope:Value(50)

print(Fusion.peek(numCoins)) --> 50
```

----------------------------------------

TITLE: Using Observer's onChange Method
DESCRIPTION: Demonstrates the `:onChange()` method, which executes a provided function only when the observed state object's value changes. The example shows connecting a print statement and then triggering it by setting a new value for 'health'.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/fundamentals/observers.md#_snippet_2

LANGUAGE: Lua
CODE:
```
local observer = scope:Observer(health)

print("...connecting...")
observer:onChange(function()
	print("Observed a change to: ", peek(health))
end)

print("...setting health to 25...")
health:set(25)
```

LANGUAGE: Output
CODE:
```
...connecting...
...setting health to 25...
Observed a change to: 25
```

----------------------------------------

TITLE: Define and Use Fusion.Value State Object in Lua
DESCRIPTION: This snippet shows the function signature for constructing a new `Value` state object in Fusion Lua, along with an example demonstrating how similar scoped methods are typically invoked.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/api-reference/state/members/value.md#_snippet_0

LANGUAGE: Lua
CODE:
```
function Fusion.Value<T>(
	scope: Scope<unknown>,
	initialValue: T
) -> Value<T>
```

LANGUAGE: Lua
CODE:
```
local computed = scope:Computed(processor)
```

----------------------------------------

TITLE: Define Initial ToDo Items in Fusion
DESCRIPTION: Initializes a table of ToDo items, each with a unique ID, text description, and a reactive boolean `completed` status. This setup uses `newUniqueID()` for unique identifiers and `scope:Value()` to make the completion status observable and reactive.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/examples/cookbook/drag-and-drop.md#_snippet_18

LANGUAGE: Lua
CODE:
```
local todoItems: {TodoItem} = {
	{
		id = newUniqueID(),
		text = "Wake up today",
		completed = scope:Value(true)
	},
	{
		id = newUniqueID(),
		text = "Read the Fusion docs",
		completed = scope:Value(true)
	},
	{
		id = newUniqueID(),	
		text = "Take over the universe",
		completed = scope:Value(false)
	}
}
```

----------------------------------------

TITLE: Calling OnChange to Get a Property Key in Lua
DESCRIPTION: Shows how calling `OnChange` with a property name, such as 'Text', returns a special key that can be used in property tables to define event handlers.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/roblox/change-events.md#_snippet_2

LANGUAGE: Lua
CODE:
```
local key = OnChange("Text")
```

----------------------------------------

TITLE: Conditionally Transform Pairs Using State Objects
DESCRIPTION: This example demonstrates using a state object (`shouldSwap`) within the `ForPairs` processor function to conditionally alter the key-value transformation. It highlights how `ForPairs` can react to external state changes to modify its behavior.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/tables/forpairs.md#_snippet_4

LANGUAGE: Lua
CODE:
```
local itemColours = { shoes = "red", socks = "blue" }

local shouldSwap = scope:Value(false)
local swapped = scope:ForPairs(data, function(use, scope, item, colour)
	if use(shouldSwap) then
		return colour, item
	else
		return item, colour
	end
end)

print(peek(swapped)) --> { shoes = "red", socks = "blue" }

shouldSwap:set(true)
print(peek(swapped)) --> { red = "shoes", blue = "socks" }
```

----------------------------------------

TITLE: Share and Initialize Global State Objects with Fusion in Lua
DESCRIPTION: This example illustrates how to share a global state object, like a theme's current state, using the Fusion library in Lua. It includes an initialization function to manage the state within a scope and demonstrates how to update and observe the state, highlighting how stateful globals can be managed.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/best-practices/sharing-values.md#_snippet_1

LANGUAGE: Lua
CODE:
```
local Fusion = require("path/to/Fusion.luau")

local Theme = {}

Theme.colours = {
	background = {
		light = Color3.fromHex("FFFFFF"),
		dark = Color3.fromHex("222222")
	},
	text = {
		light = Color3.fromHex("FFFFFF"),
		dark = Color3.fromHex("222222")
	},
	-- etc.
}

function Theme.init(
	scope: Fusion.Scope
)
	Theme.currentTheme = scope:Value("light")
end

return Theme
```

LANGUAGE: Lua
CODE:
```
local Fusion = require("path/to/Fusion.luau")
local scoped, peek = Fusion.scoped, Fusion.peek

local Theme = require("path/to/Theme.luau")

local function printTheme()
	local theme = Theme.currentTheme
	print(
		peek(theme),
		if typeof(theme) == "string" then "constant" else "state object"
	)
end

local scope = scoped(Fusion)
Theme.init(scope)
printTheme() --> light state object

Theme.currentTheme:set("dark")
printTheme() --> dark state object
```

----------------------------------------

TITLE: Assigning Hydrated Instance to a Variable
DESCRIPTION: This Lua example demonstrates that the `scope:Hydrate` function returns the instance it was given, allowing for direct assignment to a variable during declaration. This enables chaining or immediate use of the hydrated instance.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/roblox/hydration.md#_snippet_3

LANGUAGE: Lua
CODE:
```
local instance = scope:Hydrate(workspace.Part) {
	Color = Color3.new(1, 0, 0)
}
```

----------------------------------------

TITLE: Deriving Scopes with `deriveScope()`
DESCRIPTION: This example demonstrates the `deriveScope` function, which allows you to create a new scope that inherits all methods from an existing scope without redefining them. This is a highly efficient way to reuse method definitions, ensuring consistency and reducing boilerplate code.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/fundamentals/scopes.md#_snippet_12

LANGUAGE: Lua
CODE:
```
local foo = scoped({
	Foo = Foo,
	Bar = Bar,
	Baz = Baz
})

-- `bar` should have the same methods as `foo`
-- now, it's only defined once!
local bar = foo:deriveScope()

print(foo.Baz == bar.Baz) --> true

bar:doCleanup()
foo:doCleanup()
```

----------------------------------------

TITLE: Calling OnEvent to Get Event Key in Fusion
DESCRIPTION: Illustrates how to call `OnEvent` with an event name (e.g., 'Activated') to obtain a special key that can then be used in property tables for event binding.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/roblox/events.md#_snippet_2

LANGUAGE: Lua
CODE:
```
local key = OnEvent("Activated")
```

----------------------------------------

TITLE: Using set() Method's Return Value in Calculations in Lua
DESCRIPTION: Explains that the `:set()` method returns the value it was given, allowing it to be used directly within expressions. This example shows how to incorporate `:set()` into a calculation and then verify the updated value.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/fundamentals/values.md#_snippet_4

LANGUAGE: Lua
CODE:
```
local myNumber = scope:Value(0)
local computation = 10 + myNumber:set(2 + 2)
print(computation) --> 14
print(peek(myNumber)) --> 4
```

----------------------------------------

TITLE: Linking Fusion Objects with 'use' in Computed Properties Lua
DESCRIPTION: This example demonstrates how to use the `use` function within a computed property's callback to retrieve the value of another Fusion object (`numCoins`). This establishes a reactive link, ensuring the computed property automatically updates its output whenever `numCoins` changes.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/fundamentals/your-first-project.md#_snippet_7

LANGUAGE: Lua
CODE:
```
local scope = Fusion:scoped()

local numCoins = scope:Value(50)

local message = scope:Computed(function(use)
	return "The number of coins is " .. use(numCoins)
end)

print(Fusion.peek(message)) --> The number of coins is 50
```

----------------------------------------

TITLE: Preventing Fatal Errors with `pcall()` in Luau
DESCRIPTION: This Luau example demonstrates how to gracefully handle potential errors using `pcall()`. By wrapping an `error()` call within `pcall()`, the program can catch the error and continue execution, preventing a fatal crash and allowing subsequent code to run.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/best-practices/error-safety.md#_snippet_1

LANGUAGE: Luau
CODE:
```
print("before")
print("before")
print("before")

pcall(function()
	error("Kaboom!")
end)

print("after")
print("after")
print("after")
```

----------------------------------------

TITLE: Define and Use Global Theme Colors in Lua
DESCRIPTION: This example demonstrates how to define global theme colors in a Lua module and then access them from another part of the codebase. It shows a basic module structure for sharing static values, useful for consistent styling across UI elements.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/best-practices/sharing-values.md#_snippet_0

LANGUAGE: Lua
CODE:
```
local Theme = {}

Theme.colours = {
	background = Color3.fromHex("FFFFFF"),
	text = Color3.fromHex("222222"),
	-- etc.
}

return Theme
```

LANGUAGE: Lua
CODE:
```
local Theme = require("path/to/Theme.luau")

local textColour = Theme.colours.text
print(textColour) --> 34, 34, 34
```

----------------------------------------

TITLE: springTypeMismatch Error: Spring Type Mismatch
DESCRIPTION: This error is thrown by the `Spring` function when the input data type provided does not match the data type the spring is currently configured to output. For example, providing a `Vector3` when the spring expects a `Color3`.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/api-reference/general/errors.md#_snippet_26

LANGUAGE: Plaintext
CODE:
```
The type 'Vector3' doesn't match the spring's type 'Color3'.
```

----------------------------------------

TITLE: Create Folder with Multiple Children using Fusion's Children Key
DESCRIPTION: Demonstrates how to use the `[Children]` key to create a new 'Folder' instance and populate it with multiple 'Part' instances directly during its creation, showcasing basic child parenting within Fusion.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/roblox/parenting.md#_snippet_0

LANGUAGE: Lua
CODE:
```
local folder = scope:New "Folder" {
    [Children] = {
        scope:New "Part" {
            Name = "Gregory",
            Color = Color3.new(1, 0, 0)
        },
        scope:New "Part" {
            Name = "Sammy",
            Material = "Glass"
        }
    }
}
```

----------------------------------------

TITLE: Set Up Main ScreenGui (Lua)
DESCRIPTION: Creates the primary `ScreenGui` named "DragAndDropGui" and parents it to the local player's `PlayerGui`. It then adds the `overlayFrame` and the `taskLists` (which contain the scrolling frames for incomplete/completed tasks) as children, assembling the main UI structure.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/examples/cookbook/drag-and-drop.md#_snippet_8

LANGUAGE: Lua
CODE:
```
local ui = scope:New "ScreenGui" {
	Name = "DragAndDropGui",
	Parent = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui"),

	[Children] = {
		overlayFrame,
		taskLists,
		-- Don't pass `allEntries` in here - they manage their own parent!
	}
}
```

----------------------------------------

TITLE: Instantiate Button Component using `scoped()` Syntax in Fusion (Lua)
DESCRIPTION: This Lua example shows how to use Fusion's `scoped()` syntax to call the `Button` component. It registers the `Button` function within a scope, allowing it to be called as a method on the scope object, simplifying component instantiation.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/best-practices/components.md#_snippet_2

LANGUAGE: Lua
CODE:
```
local scope = scoped(Fusion, {
	Button = Button
})

local helloBtn = scope:Button {
    ButtonText = "Hello",
    Size = UDim2.fromOffset(200, 50)
}

helloBtn.Parent = Players.LocalPlayer.PlayerGui.ScreenGui
```

----------------------------------------

TITLE: Cleaning Up Fusion Resources with scope:doCleanup()
DESCRIPTION: This snippet demonstrates how to properly clean up all resources associated with a Fusion scope using the `scope:doCleanup()` method. This is crucial for preventing memory leaks and ensuring that reactive objects and observers are properly dismantled when they are no longer needed. The example shows `doCleanup()` being called after the reactive operations are complete.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/fundamentals/your-first-project.md#_snippet_12

LANGUAGE: Lua
CODE:
```
local scope = Fusion:scoped()

local numCoins = scope:Value(50)

local message = scope:Computed(function(use)
	return "The number of coins is " .. use(numCoins)
end)

scope:Observer(message):onBind(function()
	print(Fusion.peek(message))
end)

--> The number of coins is 50

numCoins:set(75)

--> The number of coins is 75

scope:doCleanup()
```

----------------------------------------

TITLE: Create a ForPairs Object with Input Table and Processor
DESCRIPTION: This snippet illustrates the basic constructor for `ForPairs`, taking an input table and a processor function. The processor function receives `use`, `scope`, and a key-value pair, allowing for transformation of the input data.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/tables/forpairs.md#_snippet_1

LANGUAGE: Lua
CODE:
```
local itemColours = { shoes = "red", socks = "blue" }
local swapped = scope:ForPairs(data, function(use, scope, item, colour)
	return colour, item
end)
```

----------------------------------------

TITLE: Create a Basic Spring Object in Lua
DESCRIPTION: Demonstrates how to initialize a new spring object by calling `scope:Spring()` and passing it a state object (`goal`) that the spring will follow. The spring will smoothly animate towards the goal's value.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/animation/springs.md#_snippet_0

LANGUAGE: Lua
CODE:
```
local goal = scope:Value(0)
local animated = scope:Spring(goal)
```

----------------------------------------

TITLE: Retrieve Computed Value with peek() in Lua
DESCRIPTION: Shows how to access the current value of a `Computed` object using the `peek()` function. This example builds upon the simple computed creation, demonstrating how to read its calculated result.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/fundamentals/computeds.md#_snippet_2

LANGUAGE: Lua
CODE:
```
local scope = scoped(Fusion)
local hardMaths = scope:Computed(function(_, _)
    return 1 + 1
end)

print(peek(hardMaths)) --> 2
```

----------------------------------------

TITLE: cannotAssignProperty
DESCRIPTION: Thrown by: New, Hydrate. You tried to set a property on an instance, but the property can't be assigned to for some reason. This could be because the property doesn't exist, or because it's locked by Roblox to prevent edits. Different scripts may have different privileges - for example, plugins will be allowed more privileges than in-game scripts. Make sure you have the necessary privileges to assign to your properties!

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/api-reference/general/errors.md#_snippet_1

LANGUAGE: APIDOC
CODE:
```
The class type 'Foo' has no assignable property 'Bar'.
```

----------------------------------------

TITLE: Create Basic Roblox Instance with Fusion
DESCRIPTION: Demonstrates creating a new Roblox instance (a red Part) using Fusion's `scope:New` function. This allows for easy configuration of instance properties like parent and color directly upon creation.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/index.md#_snippet_3

LANGUAGE: Lua
CODE:
```
-- This will create a red part in the workspace.
local myPart = scope:New "Part" {
	Parent = workspace,
	BrickColor = BrickColor.Red()
}
```

----------------------------------------

TITLE: Using Safe for Conditional UI Rendering in Lua
DESCRIPTION: Shows an example of using `Safe` expressions within Fusion to conditionally render UI components. This allows for displaying an error page or alternative content gracefully if a primary UI element fails to load or encounters an error during its computation.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/best-practices/error-safety.md#_snippet_7

LANGUAGE: Lua
CODE:
```
[Children] = Safe {
	try = function()
		return scope:FormattedForumPost {
			-- ... properties ...
		}
	end,
	fallback = function(err)
		return scope:ErrorPage {
			title = "An error occurred while showing this forum post",
			errorMessage = tostring(err)
		}
	end
}
```

----------------------------------------

TITLE: Concise Instance Creation with Fusion's New Function (Optional Parentheses)
DESCRIPTION: Demonstrates a more concise syntax for `scope:New` where the outer parentheses around the property table can be omitted. This syntactic sugar is valid when the instance type is a quoted string and the properties are provided in curly braces, making the code cleaner.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/roblox/new-instances.md#_snippet_2

LANGUAGE: Lua
CODE:
```
-- This only works when you're using curly braces {} and quotes '' ""!
local instance = scope:New "Part" {
	Parent = workspace,
	Color = Color3.new(1, 0, 0)
}
```

----------------------------------------

TITLE: Hydrating UI with Fusion Objects
DESCRIPTION: This Lua example demonstrates how to use `scope:Hydrate` to connect a UI template to a Fusion `Value` object. It shows how changes to the `Value` (e.g., `showUI:set(true)`) dynamically update the UI element's properties (e.g., `Enabled`). It also highlights that updates occur on the next frame.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/roblox/hydration.md#_snippet_0

LANGUAGE: Lua
CODE:
```
local showUI = scope:Value(false)

local ui = scope:Hydrate(StarterGui.Template:Clone()) {
	Name = "MainGui",
	Enabled = showUI
}

print(ui.Name) --> MainGui
print(ui.Enabled) --> false

showUI:set(true)
task.wait() -- important: changes are applied on the next frame!
print(ui.Enabled) --> true
```

----------------------------------------

TITLE: Process Animated State with Computed (Lua)
DESCRIPTION: Illustrates how Fusion's `Computed` state object can be used to derive new values from existing animated states. Examples include rounding animated health to whole numbers and formatting it as text for UI display, showcasing reactive data transformation and integration with UI elements.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/index.md#_snippet_8

LANGUAGE: Lua
CODE:
```
-- You can round the animated health to whole numbers.
local wholeHealth = scope:Computed(function(use)
	return math.round(use(health))
end)

-- You can format it as text and put it in some UI, too.
local myText = scope:New "TextLabel" {
	Text = scope:Computed(function(use)
		return "Health: " .. use(wholeHealth)
	end)
}
```

----------------------------------------

TITLE: Mixing Custom Methods with Fusion using `scoped()`
DESCRIPTION: This example shows how to combine Fusion's built-in methods with custom methods from other tables when creating a scope. You can pass multiple tables to `scoped()` to consolidate various functionalities into a single scope. Be aware that `scoped()` will error if conflicting names are present across the provided tables.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/fundamentals/scopes.md#_snippet_10

LANGUAGE: Lua
CODE:
```
local scope = scoped(Fusion, {
	Foo = ...,
	Bar = ...
})
```

----------------------------------------

TITLE: Implementing Explicit Error Handling in Fusion `Computed` with `pcall` (Luau)
DESCRIPTION: This Luau example demonstrates best practices for error handling within a Fusion `scope:Computed` object. By explicitly wrapping the potentially failing logic with `pcall()`, the code can catch errors and return a meaningful message, ensuring predictable behavior and preventing 'red text' errors in the output.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/best-practices/error-safety.md#_snippet_4

LANGUAGE: Luau
CODE:
```
local number = scope:Value(1)
local double = scope:Computed(function(use)
	local number = use(number)
	local ok, result = pcall(function()
		assert(number ~= 3, "I don't like the number 3")
		return number * 2
	end)
	if ok then
		return result
	else
		return "failed: " .. err
	end
end)
```

----------------------------------------

TITLE: Nest Fusion New Calls for Child Creation
DESCRIPTION: Demonstrates how `scope:New` calls can be nested within the `[Children]` key to create and parent a new instance (e.g., a 'Part') directly inside another new instance (e.g., a 'Folder') in a single, concise operation.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/roblox/parenting.md#_snippet_3

LANGUAGE: Lua
CODE:
```
local folder = scope:New "Folder" {
    [Children] = scope:New "Part" {
        Name = "Gregory",
        Color = Color3.new(1, 0, 0)
    }
}
```

----------------------------------------

TITLE: Executing a Callback Immediately and on Change with onBind()
DESCRIPTION: This snippet introduces the `:onBind()` method for observers. Unlike `:onChange()`, `:onBind()` executes the provided callback immediately upon binding the observer and then again whenever the observed value changes. This is useful for initializing UI elements or performing actions that need to run both initially and on subsequent updates.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/fundamentals/your-first-project.md#_snippet_11

LANGUAGE: Lua
CODE:
```
local scope = Fusion:scoped()

local numCoins = scope:Value(50)

local message = scope:Computed(function(use)
	return "The number of coins is " .. use(numCoins)
end)

scope:Observer(message):onBind(function()
	print(Fusion.peek(message))
end)

--> The number of coins is 50

numCoins:set(75)

--> The number of coins is 75
```

----------------------------------------

TITLE: Correct Computed Dependency Tracking with use() and peek() in Lua
DESCRIPTION: Corrects the previous example by demonstrating the proper use of the `use()` function within a `Computed` callback. Calling `use(number)` registers `number` as a dependency, ensuring the `double` computed value recalculates when `number` changes. Note that `peek(number)` is still used for the actual value retrieval.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/fundamentals/computeds.md#_snippet_4

LANGUAGE: Lua
CODE:
```
local scope = scoped(Fusion)
local number = scope:Value(2)
local double = scope:Computed(function(use, _)
	use(number) -- the calculation will re-run when `number` changes value
    return peek(number) * 2
end)

print(peek(number), peek(double)) --> 2 4

-- Now it re-runs!
number:set(10)
print(peek(number), peek(double)) --> 10 20
```

----------------------------------------

TITLE: Demonstrating Table Mutation and Update Skipping Logic
DESCRIPTION: This example illustrates a common pattern of mutating Luau arrays (tables) in place. It explains why Fusion, by default, does not skip updates for tables based solely on `==` comparison, as mutation can change content without changing the table reference, which would prevent observers from firing if skipping occurred.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/best-practices/optimisation.md#_snippet_2

LANGUAGE: Luau
CODE:
```
local drinks = scope:Value({"beer", "pepsi"})

do -- add tea
	local array = peek(drinks)
	table.insert(array, "tea") -- mutation occurs here
	drinks:set(array) -- still the same array, so it's ==
end
```

----------------------------------------

TITLE: Handle Mouse Down to Initiate ToDo Item Drag
DESCRIPTION: Implements the `OnMouseDown` callback to begin dragging a ToDo item. It checks if no other item is currently being dragged. If free, it calculates the mouse's offset relative to the item's position and updates the `currentlyDragging` state with the item's ID and this offset, signaling that the drag operation has started.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/examples/cookbook/drag-and-drop.md#_snippet_24

LANGUAGE: Lua
CODE:
```
			OnMouseDown = function()
				if peek(currentlyDragging) == nil then
					local itemPos = peek(itemPosition) or Vector2.zero
					local mouseOffset = peek(mousePos) - itemPos
					currentlyDragging:set({
						id = item.id,
						mouseOffset = mouseOffset
					})
				end
			end

```

----------------------------------------

TITLE: Hydration with Optional Parentheses for Curly Braces
DESCRIPTION: This Lua example shows a syntactic sugar for `scope:Hydrate` when using curly braces for the property table. The outer parentheses around the property table can be omitted, making the syntax more concise. This only applies when the property table is defined directly with curly braces.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/roblox/hydration.md#_snippet_2

LANGUAGE: Lua
CODE:
```
local instance = workspace.Part

-- This only works when you're using curly braces {}!
scope:Hydrate(instance) {
	Color = Color3.new(1, 0, 0)
}
```

----------------------------------------

TITLE: Parent Single Instance using Fusion Children Key
DESCRIPTION: Illustrates how to parent an existing single instance (e.g., `workspace.Part`) inside a newly created 'Folder' using the `[Children]` key during the `scope:New` operation. The existing part will be moved inside the new folder.

SOURCE: https://github.com/dphfox/fusion/blob/main/docs/tutorials/roblox/parenting.md#_snippet_2

LANGUAGE: Lua
CODE:
```
local folder = scope:New "Folder" {
    -- The part will be moved inside of the folder
    [Children] = workspace.Part
}
```