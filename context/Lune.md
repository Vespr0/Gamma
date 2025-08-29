========================
CODE SNIPPETS
========================
TITLE: Install Lune using Aftman
DESCRIPTION: Installs Lune by adding it to the Aftman configuration file. This is the recommended installation method.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 1 Installation.md#_snippet_0

LANGUAGE: sh
CODE:
```
aftman add filiptibell/lune
```

----------------------------------------

TITLE: Lune Stdio for Formatted Output
DESCRIPTION: Shows how to use the stdio library in Lune for printing colored text, repeating characters, and creating visual separators.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 2 Writing Scripts.md#_snippet_11

LANGUAGE: lune
CODE:
```
print("Printing with pretty colors and auto-formatting 🎨")
print(stdio.color("blue") .. string.rep("—", 22) .. stdio.color("reset"))
print(stdio.color("blue") .. string.rep("—", 22) .. stdio.color("reset"))
print("Goodbye, lune! 🌙")

```

----------------------------------------

TITLE: Build and Install Lune from Source
DESCRIPTION: Builds and installs Lune using Cargo, the Rust package manager. Requires Rust and Cargo to be installed. Note: Lune does not guarantee a Minimum Supported Rust Version (MSRV).

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 1 Installation.md#_snippet_1

LANGUAGE: rust
CODE:
```
cargo install lune --locked
```

----------------------------------------

TITLE: Create and Export a Module
DESCRIPTION: Demonstrates how to create a simple Lua module in Lune. It defines a table with a function `sayHello` and returns it, making it available for import by other scripts.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 2 Writing Scripts.md#_snippet_3

LANGUAGE: lua
CODE:
```
--[[ 
	EXAMPLE #4

	Writing a module

	Modularizing and splitting up your code is Lune is very straight-forward,
	in contrast to other scripting languages and shells such as bash
]]

local module = {}

function module.sayHello()
	print("Hello, Lune! 🌙")
end

return module
```

----------------------------------------

TITLE: Prompt User for Input
DESCRIPTION: Illustrates using the stdio library to interact with the user via the terminal. It shows how to prompt for text input and confirmation, handling user responses and potential errors.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 2 Writing Scripts.md#_snippet_1

LANGUAGE: lua
CODE:
```
--[[ 
	EXAMPLE #2

	Using the stdio library to prompt for terminal input
]]

local text = stdio.prompt("text", "Please write some text")

print("You wrote '" .. text .. "'!")

local confirmed = stdio.prompt("confirm", "Please confirm that you wrote some text")
if confirmed == false then
	error("You didn't confirm!")
else
	print("Confirmed!")
end
```

----------------------------------------

TITLE: Lune Assertions and Logging
DESCRIPTION: Demonstrates how to use assert statements for validation and the info/warn functions for logging API responses and nested data structures in Lune.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 2 Writing Scripts.md#_snippet_10

LANGUAGE: lune
CODE:
```
assert(apiResponse.title == "foo", "Invalid json response")
assert(apiResponse.body == "bar", "Invalid json response")
print("Got valid JSON response with changes applied")

info("API response:", apiResponse)
warn({
	Oh = {
		No = {
			TooMuch = {
				Nesting = {
					"Will not print",
				},
			},
		},
	},
})

```

----------------------------------------

TITLE: Manage Environment Variables
DESCRIPTION: Shows how to read and check environment variables in Lune. It asserts the existence of essential variables like PATH and PWD, and iterates through all environment variables, indicating if they have a value.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 2 Writing Scripts.md#_snippet_2

LANGUAGE: lua
CODE:
```
--[[ 
	EXAMPLE #3

	Get & set environment variables

	Checks if environment variables are empty or not,
	prints out ❌ if empty and ✅ if they have a value
]]

print("Reading current environment 🔎")

-- Environment variables can be read directly
assert(process.env.PATH ~= nil, "Missing PATH")
assert(process.env.PWD ~= nil, "Missing PWD")

-- And they can also be accessed using Luau's generalized iteration (but not pairs())
for key, value in process.env do
	local box = if value and value ~= "" then "✅" else "❌"
	print(string.format("[%s] %s", box, key))
end
```

----------------------------------------

TITLE: Lune/Luau Loop Translation
DESCRIPTION: Translates the Bash while loop example into Lune/Luau syntax, demonstrating variable declaration, loop control, and printing.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 2 Writing Scripts.md#_snippet_13

LANGUAGE: lua
CODE:
```
local valid = true
local count = 1
while valid do
	print(count)
	if count == 5 then
		break
	end
	count += 1
end

```

----------------------------------------

TITLE: Bash Loop Example
DESCRIPTION: A standard Bash script demonstrating a while loop with a counter and a break condition.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 2 Writing Scripts.md#_snippet_12

LANGUAGE: bash
CODE:
```
#!/bin/bash
VALID=true
COUNT=1
while [ $VALID ]
do
	echo $COUNT
	if [ $COUNT -eq 5 ];
	then
		break
	fi
	((COUNT++))
done

```

----------------------------------------

TITLE: Spawn Concurrent Tasks
DESCRIPTION: Illustrates how to create and manage concurrent tasks in Lune using `task.spawn` and `task.delay`. This allows for non-blocking operations and basic multitasking, including waiting for a specified duration.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 2 Writing Scripts.md#_snippet_5

LANGUAGE: lua
CODE:
```
--[[ 
	EXAMPLE #6

	Spawning concurrent tasks

	These tasks will run at the same time as other Lua code which lets you do primitive multitasking
]]

task.spawn(function()
	print("Spawned a task that will run instantly but not block")
	task.wait(5)
end)

print("Spawning a delayed task that will run in 5 seconds")
task.delay(5, function()
	print("...")
	task.wait(1)
	print("Hello again!")
	task.wait(1)
	print("Goodbye again! 🌙")
end)
```

----------------------------------------

TITLE: Handle Program Arguments
DESCRIPTION: Demonstrates how to access and process command-line arguments passed to a Lune program. It checks the number of arguments and prints them, with an error condition for too many arguments.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 2 Writing Scripts.md#_snippet_0

LANGUAGE: lua
CODE:
```
--[[
	EXAMPLE #1

	Using arguments given to the program
]]

if #process.args > 0 then
	print("Got arguments:")
	print(process.args)
	if #process.args > 3 then
		error("Too many arguments!")
	end
else
	print("Got no arguments ☹️")
end
```

----------------------------------------

TITLE: Process Spawned Program Output and Exit
DESCRIPTION: Demonstrates how to handle the output and exit code of a spawned process. It parses the standard output using string matching to extract ping statistics and uses `process.exit` to terminate the script with an appropriate status code.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 2 Writing Scripts.md#_snippet_8

LANGUAGE: lua
CODE:
```
--[[ 
	EXAMPLE #9

	Using the result of a spawned process, exiting the process

	This looks scary with lots of weird symbols, but, it's just some Lua-style pattern matching
	to parse the lines of "min/avg/max/stddev = W/X/Y/Z ms" that the ping program outputs to us
]]

if result.ok then
	assert(#result.stdout > 0, "Result output was empty")
	local min, avg, max, stddev = string.match(
		result.stdout,
		"min/avg/max/stddev = ([%d%.]+)/([%d%.]+)/([%d%.]+)/([%d%.]+) ms"
	)
	print(string.format("Minimum ping time: %.3fms", assert(tonumber(min))))
	print(string.format("Maximum ping time: %.3fms", assert(tonumber(max))))
	print(string.format("Average ping time: %.3fms", assert(tonumber(avg))))
	print(string.format("Standard deviation: %.3fms", assert(tonumber(stddev))))
else
	print("Failed to send ping to google!")
	print(result.stderr)
	process.exit(result.code)
end
```

----------------------------------------

TITLE: Read Directory Entries
DESCRIPTION: Demonstrates how to read the contents of a directory using the `fs` module in Lune. It retrieves directory entries, checks if they are directories, sorts them prioritizing directories, and prints them with appropriate icons.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 2 Writing Scripts.md#_snippet_6

LANGUAGE: lua
CODE:
```
--[[ 
	EXAMPLE #7

	Read files in the current directory

	This prints out directory & file names with some fancy icons
]]

print("Reading current dir 🗂️")
local entries = fs.readDir(".")

-- NOTE: We have to do this outside of the sort function
-- to avoid yielding across the metamethod boundary, all
-- of the filesystem APIs are asynchronous and yielding
local entryIsDir = {}
for _, entry in entries do
	entryIsDir[entry] = fs.isDir(entry)
end

-- Sort prioritizing directories first, then alphabetically
table.sort(entries, function(entry0, entry1) 
	if entryIsDir[entry0] ~= entryIsDir[entry1] then
		return entryIsDir[entry0]
	end
	return entry0 < entry1
end)

-- Make sure we got some known files that should always exist
assert(table.find(entries, "Cargo.toml") ~= nil, "Missing Cargo.toml")
assert(table.find(entries, "Cargo.lock") ~= nil, "Missing Cargo.lock")

-- Print the pretty stuff
for _, entry in entries do
	if fs.isDir(entry) then
		print("📁 " .. entry)
	else
		print("📄 " .. entry)
	end
end
```

----------------------------------------

TITLE: Spawn External Program
DESCRIPTION: Shows how to execute an external program (like `ping`) from within a Lune script using `process.spawn`. It passes arguments to the program and captures its output and exit status.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 2 Writing Scripts.md#_snippet_7

LANGUAGE: lua
CODE:
```
--[[ 
	EXAMPLE #8

	Call out to another program / executable

	You can also get creative and combine this with example #6 to spawn several programs at the same time!
]]

print("Sending 4 pings to google 🌏")
local result = process.spawn("ping", {
	"google.com",
	"-c 4",
})
```

----------------------------------------

TITLE: Generate Lune Luau Types and Docs
DESCRIPTION: Commands to generate necessary type definition and documentation files for Luau LSP integration with Lune.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 4 Editor Setup.md#_snippet_2

LANGUAGE: bash
CODE:
```
lune --generate-luau-types
lune --generate-docs-file
```

----------------------------------------

TITLE: List Available Lune Scripts
DESCRIPTION: Lists all scripts found in `lune` or `.lune` directories. It also includes top-level description comments starting with `-->`.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 3 Running Scripts.md#_snippet_2

LANGUAGE: sh
CODE:
```
lune --list
```

----------------------------------------

TITLE: Import and Use a Module
DESCRIPTION: Shows how to import and use functions from another module using path-relative imports in Lune, similar to JavaScript. It requires a local module and calls its exported function.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 2 Writing Scripts.md#_snippet_4

LANGUAGE: lua
CODE:
```
--[[ 
	EXAMPLE #5

	Using a function from another module / script

	Lune has path-relative imports, similar to other popular languages such as JavaScript
]]

local module = require("../modules/module")
module.sayHello()
```

----------------------------------------

TITLE: Generate Lune Selene Types
DESCRIPTION: Command to generate type definition files for Selene integration with Lune.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 4 Editor Setup.md#_snippet_3

LANGUAGE: bash
CODE:
```
lune --generate-selene-types
```

----------------------------------------

TITLE: Network Request with JSON Handling
DESCRIPTION: Shows how to make an HTTP PATCH request to a web API using Lune's `net` library. It includes encoding a Lua table to JSON for the request body and decoding the JSON response, with error handling for network failures.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 2 Writing Scripts.md#_snippet_9

LANGUAGE: lua
CODE:
```
--[[ 
	EXAMPLE #10

	Using the built-in networking library, encoding & decoding json
]]

print("Sending PATCH request to web API 📤")
local apiResult = net.request({
	url = "https://jsonplaceholder.typicode.com/posts/1",
	method = "PATCH",
	headers = {
		["Content-Type"] = "application/json",
	},
	body = net.jsonEncode({
		title = "foo",
		body = "bar",
	}),
})

if not apiResult.ok then
	print("Failed to send network request!")
	print(string.format("%d (%s)", apiResult.statusCode, apiResult.statusMessage))
	print(apiResult.body)
	process.exit(1)
end

type ApiResponse = {
	id: number,
	title: string,
	body: string,
	userId: number,
}

local apiResponse: ApiResponse = net.jsonDecode(apiResult.body)
```

----------------------------------------

TITLE: Configure Luau LSP for Lune
DESCRIPTION: Sets up the Luau Language Server in VSCode to work with Lune projects. This involves specifying the require mode and adding Lune's type definition and documentation files.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 4 Editor Setup.md#_snippet_0

LANGUAGE: json
CODE:
```
{
	"luau-lsp.require.mode": "relativeToFile",
	"luau-lsp.types.definitionFiles": ["luneTypes.d.luau"],
	"luau-lsp.types.documentationFiles": ["luneDocs.json"]
}
```

----------------------------------------

TITLE: Run a Lune Script
DESCRIPTION: Executes a Lune script file. The system searches for the script in the current directory, and in `.lune` or `lune` subdirectories. Supports `.luau` (recommended) and `.lua` extensions.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 3 Running Scripts.md#_snippet_0

LANGUAGE: sh
CODE:
```
lune script-name
```

----------------------------------------

TITLE: Interacting with the Lune REPL in Bash
DESCRIPTION: This example shows how to start and interact with the Lune Read-Eval-Print Loop (REPL) from a Bash terminal. It demonstrates running basic Lua commands, defining and using global variables, and the key combinations to exit the REPL.

SOURCE: https://github.com/lune-org/lune/blob/main/CHANGELOG.md#_snippet_14

LANGUAGE: Bash
CODE:
```
# 1. Run the Lune executable, without any arguments
lune

# 2. You will be shown the current Lune version and a blank prompt arrow:
Lune v0.7.7
>

# 3. Start typing, and hit enter when you want to run your script!
#    Your script will run until completion and output things along the way.
> print(2 + 3)
5
> print("Hello, lune changelog!")
Hello, lune changelog!

# 4. You can also set variables that will get preserved between runs.
#    Note that local variables do not get preserved here.
> myVariable = 123
> print(myVariable)
123

# 5. Press either of these key combinations to exit the REPL:
#    - Ctrl + D
#    - Ctrl + C
```

----------------------------------------

TITLE: Prompting User Input - stdio.prompt - Lua
DESCRIPTION: This example showcases the various ways to use the `stdio.prompt` function to get input from the user. It demonstrates prompting for basic text, text with a custom message, a boolean confirmation, a single selection from a list, and multiple selections from a list.

SOURCE: https://github.com/lune-org/lune/blob/main/CHANGELOG.md#_snippet_25

LANGUAGE: lua
CODE:
```
local text = stdio.prompt()

local text2 = stdio.prompt("text", "Please write some text")

local didConfirm = stdio.prompt("confirm", "Please confirm this action")

local optionIndex = stdio.prompt("select", "Please select an option", { "one", "two", "three" })

local optionIndices = stdio.prompt(
    "multiselect",
    "Please select one or more options",
    { "one", "two", "three", "four", "five" }
)
```

----------------------------------------

TITLE: Compressing and Decompressing Strings with Serde (Lua)
DESCRIPTION: Demonstrates how to use the `serde.compress` and `serde.decompress` functions to compress and decompress a string using the gzip format. It requires the `@lune/serde` library. The example asserts that the decompressed string matches the original input.

SOURCE: https://github.com/lune-org/lune/blob/main/CHANGELOG.md#_snippet_19

LANGUAGE: lua
CODE:
```
local INPUT = string.rep("Input string to compress", 16) -- Repeated string 16 times for the purposes of this example

local serde = require("@lune/serde")

local compressed = serde.compress("gzip", INPUT)
local decompressed = serde.decompress("gzip", compressed)

assert(decompressed == INPUT)
```

----------------------------------------

TITLE: Configure Selene for Lune
DESCRIPTION: Configures the Selene linter for Lune projects. This involves setting the standard library path and optionally excluding Lune's type definition file to prevent conflicts.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 4 Editor Setup.md#_snippet_1

LANGUAGE: yaml
CODE:
```
# Use this if Lune is the only thing you use Luau files with:
std = "luau+lune"
# OR use this if your project also contains Roblox-specific Luau code:
std = "roblox+lune"
# If you are also using the Luau type definitions file, it may cause issues, and can be safely ignored:
exclude = ["luneTypes.d.luau"]
```

----------------------------------------

TITLE: Connecting to Web Socket Server - net.socket - Lua
DESCRIPTION: This example illustrates how to establish a client-side WebSocket connection using `net.socket`. It shows how to connect to a specified WebSocket URL, send data to the server, schedule the socket to close after a delay, and process incoming messages from the server using `socket.next()`.

SOURCE: https://github.com/lune-org/lune/blob/main/CHANGELOG.md#_snippet_23

LANGUAGE: lua
CODE:
```
local socket = net.socket("ws://localhost:8080")

socket.send("Ping")

task.delay(5, function()
    socket.close()
end)

-- The message will be nil when the socket has closed
repeat
    local messageFromServer = socket.next()
    if messageFromServer == "Ping" then
        socket.send("Pong")
    end
until messageFromServer == nil
```

----------------------------------------

TITLE: Pass Arguments to a Lune Script
DESCRIPTION: Allows passing command-line arguments to a Lune script. These arguments are accessible within the script using the `process.args` table.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 3 Running Scripts.md#_snippet_1

LANGUAGE: sh
CODE:
```
lune script-name arg1 arg2 "argument three"
```

LANGUAGE: lua
CODE:
```
print(process.args)
--> { "arg1", "arg2", "argument three" }
```

----------------------------------------

TITLE: Stopping Net Server Safely - net.serve - Lua
DESCRIPTION: This snippet shows the usage of the `NetServeHandle` returned by `net.serve`. It demonstrates how to obtain the handle when starting a server and how to call the `stop()` method on the handle to safely shut down the server after a specified delay.

SOURCE: https://github.com/lune-org/lune/blob/main/CHANGELOG.md#_snippet_24

LANGUAGE: lua
CODE:
```
local handle = net.serve(8080, function()
    return "Hello, world!"
end)

print("Shutting down after 1 second...")
task.wait(1)
handle.stop()
print("Shut down succesfully")
```

----------------------------------------

TITLE: Use net.request with Single Query Values
DESCRIPTION: Shows a basic example of using the @lune/net library to make an HTTP request with standard query parameters where each key has a single string value.

SOURCE: https://github.com/lune-org/lune/blob/main/CHANGELOG.md#_snippet_10

LANGUAGE: lua
CODE:
```
-- https://example.com/?foo=bar&baz=qux
local net = require("@lune/net")
net.request({
    url = "example.com",
    query = {
        foo = "bar",
        baz = "qux",
    }
})
```

----------------------------------------

TITLE: Run Lune Script from Stdin
DESCRIPTION: Executes a Lune script provided via standard input. This is useful for piping script content from external sources.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Getting Started - 3 Running Scripts.md#_snippet_3

LANGUAGE: sh
CODE:
```
lune -
```

----------------------------------------

TITLE: Accessing Roblox Reflection Database with roblox.getReflectionDatabase in Lua
DESCRIPTION: Shows how to use the `roblox.getReflectionDatabase` function from the `@lune/roblox` library to access the built-in database of Roblox classes and enums. The example demonstrates getting the total number of classes and iterating through the properties of the 'Instance' class.

SOURCE: https://github.com/lune-org/lune/blob/main/CHANGELOG.md#_snippet_18

LANGUAGE: Lua
CODE:
```
local roblox = require("@lune/roblox")

local db = roblox.getReflectionDatabase()

print("There are", #db:GetClassNames(), "classes in the reflection database")

print("All base instance properties:")

local class = db:GetClass("Instance")
for name, prop in class.Properties do
	print(string.format(
		"- %s with datatype %s and default value %s",
		prop.Name,
		prop.Datatype,
		tostring(class.DefaultProperties[prop.Name])
	))
end
```

----------------------------------------

TITLE: Using the datetime Library in Lua
DESCRIPTION: This snippet demonstrates how to use the new `@lune/datetime` built-in library in Lua. It shows how to get the current time, format it in different ways (ISO 8601, localized), create a `DateTime` instance from local time components, extract local and universal time components, and create an instance from a Unix timestamp.

SOURCE: https://github.com/lune-org/lune/blob/main/CHANGELOG.md#_snippet_13

LANGUAGE: Lua
CODE:
```
local DateTime = require("@lune/datetime")

-- Creates a DateTime for the current exact moment in time
local now = DateTime.now()

-- Formats the current moment in time as an ISO 8601 string
print(now:toIsoDate())

-- Formats the current moment in time, using the local
-- time, the French locale, and the specified time string
print(now:formatLocalTime("%A, %d %B %Y", "fr"))

-- Returns a specific moment in time as a DateTime instance
local someDayInTheFuture = DateTime.fromLocalTime({
    year = 3033,
    month = 8,
    day = 26,
    hour = 16,
    minute = 56,
    second = 28,
    millisecond = 892,
})

-- Extracts the current local date & time as separate values (same values as above table)
print(now:toLocalTime())

-- Returns a DateTime instance from a given float, where the whole
-- denotes the seconds and the fraction denotes the milliseconds
-- Note that the fraction for millis here is completely optional
DateTime.fromUnixTimestamp(871978212313.321)

-- Extracts the current universal (UTC) date & time as separate values
print(now:toUniversalTime())
```

----------------------------------------

TITLE: Configure Path Aliases in .luaurc
DESCRIPTION: Provides an example of a .luaurc configuration file defining a path alias (@modules) that maps to a local directory path, allowing for shorter require paths in Luau scripts.

SOURCE: https://github.com/lune-org/lune/blob/main/CHANGELOG.md#_snippet_7

LANGUAGE: jsonc
CODE:
```
// .luaurc
{
  "aliases": {
    "modules": "./some/long/path/to/modules"
  }
}
```

----------------------------------------

TITLE: Getting File Metadata with fs.metadata in Lua
DESCRIPTION: Illustrates the usage of the `fs.metadata` function from the `@lune/fs` library to retrieve information about a file. It shows how to write a file and then access properties like existence, kind (file/directory), creation timestamp, and permissions from the returned metadata object.

SOURCE: https://github.com/lune-org/lune/blob/main/CHANGELOG.md#_snippet_17

LANGUAGE: Lua
CODE:
```
local fs = require("@lune/fs")

fs.writeFile("myAwesomeFile.json", "{}")

local meta = fs.metadata("myAwesomeFile.json")

print(meta.exists) --> true
print(meta.kind) --> "file"
print(meta.createdAt) --> 1689848548.0577152 (unix timestamp)
print(meta.permissions) --> { readOnly: false }
```

----------------------------------------

TITLE: Serving HTTP Requests with net.serve (Lua)
DESCRIPTION: Demonstrates how to set up a simple HTTP server using the `net.serve` function in Lune. It shows how to handle incoming requests, access request details like method and path, decode JSON bodies, and return different types of responses (plain text or JSON) with custom statuses and headers. Requires the `net` library.

SOURCE: https://github.com/lune-org/lune/blob/main/CHANGELOG.md#_snippet_26

LANGUAGE: lua
CODE:
```
net.serve(8080, function(request)
    print(`Got a {request.method} request at {request.path}!`)

    local data = net.jsonDecode(request.body)

    -- For simple text responses with a 200 status
    return "OK"

    -- For anything else
    return {
        status = 203,
        headers = { ["Content-Type"] = "application/json" },
        body = net.jsonEncode({
            message = "echo",
            data = data,
        })
    }
end)
```

----------------------------------------

TITLE: Run Standalone Executable
DESCRIPTION: Shows how to execute the standalone binary created by the `lune build` command on Windows, macOS, or Linux, demonstrating the output of the compiled script.

SOURCE: https://github.com/lune-org/lune/blob/main/CHANGELOG.md#_snippet_6

LANGUAGE: sh
CODE:
```
> ./my_cool_script.exe # Windows
> ./my_cool_script # macOS / Linux
> "Hello, standalone!"
```

----------------------------------------

TITLE: Process Properties
DESCRIPTION: Provides information about the current execution environment, including processor architecture, operating system, and the current working directory.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/API Reference - Process.md#_snippet_0

LANGUAGE: APIDOC
CODE:
```
Process:
  arch: string
    The architecture of the processor currently being used. Possible values: "x86_64", "aarch64"
  cwd: string
    The current working directory in which the Lune script is running.
  os: string
    The current operating system being used. Possible values: "linux", "macos", "windows"
```

----------------------------------------

TITLE: Publishing a Release for Lune
DESCRIPTION: Steps for publishing a new release of Lune. This includes updating the changelog, setting the version in Cargo.toml, pushing changes, triggering the release workflow, and updating the release notes.

SOURCE: https://github.com/lune-org/lune/blob/main/CONTRIBUTING.md#_snippet_4

LANGUAGE: markdown
CODE:
```
Make sure the changelog is up to date and contains all of the changes since the last release.
Add the release date in the changelog + set a new version number in `Cargo.toml`.
Commit and push changes from step 2 to GitHub. This will automatically publish the Lune library to [crates.io](https://crates.io) when the version number changes.
Trigger the [release](https://github.com/lune-org/lune/actions/workflows/release.yaml) workflow on GitHub manually, and wait for it to finish. Find the new pending release in the [Releases](https://github.com/lune-org/lune/releases) section.
Add in changes from the changelog for the new pending release into the description, hit "accept" on creating a new version tag, and publish 🚀
```

----------------------------------------

TITLE: Lune FS: Write Directory
DESCRIPTION: Creates a directory and any necessary parent directories. Errors occur if the path exists as a file, or due to permission/I/O issues.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/API Reference - FS.md#_snippet_6

LANGUAGE: APIDOC
CODE:
```
writeDir(path: string)
  Creates a directory and its parent directories if they are missing.
  Errors:
  - `path` already points to an existing file or directory.
  - Insufficient permissions to create the directory or its parents.
  - Other I/O errors.
```

----------------------------------------

TITLE: Create a New Place File from Scratch
DESCRIPTION: Demonstrates creating a new Roblox DataModel from scratch using `Instance.new`, populating it with models and parts, and saving it to a place file. Requires the `@lune/roblox` library.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Roblox.md#_snippet_2

LANGUAGE: lua
CODE:
```
local roblox = require("@lune/roblox")
local Instance = roblox.Instance

-- You can even create a new DataModel using Instance.new, which is not normally possible in Roblox
-- This is normal - most instances that are not normally accessible in Roblox can be manipulated using Lune!
local game = Instance.new("DataModel")
local workspace = game:GetService("Workspace")

-- Here we just make a bunch of models with parts in them for demonstration purposes
for i = 1, 50 do
	local model = Instance.new("Model")
	model.Name = "Model #" .. tostring(i)
	model.Parent = workspace
	for j = 1, 4 do
		local part = Instance.new("Part")
		part.Name = "Part #" .. tostring(j)
		part.Parent = model
	end
end

-- As always, we have to save the DataModel (game) to a file when we're done
roblox.writePlaceFile("myPlaceWithLotsOfModels.rbxl")
```

----------------------------------------

TITLE: Using process.create for Interactive Process Management
DESCRIPTION: Demonstrates how to use the new `process.create` function in Lune to spawn a child process, write data to its standard input stream, and read data from its standard output stream. This API is designed for interactive process communication and replaces the older `process.spawn` for such use cases.

SOURCE: https://github.com/lune-org/lune/blob/main/CHANGELOG.md#_snippet_0

LANGUAGE: Lua
CODE:
```
local child = process.create("program", {
  "first-argument",
  "second-argument"
})

-- Writing to stdin
child.stdin:write("Hello from Lune!")

-- Reading partial data from stdout
local data = child.stdout:read()
print(data)

-- Reading the full stdout
local full = child.stdout:readToEnd()
print(full)
```

----------------------------------------

TITLE: Lune Runtime Overview
DESCRIPTION: This section provides a high-level overview of the Lune runtime, highlighting its core features and design principles. It emphasizes its Luau foundation, Rust implementation for performance and safety, and its asynchronous API design.

SOURCE: https://github.com/lune-org/lune/blob/main/README.md#_snippet_0

LANGUAGE: APIDOC
CODE:
```
Lune Runtime:
  Description: A standalone Luau runtime built in Rust for speed, safety, and correctness.
  Key Features:
    - Fully asynchronous APIs.
    - Minimal and powerful interface.
    - Comprehensive filesystem, networking, and stdio APIs.
    - Familiar environment for Roblox developers with task scheduler port.
    - Optional library for Roblox place/model file manipulation.
  Dependencies: Luau, Rust.
  Use Cases: Running Luau programs, development outside of Roblox, leveraging Roblox-specific features.
```

----------------------------------------

TITLE: Lune Project Dependencies and Tools
DESCRIPTION: Highlights key libraries and tools used in the Lune project for feature development and code quality. This includes mlua for Luau interfacing, and StyLua, rustfmt, and clippy for code formatting and linting.

SOURCE: https://github.com/lune-org/lune/blob/main/CONTRIBUTING.md#_snippet_5

LANGUAGE: markdown
CODE:
```
The [mlua](https://crates.io/crates/mlua) library, which we use to interface with Luau.
Any [built-in libraries](https://github.com/lune-org/lune/tree/main/src/lune/builtins) that are relevant for your new feature. If you are making a new built-in library, refer to existing ones for structure and implementation details.
Our toolchain, notably [StyLua](https://github.com/JohnnyMorganz/StyLua), [rustfmt](https://github.com/rust-lang/rustfmt), and [clippy](https://github.com/rust-lang/rust-clippy).
```

----------------------------------------

TITLE: Use net.request with Multiple Query Values
DESCRIPTION: Demonstrates how to use the @lune/net library to make an HTTP request where a single query parameter key (foo) has multiple associated values, represented as an ordered array of strings.

SOURCE: https://github.com/lune-org/lune/blob/main/CHANGELOG.md#_snippet_11

LANGUAGE: lua
CODE:
```
-- https://example.com/?foo=first&foo=second&foo=third&bar=baz
local net = require("@lune/net")
net.request({
    url = "example.com",
    query = {
        foo = { "first", "second", "third" },
        bar = "baz",
    }
})
```

----------------------------------------

TITLE: Set up Scheduler and Run Threads (Rust)
DESCRIPTION: Creates a new scheduler instance, loads Lua scripts for 'sleep' and 'readFile', spawns them as threads onto the scheduler, and then runs the scheduler until all threads complete using block_on.

SOURCE: https://github.com/lune-org/lune/blob/main/crates/mlua-luau-scheduler/README.md#_snippet_2

LANGUAGE: rust
CODE:
```
let sched = Scheduler::new(&lua)?;

// We can create multiple lua threads ...
let sleepThread = lua.load("sleep(0.1)");
let fileThread = lua.load("readFile(\"Cargo.toml\")");

// ... spawn them both onto the scheduler ...
sched.push_thread_front(sleepThread, ());
sched.push_thread_front(fileThread, ());

// ... and run until they finish
block_on(sched.run());
```

----------------------------------------

TITLE: Copying Directories and Files with fs.copy in Lua
DESCRIPTION: Demonstrates how to use the `fs.copy` function from the `@lune/fs` library to recursively copy a directory and its contents. It shows creating a source directory and file, copying it to a new location, and then asserting the existence and content of the copied files.

SOURCE: https://github.com/lune-org/lune/blob/main/CHANGELOG.md#_snippet_16

LANGUAGE: Lua
CODE:
```
local fs = require("@lune/fs")

fs.writeDir("myCoolDir")
fs.writeFile("myCoolDir/myAwesomeFile.json", "{}")

fs.copy("myCoolDir", "myCoolDir2")

assert(fs.isDir("myCoolDir2"))
assert(fs.isFile("myCoolDir2/myAwesomeFile.json"))
assert(fs.readFile("myCoolDir2/myAwesomeFile.json") == "{}")
```

----------------------------------------

TITLE: Printing Functions
DESCRIPTION: Provides utilities for printing values to standard output. Includes a general `print` function for formatted output, `printinfo` for prefixed informational messages, and `warn` for prefixed warning messages.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/API Reference - Uncategorized.md#_snippet_1

LANGUAGE: lune
CODE:
```
print(value: any, ...)
  Prints given value(s) to stdout. This will format and prettify values such as tables, numbers, booleans, and more.

printinfo(value: any, ...)
  Prints given value(s) to stdout with a leading `[INFO]` tag. This will format and prettify values such as tables, numbers, booleans, and more.

warn(value: any, ...)
  Prints given value(s) to stdout with a leading `[WARN]` tag. This will format and prettify values such as tables, numbers, booleans, and more.
```

----------------------------------------

TITLE: Serving Web Sockets and HTTP - net.serve - Lua
DESCRIPTION: This snippet demonstrates how to use `net.serve` to handle both standard HTTP requests and WebSocket connections on the same port. It shows how to define handlers for both request types, send messages to a client, receive messages using `socket.next()`, and close the WebSocket connection.

SOURCE: https://github.com/lune-org/lune/blob/main/CHANGELOG.md#_snippet_22

LANGUAGE: lua
CODE:
```
net.serve(8080, {
    handleRequest = function(request)
        return "Hello, world!"
    end,
    handleWebSocket = function(socket)
        task.delay(10, function()
            socket.send("Timed out!")
            socket.close()
        end)
        -- The message will be nil when the socket has closed
        repeat
            local messageFromClient = socket.next()
            if messageFromClient == "Ping" then
                socket.send("Pong")
            end
        until messageFromClient == nil
    end,
})
```

----------------------------------------

TITLE: HTTP Server Implementation in Lua
DESCRIPTION: Allows the creation of an HTTP server that listens on a specified port. The server runs asynchronously and can be stopped using the returned handle.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/API Reference - Net.md#_snippet_2

LANGUAGE: lua
CODE:
```
--- Creates an HTTP server that listens on the given `port`.
-- This will ***not*** block and will keep listening for requests on the given `port`
-- until the `stop` function on the returned `NetServeHandle` has been called.
serve(port: number): NetServeHandle

-- NetServeHandle definition:
-- NetServeHandle:
--   stop(): void
```

----------------------------------------

TITLE: Using Lune Regex Builtin (Lua)
DESCRIPTION: Demonstrates the basic usage of the new `Regex` builtin API in Lune, including creating a regex object, checking for matches, and capturing occurrences.

SOURCE: https://github.com/lune-org/lune/blob/main/CHANGELOG.md#_snippet_2

LANGUAGE: Lua
CODE:
```
local Regex = require("@lune/regex")

local re = Regex.new("hello")

if re:isMatch("hello, world!") then
	print("Matched!")
end

local caps = re:captures("hello, world! hello, again!")

print(#caps) -- 2
print(caps:get(1)) -- "hello"
print(caps:get(2)) -- "hello"
print(caps:get(3)) -- nil
```

----------------------------------------

TITLE: Instance Class Methods
DESCRIPTION: Details the available methods for the Instance class, which represents objects within the Roblox engine. Includes methods for creation, cloning, destruction, hierarchy traversal, and property checking.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/Roblox - API Reference.md#_snippet_1

LANGUAGE: APIDOC
CODE:
```
Instance:
  new(className: string) -> Instance
    Creates a new instance of the specified class. Note: Does not include the 'parent' argument.

  Clone(instance: Instance) -> Instance
    Creates a copy of the given instance.

  Destroy(instance: Instance)
    Removes the instance and all its descendants from the game.

  ClearAllChildren(instance: Instance)
    Removes all direct children of the instance.

  FindFirstAncestor(instance: Instance, name: string) -> Instance | nil
    Finds the first ancestor with the given name.

  FindFirstAncestorOfClass(instance: Instance, className: string) -> Instance | nil
    Finds the first ancestor of the specified class.

  FindFirstAncestorWhichIsA(instance: Instance, className: string) -> Instance | nil
    Finds the first ancestor that is of the specified class or inherits from it.

  FindFirstChild(instance: Instance, name: string) -> Instance | nil
    Finds the first direct child with the given name.

  FindFirstChildOfClass(instance: Instance, className: string) -> Instance | nil
    Finds the first direct child of the specified class.

  FindFirstChildWhichIsA(instance: Instance, className: string) -> Instance | nil
    Finds the first direct child that is of the specified class or inherits from it.

  FindFirstDescendant(instance: Instance, name: string) -> Instance | nil
    Finds the first descendant with the given name.

  GetChildren(instance: Instance) -> {Instance}
    Returns a table of all direct children of the instance.

  GetDescendants(instance: Instance) -> {Instance}
    Returns a table of all descendants of the instance.

  GetFullName(instance: Instance) -> string
    Returns the full hierarchical name of the instance.

  IsA(instance: Instance, className: string) -> boolean
    Checks if the instance is of the specified class or inherits from it.

  IsAncestorOf(instance: Instance, descendant: Instance) -> boolean
    Checks if the instance is an ancestor of the given descendant.

  IsDescendantOf(instance: Instance, ancestor: Instance) -> boolean
    Checks if the instance is a descendant of the given ancestor.

  GetAttribute(instance: Instance, name: string) -> any | nil
    Retrieves the value of an attribute.

  GetAttributes(instance: Instance) -> {[string]: any}
    Retrieves all attributes of the instance.

  SetAttribute(instance: Instance, name: string, value: any)
    Sets the value of an attribute.
```

----------------------------------------

TITLE: Lune Stdio User Prompting
DESCRIPTION: Facilitates user interaction by providing various prompting mechanisms: text input, confirmation (y/n), single selection from a list, and multi-selection from a list.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/API Reference - Stdio.md#_snippet_3

LANGUAGE: lua
CODE:
```
-- Prompts for user input.
prompt(kind, options)

-- Supported kinds:
-- "text" - Prompts for a plain text string.
-- "confirm" - Prompts for y / n confirmation.
-- "select" - Prompts for a single value selection from a list.
-- "multiselect" - Prompts for multiple value selections from a list.
-- nil - Equivalent to "text".
```

----------------------------------------

TITLE: Lune FS: Directory and File Checks
DESCRIPTION: Provides functions to check if a given path points to a directory or a file. Errors are thrown if the process lacks read permissions or if other I/O errors occur.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/API Reference - FS.md#_snippet_0

LANGUAGE: APIDOC
CODE:
```
isDir(path: string)
  Checks if a given path is a directory.
  Errors:
  - Insufficient read permissions for the path.
  - Other I/O errors.

isFile(path: string)
  Checks if a given path is a file.
  Errors:
  - Insufficient read permissions for the path.
  - Other I/O errors.
```

----------------------------------------

TITLE: Cross-Compiling Lune Binaries (Shell)
DESCRIPTION: Shows how to use the new `lune build` subcommand with the `--target` argument to compile a standalone binary for a specific platform, such as Windows x86_64.

SOURCE: https://github.com/lune-org/lune/blob/main/CHANGELOG.md#_snippet_3

LANGUAGE: Shell
CODE:
```
lune build my-file.luau --output my-bin --target windows-x86_64
```

----------------------------------------

TITLE: Set up Lua Environment with Async Functions (Rust)
DESCRIPTION: Initializes a new Lua environment and exposes asynchronous functions 'sleep' and 'readFile' to Lua. 'sleep' uses async_io::Timer for delays, and 'readFile' asynchronously reads file content, handling 'NotFound' errors.

SOURCE: https://github.com/lune-org/lune/blob/main/crates/mlua-luau-scheduler/README.md#_snippet_1

LANGUAGE: rust
CODE:
```
let lua = Lua::new();

lua.globals().set(
    "sleep",
    lua.create_async_function(|_, duration: f64| async move {
        let before = Instant::now();
        let after = Timer::after(Duration::from_secs_f64(duration)).await;
        Ok((after - before).as_secs_f64())
    })?,
)?;

lua.globals().set(
    "readFile",
    lua.create_async_function(|lua, path: String| async move {
        // Spawn background task that does not take up resources on the lua thread
        let task = lua.spawn(async move {
            match read_to_string(path).await {
                Ok(s) => Ok(Some(s)),
                Err(e) if e.kind() == ErrorKind::NotFound => Ok(None),
                Err(e) => Err(e),
            }
        });
        task.await.into_lua_err()
    })?,
?);
```

----------------------------------------

TITLE: Making HTTP Requests with net.request (Lua)
DESCRIPTION: Demonstrates how to use the `net.request` function to perform an HTTP PATCH request, including setting headers and encoding/decoding JSON bodies. Shows how to access the response body and decode it.

SOURCE: https://github.com/lune-org/lune/blob/main/CHANGELOG.md#_snippet_27

LANGUAGE: lua
CODE:
```
local apiResult = net.request({
	url = "https://jsonplaceholder.typicode.com/posts/1",
	method = "PATCH",
	headers = {
		["Content-Type"] = "application/json",
	},
	body = net.jsonEncode({
		title = "foo",
		body = "bar",
	}),
})

local apiResponse = net.jsonDecode(apiResult.body)
assert(apiResponse.title == "foo", "Invalid json response")
assert(apiResponse.body == "bar", "Invalid json response")
```

----------------------------------------

TITLE: Task Scheduling Functions
DESCRIPTION: Provides core functionalities for managing threads and tasks within the Lune environment. Includes methods for immediate execution, delayed execution, background execution, and cancellation.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/API Reference - Task.md#_snippet_0

LANGUAGE: lua
CODE:
```
--- Stops a currently scheduled thread from resuming.
-- @param thread The thread to cancel.
task.cancel(thread)

--- Defers a thread or function to run at the end of the current task queue.
-- @param threadOrFunction The thread or function to defer.
task.defer(threadOrFunction)

--- Delays a thread or function to run after `duration` seconds.
-- @param duration The delay in seconds.
-- @param threadOrFunction The thread or function to delay.
task.delay(duration, threadOrFunction)

--- Instantly runs a thread or function.
-- If the spawned task yields, the thread that spawned the task will resume, letting the spawned task run in the background.
-- @param threadOrFunction The thread or function to spawn.
task.spawn(threadOrFunction)

--- Waits for *at least* the given amount of time.
-- The minimum wait time possible when using `task.wait` is limited by the underlying OS sleep implementation.
-- For most systems this means `task.wait` is accurate down to about 5 milliseconds or less.
-- @param duration The minimum duration to wait in seconds.
task.wait(duration)
```

----------------------------------------

TITLE: WebSocket Client Connection in Lua
DESCRIPTION: Establishes a connection to a WebSocket server at a given URL. Errors are thrown for unsupported protocols or network issues.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/API Reference - Net.md#_snippet_3

LANGUAGE: lua
CODE:
```
--- Connects to a web socket at the given URL.
-- Throws an error if the server at the given URL does not support
-- web sockets, or if a miscellaneous network or I/O error occurs.
socket(url: string): WebSocketHandle

-- WebSocketHandle definition:
-- WebSocketHandle:
--   send(data: string): void
--   receive(): string
--   close(): void
```

----------------------------------------

TITLE: Build Standalone Executable with Lune
DESCRIPTION: Demonstrates the shell command to compile a single Luau script (`my_cool_script.luau`) into a platform-specific standalone executable using the `lune build` command.

SOURCE: https://github.com/lune-org/lune/blob/main/CHANGELOG.md#_snippet_5

LANGUAGE: sh
CODE:
```
> lune build my_cool_script.luau
# Creates `my_cool_script.exe` (Windows) or `my_cool_script` (macOS / Linux)
```

----------------------------------------

TITLE: Lune FS: Write File
DESCRIPTION: Writes data to a file at the specified path. Errors are thrown if the parent directory doesn't exist, permissions are insufficient, or other I/O errors occur.

SOURCE: https://github.com/lune-org/lune/blob/main/__wiki__/API Reference - FS.md#_snippet_7

LANGUAGE: APIDOC
CODE:
```
writeFile(path: string, data: string | Uint8Array)
  Writes to a file at `path`.
  Errors:
  - The file's parent directory does not exist.
  - Insufficient permissions to write to the file.
  - Other I/O errors.
```

----------------------------------------

TITLE: Reporting a Bug in Lune
DESCRIPTION: Instructions for reporting bugs in the Lune project. It advises checking for existing issues on GitHub and opening a new one with detailed information, including a code sample or test case if applicable.

SOURCE: https://github.com/lune-org/lune/blob/main/CONTRIBUTING.md#_snippet_0

LANGUAGE: markdown
CODE:
```
Make sure the bug has not already been reported by searching on GitHub under [Issues](https://github.com/lune-org/lune/issues).
If you're unable to find an open issue addressing the problem, [open a new one](https://github.com/lune-org/lune/issues/new). Be sure to include a **title and description**, as much relevant information as possible, and if applicable, a **code sample** or a **test case** demonstrating the expected behavior.
```

----------------------------------------

TITLE: Contributing Features to Lune
DESCRIPTION: Guidelines for contributing new features to Lune. This involves creating an issue, discussing API design, familiarizing with the codebase and tools (mlua, StyLua, rustfmt, clippy), writing code, and submitting a pull request with tests and issue links.

SOURCE: https://github.com/lune-org/lune/blob/main/CONTRIBUTING.md#_snippet_2

LANGUAGE: markdown
CODE:
```
Make sure an [issue](https://github.com/lune-org/lune/issues) has been created for the feature first, so that it can be tracked and searched for in the repository history. If you are making changes to an existing feature, and no issue exists, one should be created for the proposed changes.
Any API design or considerations should first be brought up and discussed in the relevant issue, to prevent long review times on pull requests and unnecessary work for maintainers.
Familiarize yourself with the codebase and the tools you will be using. Some important parts include:
  - The [mlua](https://crates.io/crates/mlua) library, which we use to interface with Luau.
  - Any [built-in libraries](https://github.com/lune-org/lune/tree/main/src/lune/builtins) that are relevant for your new feature. If you are making a new built-in library, refer to existing ones for structure and implementation details.
  - Our toolchain, notably [StyLua](https://github.com/JohnnyMorganz/StyLua), [rustfmt](https://github.com/rust-lang/rustfmt), and [clippy](https://github.com/rust-lang/rust-clippy). If you do not use these tools there is a decent chance CI will fail on your pull request, blocking it from getting approved.
Write some code!
Open a new GitHub pull request. A pull request for a feature must include:
  - A clear and concise description of the new feature or changes to the feature.
  - Test files for any added or changed functionality.
  - A link to the relevant issue, or a `Closes #issue` line.
```

----------------------------------------

TITLE: Contributing Bug Fixes to Lune
DESCRIPTION: Steps for submitting bug fixes to Lune. This includes creating an issue, opening a pull request with a clear description of the fix, a new test file, and a link to the relevant issue.

SOURCE: https://github.com/lune-org/lune/blob/main/CONTRIBUTING.md#_snippet_1

LANGUAGE: markdown
CODE:
```
Make sure an [issue](https://github.com/lune-org/lune/issues) has been created for the bug first, so that it can be tracked and searched for in the repository history. This is not mandatory for small fixes.
Open a new GitHub pull request for it. A pull request for a bug fix must include:
  - A clear and concise description of the bug it is fixing.
  - A new test file ensuring there are no regressions after the bug has been fixed.
  - A link to the relevant issue, or a `Fixes #issue` line, if an issue exists.
```