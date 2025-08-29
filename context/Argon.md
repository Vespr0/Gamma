========================
CODE SNIPPETS
========================
TITLE: Start Live Sync Session with `argon serve`
DESCRIPTION: Starts a Live Sync session for the current or a specified Argon project. This command supports options for configuring the host, port, sourcemap generation, roblox-ts usage, and asynchronous execution.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/cli.mdx#_snippet_2

LANGUAGE: bash
CODE:
```
argon serve [project] [session] --options
```

----------------------------------------

TITLE: Example Argon Project Configuration for a Game
DESCRIPTION: Provides a comprehensive Argon project configuration example for a game. It sets the project name, port, game ID, and defines a detailed tree structure mapping various game services and folders, including custom properties and class names for instances.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/api/project.mdx#_snippet_5

LANGUAGE: json
CODE:
```
{
  "name": "Game",
  "port:": 8080,
  "gameId": "1234567890",
  "tree": {
    "$className": "DataModel",

    "ReplicatedStorage": {
      "$path": "src/Shared",

      "Config": {
        "$className": "Configuration",
        "$keepUnknowns": true,

        "StartPos": {
          "$className": "Vector3Value",
          "$properties": {
            "Value": [0, 0, 0]
          }
        }
      }
    },

    "ServerScriptService": {
      "$path": "src/Server"
    },

    "StarterPlayer": {
      "$properties": {
        "CharacterWalkSpeed": 24
      },

      "StarterPlayerScripts": {
        "$path": "src/Client"
      }
    }
  }
}
```

----------------------------------------

TITLE: CLI Project Initialization Options
DESCRIPTION: This section outlines the command-line interface (CLI) options available for configuring a new Argon project. These flags allow users to specify templates, licenses, Git initialization, Wally setup, documentation inclusion, and TypeScript integration. All settings can be saved in a global configuration file.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/getting-started/new-project.mdx#_snippet_2

LANGUAGE: APIDOC
CODE:
```
Short: -T
Long: --template
Description: Choose the template to use for the project (default: place)

Short: -l
Long: --license
Description: License to include in the project, set using SPDX identifier (requires --docs)

Short: -g
Long: --git
Description: Initialize a new Git repository in the project folder

Short: -w
Long: --wally
Description: Add Wally manifest to use various packages in the project (if present in the template)

Short: -d
Long: --docs
Description: Include documentation files: README, LICENSE and CHANGELOG (if present in the template)

Short: -t
Long: --ts
Description: Initialize roblox-ts project to use TypeScript language
```

----------------------------------------

TITLE: Initialize a new Argon project using CLI
DESCRIPTION: This command initializes a new Argon project with the specified name. After running, you can add desired additional options to customize the project setup and review the generated project file.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/getting-started/new-project.mdx#_snippet_0

LANGUAGE: bash
CODE:
```
argon init <project-name>
```

----------------------------------------

TITLE: VS Code Command: Serve
DESCRIPTION: Starts a Live Sync session for the selected Argon project. It allows generating sourcemaps, using roblox-ts, and customizing the server address.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/vscode.mdx#_snippet_0

LANGUAGE: APIDOC
CODE:
```
Serve:
  Description: Start Live Sync session of the selected project.
  Arguments:
    project: project to serve
  Options:
    Generate sourcemap: Whether to generate Sourcemap every time files change
    Use roblox-ts: Whether to serve using roblox-ts
    Customize address: Enter a custom Live Sync server host name or port or both
```

----------------------------------------

TITLE: Install Argon Roblox Studio Plugin via CLI
DESCRIPTION: This command uses the Argon CLI to install the Roblox Studio plugin. It is the recommended method as it enables automatic plugin updates, simplifying maintenance. This command ensures the plugin is correctly integrated with your Roblox Studio setup.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/installation.mdx#_snippet_2

LANGUAGE: bash
CODE:
```
argon plugin install
```

----------------------------------------

TITLE: install_plugin Configuration
DESCRIPTION: Whether to install Roblox plugin locally by default and keep it updated when above settings are enabled.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/configuration.mdx#_snippet_9

LANGUAGE: APIDOC
CODE:
```
install_plugin: boolean (default: true)
  Description: Whether to install Roblox plugin locally by default and keep it updated when above settings are enabled.
```

----------------------------------------

TITLE: Install Argon CLI with Aftman or Rokit
DESCRIPTION: This command installs the Argon CLI globally using either the Aftman or Rokit toolchain managers. It's a convenient way to integrate Argon into your existing development environment if you use these tools. This method disables Argon's automatic updates.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/installation.mdx#_snippet_0

LANGUAGE: bash
CODE:
```
aftman/rokit add argon-rbx/argon --global
```

----------------------------------------

TITLE: Install/Uninstall Argon Roblox Studio Plugin
DESCRIPTION: Installs or uninstalls the Argon Roblox Studio plugin locally. The mode can be `install` (default) or `uninstall`. An optional path can be provided to specify where to install or uninstall the plugin.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/cli.mdx#_snippet_12

LANGUAGE: bash
CODE:
```
argon plugin [mode] [path]
```

----------------------------------------

TITLE: Example Argon Project Configuration for a Plugin
DESCRIPTION: Illustrates a basic Argon project configuration for a plugin or model. It defines the project name, specifies a glob pattern to ignore test files, and maps the 'src' folder to the project's tree structure, including a manifest file.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/api/project.mdx#_snippet_4

LANGUAGE: json
CODE:
```
{
  "name": "Plugin",
  "ignoreGlobs": ["**/*.spec.lua"],
  "tree": {
    "$path": "src",
    "manifest": {
      "$path": "wally.toml"
    }
  }
}
```

----------------------------------------

TITLE: Install Argon CLI with Cargo
DESCRIPTION: This command installs the Argon CLI using Cargo, Rust's package manager. This method is intended for Rust developers and also disables Argon's automatic updates. Note that this installation option is currently not available.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/installation.mdx#_snippet_1

LANGUAGE: bash
CODE:
```
cargo install argon-rbx
```

----------------------------------------

TITLE: VS Code Command: Plugin
DESCRIPTION: Installs or uninstalls the Argon Roblox Studio plugin locally.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/vscode.mdx#_snippet_8

LANGUAGE: APIDOC
CODE:
```
Plugin:
  Description: Install or uninstall Argon Roblox Studio plugin locally.
  Modes:
    Install: Install the plugin
    Uninstall: Uninstall the plugin
```

----------------------------------------

TITLE: GitHub Action for Argon Plugin Build and Release
DESCRIPTION: This GitHub Action automates the build and release process for an Argon plugin. It triggers on new tags, creates a draft release, builds the plugin using `argon build`, uploads it as a GitHub artifact and to the draft release, and finally publishes the release. It integrates with `wally install` for dependencies and uses various GitHub Actions for checkout, release creation, artifact upload, and release asset upload.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/getting-started/advanced-usage.mdx#_snippet_0

LANGUAGE: YAML
CODE:
```
name: Build and Release

on:
  push:
    tags: ["*"]

jobs:
  # Create a draft release on GitHub
  draft-release:
    name: Draft Release
    runs-on: ubuntu-latest

    outputs:
      upload_url: ${{ steps.create-release.outputs.upload_url }}
      release_id: ${{ steps.create-release.outputs.id }}

    steps:
      - uses: actions/checkout@v4

      - name: Create Release
        id: create-release
        uses: shogo82148/actions-create-release@v1
        with:
          release_name: ${{ github.ref_name }}
          draft: true

  # Build the plugin and upload it to GitHub
  build:
    name: Build
    runs-on: ubuntu-latest
    needs: draft-release

    steps:
      - uses: actions/checkout@v4

        # Setup Aftman that installs Argon and Wally
      - name: Setup Aftman
        uses: ok-nick/setup-aftman@v0.4.2

        # Install Wally dependencies that our plugin uses
      - name: Install dependencies
        run: wally install

        # Build the plugin
      - name: Build
        run: argon build -vvvv

        # Upload the plugin to GitHub artifacts
      - name: Upload to Artifacts
        uses: actions/upload-artifact@v4
        with:
          name: plugin.rbxm
          path: plugin.rbxm

        # Upload the plugin to the draft release
      - name: Upload to Release
        uses: shogo82148/actions-upload-release-asset@v1
        with:
          upload_url: ${{ needs.draft-release.outputs.upload_url }}
          asset_name: plugin.rbxm
          asset_path: plugin.rbxm

  # Publish the release
  publish-release:
    name: Publish Release
    runs-on: ubuntu-latest
    needs: [build, draft-release]

    steps:
      - uses: eregon/publish-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          release_id: ${{ needs.draft-release.outputs.release_id }}
```

----------------------------------------

TITLE: VS Code Command: Debug
DESCRIPTION: Starts or stops a Roblox playtest with a specified mode (Play, Run, Start, Stop).

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/vscode.mdx#_snippet_5

LANGUAGE: APIDOC
CODE:
```
Debug:
  Description: Start or stop Roblox playtest with the selected mode.
  Modes:
    Play: Play the game as a player
    Run: Run the game server only
    Start: Start game server and players
    Stop: Stop any playtest mode
```

----------------------------------------

TITLE: Manually Update Argon CLI
DESCRIPTION: This command initiates a manual update check and installation for the Argon CLI. It's useful for forcing an update or verifying the current version outside of the automatic update cycle. This command ensures you have the latest features and bug fixes.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/installation.mdx#_snippet_3

LANGUAGE: bash
CODE:
```
argon update
```

----------------------------------------

TITLE: Build Argon Project with `argon build`
DESCRIPTION: Builds a place or model project into Roblox binary or XML format. This command allows specifying output location, watch mode, sourcemap generation, plugin installation, XML format, roblox-ts usage, and asynchronous execution.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/cli.mdx#_snippet_4

LANGUAGE: bash
CODE:
```
argon build [project] [session] --options
```

----------------------------------------

TITLE: Control Roblox Playtest Debug Mode
DESCRIPTION: Starts or stops a Roblox playtest using a selected debug mode. The available modes are `play`, `run`, `start`, or `stop`. If no mode is specified, the command defaults to `play`.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/cli.mdx#_snippet_9

LANGUAGE: bash
CODE:
```
argon debug [mode]
```

----------------------------------------

TITLE: detect_project Configuration
DESCRIPTION: Whether Argon should intelligently detect the project type. This allows to run roblox-ts or to install Wally packages automatically, regardless if use_wally or ts_mode settings are enabled.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/configuration.mdx#_snippet_3

LANGUAGE: APIDOC
CODE:
```
detect_project: boolean (default: true)
  Description: Whether Argon should intelligently detect the project type. This allows to run roblox-ts or to install Wally packages automatically, regardless if use_wally or ts_mode settings are enabled.
```

----------------------------------------

TITLE: auto_update Configuration
DESCRIPTION: When enabled Argon will automatically install Argon updates if available. Otherwise you will be prompted for confirmation. This setting also works with install_plugin and update_templates.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/configuration.mdx#_snippet_8

LANGUAGE: APIDOC
CODE:
```
auto_update: boolean (default: false)
  Description: When enabled Argon will automatically install Argon updates if available. Otherwise you will be prompted for confirmation. This setting also works with install_plugin and update_templates.
```

----------------------------------------

TITLE: Bytecode Property Type Support
DESCRIPTION: Details the support for the 'Bytecode' property type, which has no direct example property, across various Argon Roblox data formats.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/src/components/PropertyCoverage.md#_snippet_5

LANGUAGE: APIDOC
CODE:
```
PropertyType: Bytecode
ExampleProperty: N/A
Support:
  CLI: Unimplemented
  Plugin: Never
  XML: Unimplemented
  Binary: Unimplemented
```

----------------------------------------

TITLE: Vector2int16 Property Type Support
DESCRIPTION: Details the support for the 'Vector2int16' property type, which has no direct example property, across various Argon Roblox data formats.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/src/components/PropertyCoverage.md#_snippet_36

LANGUAGE: APIDOC
CODE:
```
PropertyType: Vector2int16
ExampleProperty: N/A
Support:
  CLI: Implemented
  Plugin: Implemented
  XML: Implemented
  Binary: Unimplemented
```

----------------------------------------

TITLE: SharedString Property Type Support
DESCRIPTION: Details the support for the 'SharedString' property type, which has no direct example property, across various Argon Roblox data formats.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/src/components/PropertyCoverage.md#_snippet_30

LANGUAGE: APIDOC
CODE:
```
PropertyType: SharedString
ExampleProperty: N/A
Support:
  CLI: Implemented
  Plugin: Implemented
  XML: Implemented
  Binary: Implemented
```

----------------------------------------

TITLE: Region3 Property Type Support
DESCRIPTION: Details the support for the 'Region3' property type, which has no direct example property, across various Argon Roblox data formats.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/src/components/PropertyCoverage.md#_snippet_27

LANGUAGE: APIDOC
CODE:
```
PropertyType: Region3
ExampleProperty: N/A
Support:
  CLI: Implemented
  Plugin: Implemented
  XML: Unimplemented
  Binary: Unimplemented
```

----------------------------------------

TITLE: APIDOC: `argon init` Command Arguments and Options
DESCRIPTION: Detailed documentation for the `argon init` command, including its optional `project` argument and various configuration options like `--template`, `--license`, `--git`, `--wally`, `--docs`, and `--ts`.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/cli.mdx#_snippet_1

LANGUAGE: APIDOC
CODE:
```
Arguments:
- project: path to the new project or its parent folder (optional)

Options:
-T, --template: Choose the Template to use for the project (default: `place`)
-l, --license: License to include in the project, set using SPDX identifier (requires `--docs`)
-g, --git: Initialize a new Git repository in the project folder
-w, --wally: Add Wally manifest to use various packages in the project (if present in the template)
-d, --docs: Include documentation files: README, LICENSE and CHANGELOG (if present in the template)
-t, --ts: Initialize roblox-ts project to use TypeScript language
```

----------------------------------------

TITLE: VS Code Project Initialization Options
DESCRIPTION: This section details the optional files and tools that can be included when initializing a new Argon project specifically for VS Code environments. These options are remembered for future projects.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/getting-started/new-project.mdx#_snippet_1

LANGUAGE: APIDOC
CODE:
```
Option: Include docs
Description: Include documentation files: README, LICENSE and CHANGELOG (if present in the template)

Option: Configure Git
Description: Initialize a new Git repository in the project folder

Option: Setup Wally
Description: Add Wally manifest to use various packages in the project (if present in the template)

Option: Use roblox-ts
Description: Initialize roblox-ts project to use TypeScript language
```

----------------------------------------

TITLE: VS Code Command: Help
DESCRIPTION: Opens Argon's official documentation in the browser.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/vscode.mdx#_snippet_11

LANGUAGE: APIDOC
CODE:
```
Help:
  Description: Open Argon's documentation in the browser (homepage of this website).
```

----------------------------------------

TITLE: Initialize Argon Project with `argon init`
DESCRIPTION: Initializes a new Argon project. This command allows specifying a project path and various options to configure the new project, such as choosing a template, including a license, initializing a Git repository, adding Wally manifest, including documentation files, and setting up a roblox-ts project.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/cli.mdx#_snippet_0

LANGUAGE: bash
CODE:
```
argon init [project] --options
```

----------------------------------------

TITLE: VS Code Command: Studio
DESCRIPTION: Launches a new Roblox Studio instance or opens a specific place file directly from VS Code.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/vscode.mdx#_snippet_7

LANGUAGE: APIDOC
CODE:
```
Studio:
  Description: Launch a new Roblox Studio instance or open place file directly from the Visual Studio Code.
  Arguments:
    place: place file (.rbxl / .rbxlx) to open (optional)
```

----------------------------------------

TITLE: APIDOC: `argon serve` Command Arguments and Options
DESCRIPTION: Detailed documentation for the `argon serve` command, including its optional `project` and `session` arguments, and various configuration options like `--host`, `--port`, `--sourcemap`, `--ts`, and `--async`.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/cli.mdx#_snippet_3

LANGUAGE: APIDOC
CODE:
```
Arguments:
- project: path to the project to serve (optional)
- session: name of the session to start (optional)

Options:
-H, --host: Live sync server host name
-P, --port: Live sync server port
-s, --sourcemap: Whether to generate Sourcemap every time files change
-t, --ts: Whether to serve using roblox-ts
-a, --async: Run Argon asynchronously, freeing up the terminal
```

----------------------------------------

TITLE: VS Code Command: Init
DESCRIPTION: Initializes a new Argon project based on a specified template. It offers options to include documentation, configure Git, set up Wally, and initialize a roblox-ts project.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/vscode.mdx#_snippet_3

LANGUAGE: APIDOC
CODE:
```
Init:
  Description: Initialize a new Argon project.
  Arguments:
    project: project name to use (default is recommended)
    template: project Template to use
  Options:
    Include docs: Include documentation files: README, LICENSE and CHANGELOG (if present in the template)
    Configure Git: Initialize a new Git repository in the project folder
    Setup Wally: Add Wally manifest to use various packages in the project (if present in the template)
    Use roblox-ts: Initialize roblox-ts project to use TypeScript language
```

----------------------------------------

TITLE: APIDOC: `argon build` Command Arguments and Options
DESCRIPTION: Detailed documentation for the `argon build` command, including its optional `project` and `session` arguments, and various configuration options like `--output`, `--watch`, `--sourcemap`, `--plugin`, `--xml`, `--ts`, and `--async`.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/cli.mdx#_snippet_5

LANGUAGE: APIDOC
CODE:
```
Arguments:
- project: path to the project to build (optional)
- session: name of the session to start (optional)

Options:
-o, --output: Where to place built project (defaults to the current directory)
-w, --watch: Whether to rebuild project every time files change
-s, --sourcemap: Whether to generate Sourcemap every time files change
-p, --plugin: Whether to put built project into Roblox Studio plugins folder (ignores `--output`)
-x, --xml: Whether to build in XML format (.rbxlx or .rbxmx)
-t, --ts: Whether to build using roblox-ts
-a, --async: Run Argon asynchronously, freeing up the terminal (requires `--watch`)
```

----------------------------------------

TITLE: Open Argon Documentation in Browser
DESCRIPTION: Executes a command to open the official Argon documentation homepage in the user's default web browser, providing quick access to project information.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/cli.mdx#_snippet_15

LANGUAGE: bash
CODE:
```
argon doc
```

----------------------------------------

TITLE: Illustrate Game Filesystem Structure
DESCRIPTION: This snippet shows the recommended file organization for a Roblox game project on the local filesystem. It details source directories for client, server, and shared code, alongside packages and configuration files.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/examples/place.mdx#_snippet_1

LANGUAGE: txt
CODE:
```
root
│
├── Packages
├── src
│   ├── Client
│   │   ├── Loader.client.luau
│   │   └── Controller
│   │       ├── init.client.luau
│   │       ├── Camera.luau
│   │       └── Input.luau
│   │
│   ├── Server
│   │   ├── Main.server.lua
│   │   └── Test.server.lua
│   │
│   └── Shared
│       ├── Models
│       │   ├── Clickable
│       │   │   ├── init.meta.json
│       │   │   └── Handler.server.lua
│       │   │
│       │   └── Car.model.json
│       │
│       ├── Assets.json
│       ├── Keybinds.toml
│       └── Utils.lua
│
├── .gitignore
├── README.md
├── default.project.json
└── wally.toml
```

----------------------------------------

TITLE: build_xml Configuration
DESCRIPTION: If no path is provided, Build command will always use the Roblox XML format instead of binary.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/configuration.mdx#_snippet_6

LANGUAGE: APIDOC
CODE:
```
build_xml: boolean (default: false)
  Description: If no path is provided, Build command will always use the Roblox XML format instead of binary.
```

----------------------------------------

TITLE: Launch Roblox Studio with Argon
DESCRIPTION: Launches a new Roblox Studio instance or directly opens a specified place file from the command line. An optional path to the place file can be provided. An available option allows checking if Roblox Studio is already running, preventing a new launch if an instance is active.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/cli.mdx#_snippet_8

LANGUAGE: bash
CODE:
```
argon studio [path] --options
```

----------------------------------------

TITLE: Filesystem to Roblox Instance Mapping with Data and Children
DESCRIPTION: Demonstrates how a folder 'Foo' containing an 'init.meta.lua' file, a 'Bar.txt' file, and a 'Baz.csv' file is transformed into a Roblox hierarchy. 'Foo' becomes a Part instance, with 'Bar' as a StringValue and 'Baz' as a LocalizationTable.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/api/file-types.mdx#_snippet_1

LANGUAGE: mermaid
CODE:
```
graph TD;
  foo(Foo/)
  init(init.meta.lua)
  bar(Bar.txt)
  baz(Baz.csv)

foo --> init
foo --> bar
foo --> baz
```

LANGUAGE: mermaid
CODE:
```
graph TD;
  foo("Foo (Part)")
  bar("Bar (StringValue)")
  baz("Baz (LocalizationTable)")

  foo --> bar
  foo --> baz
```

----------------------------------------

TITLE: Configure Roblox Project with default.project.json
DESCRIPTION: This JSON configuration defines the Roblox game project's structure, mapping source directories to their DataModel locations. It includes paths for shared, server, and client-side code, and Wally packages.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/examples/place.mdx#_snippet_0

LANGUAGE: json
CODE:
```
{
  "name": "example",
  "tree": {
    "$className": "DataModel",
    "ReplicatedStorage": {
      "$path": "src/Shared",
      "Packages": {
        "$path": "Packages"
      }
    },
    "ServerScriptService": {
      "$path": "src/Server"
    },
    "StarterPlayer": {
      "StarterPlayerScripts": {
        "$path": "src/Client"
      }
    }
  }
}
```

----------------------------------------

TITLE: Argon CLI Config Command Arguments and Options
DESCRIPTION: Detailed API documentation for the `argon config` command, outlining its optional `setting` and `value` arguments, and the `--list` and `--default` options for managing configuration settings.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/cli.mdx#_snippet_14

LANGUAGE: APIDOC
CODE:
```
Arguments:
- setting: name of the setting to edit (optional)
- value: new value for the setting (optional)

Options:
-l, --list: List all available settings and their default values in a nice table
-d, --default: Restore all settings to their default values
```

----------------------------------------

TITLE: Display Argon CLI Help Message
DESCRIPTION: Prints a comprehensive help message to the console, detailing all available Argon commands, their options, and brief descriptions to assist users with command-line usage.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/cli.mdx#_snippet_16

LANGUAGE: bash
CODE:
```
argon help
```

----------------------------------------

TITLE: Configure Argon Syncback Instance Filtering
DESCRIPTION: This JSON configuration snippet demonstrates how to set up instance filtering in your `*.project.json` file. You can specify names, classes, and properties to be ignored during syncback, preventing unwanted instances or properties from being transferred from Roblox Studio to your file system.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/getting-started/porting.mdx#_snippet_0

LANGUAGE: json
CODE:
```
{
  "name": "Project",
  "tree": {
    "$path": "src"
  },
  "syncback": {
    "ignoreNames": ["Map", "Models"],
    "ignoreClasses": ["Part", "Camera"],
    "ignoreProperties": ["Size", "Position"]
  }
}
```

----------------------------------------

TITLE: Argon CLI Command Options
DESCRIPTION: Options available when running the `argon` command line interface to customize its behavior, such as including documentation or selecting a project template.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/configuration.mdx#_snippet_0

LANGUAGE: APIDOC
CODE:
```
Argon CLI Options:
  --docs, -d: Include documentation in the project
  --template, -T: Select the project template
```

----------------------------------------

TITLE: VS Code Command: Build
DESCRIPTION: Builds a place or model project into Roblox binary (.rbxl/.rbxmx) or XML format. It supports watching for changes, sourcemap generation, plugin building, and roblox-ts integration.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/vscode.mdx#_snippet_1

LANGUAGE: APIDOC
CODE:
```
Build:
  Description: Build place or model project into Roblox binary or XML format.
  Arguments:
    project: project to build
    output: name of the built binary or XML file (defaults to the project name)
  Options:
    Watch for changes: Whether to rebuild project every time files change
    Generate sourcemap: Whether to generate Sourcemap every time files change
    Build plugin: Whether to put built project into Roblox Studio plugins folder (ignores output)
    Use XML format: Whether to build in XML format (.rbxlx or .rbxmx)
    Use roblox-ts: Whether to build using roblox-ts
```

----------------------------------------

TITLE: Filesystem to Roblox Instance Mapping with Children and Associated Data
DESCRIPTION: Shows how a folder 'Foo' containing 'Bar.json' and its associated metadata 'Bar.meta.json', along with 'Baz.toml', is transformed. 'Foo' becomes a Folder instance, and 'Bar' and 'Baz' both become ModuleScript instances, with 'Bar.meta.json' applying metadata to 'Bar'.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/api/file-types.mdx#_snippet_2

LANGUAGE: mermaid
CODE:
```
graph TD;
  foo(Foo/)
  bar(Bar.json)
  bar.meta(Bar.meta.json)
  baz(Baz.toml)

foo --> bar
foo --> bar.meta
foo --> baz
```

LANGUAGE: mermaid
CODE:
```
graph TD;
  foo("Foo (Folder)")
  bar("Bar (ModuleScript)")
  baz("Baz (ModuleScript)")

  foo --> bar
  foo --> baz
```

----------------------------------------

TITLE: Argon CLI Global Configuration File Settings
DESCRIPTION: Details the configurable settings available in Argon's global `config.toml` file, which sets default behaviors for the CLI commands like `argon init`, `argon serve`, `argon build`, and `argon sourcemap`.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/configuration.mdx#_snippet_1

LANGUAGE: APIDOC
CODE:
```
Setting: host
  Default: localhost
  Description: Default server host name when live syncing

Setting: port
  Default: 8000
  Description: Default server port when live syncing

Setting: template
  Default: place
  Description: Default project [Template](./getting-started/new-project.mdx#project-templates) to use when creating a new project with `argon init`. Argon comes with five templates: **place**, **plugin**, **package**, **model**, **empty** and **quick**. But you can add your own! Just create a new folder with the desired name and contents in `.argon/templates/`

Setting: license
  Default: Apache-2.0
  Description: Default project license [SPDX identifier](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository#searching-github-by-license-type) to use when creating a new project with `argon init`. Argon will pull license template from GitHub so if there is no internet connection, placeholder will be used instead

Setting: include_docs
  Default: true
  Description: Controls whether documentation files: **README**, **LICENSE** or **CHANGELOG** should be included in the project (when running `argon init` and present in the project **template**)

Setting: use_git
  Default: true
  Description: Toggles the use of [Git](https://git-scm.com/) for source control. If enabled Argon will initialize a new repository and add `.gitignore` file (when running `argon init` and present in the project **template** )

Setting: use_wally
  Default: false
  Description: Whether to use [Wally](https://wally.run/) for package management. When enabled Argon will install dependencies automatically, add `wally.toml` file and append `Packages` path to the project file (when running `argon init` and present in the project **template** )

Setting: use_selene
  Default: false
  Description: Whether to use [selene](https://kampfkarren.github.io/selene/) for codebase linting. If enabled Argon will add `selene.toml` configuration file (when running `argon init` and present in the project **template** )

Setting: run_async
  Default: false
  Description: Whether to run Argon asynchronously every time you use `argon serve`, `argon build` or `argon sourcemap` (with `--watch` enabled). Useful when running multiple Argon instances as it will free up the terminal. To stop running Argon sessions use `argon stop` command
```

----------------------------------------

TITLE: Argon Global Configuration Options
DESCRIPTION: Describes various configuration parameters for Argon, including settings for instance renaming, duplicate handling, file deletion, change thresholds, file extensions, line endings, package manager, and usage statistics.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/configuration.mdx#_snippet_13

LANGUAGE: APIDOC
CODE:
```
rename_instances:
  Type: boolean
  Default: true
  Description: If enabled Argon will automatically rename improperly named instances by removing all Forbidden Characters from their names
keep_duplicates:
  Type: boolean
  Default: false
  Description: If enabled Argon will automatically rename instances that already exist in the filesystem by adding UUID v4 to their names
move_to_bin:
  Type: boolean
  Default: false
  Description: Controls whether to move files to the system bin instead of permanently deleting them (only applies when syncing changes from Roblox Studio to the file system)
changes_threshold:
  Type: number
  Default: 5
  Description: Maximum number of incoming changes allowed before prompting for confirmation
max_unsynced_changes:
  Type: number
  Default: 10
  Description: Maximum number of unsynced changes before showing a warning that the client is not connected and changes are not synced
lua_extension:
  Type: boolean
  Default: false
  Description: Toggles between .lua and .luau file extension when writing and transforming scripts
ignore_line_endings:
  Type: boolean
  Default: true
  Description: Ignore line endings when reading files to avoid unnecessary script diffs in Roblox Studio
package_manager:
  Type: string
  Default: npm
  Description: Package manager to use when running roblox-ts related scripts. Currently Argon supports every major package manager: bun, npm, pnpm and yarn however, any binary that has "create" command and can execute dynamic packages will work
share_stats:
  Type: boolean
  Default: true
  Description: Toggles sharing of anonymous Argon usage statistics which are displayed on the argon.wiki home page to show the size of the Argon community
```

----------------------------------------

TITLE: smart_paths Configuration
DESCRIPTION: If enabled smart path resolver will be used which makes providing path arguments or options easier and faster. When active Argon will try to locate the file with its shorter form e.g. argon serve dev instead of argon serve dev.project.json.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/configuration.mdx#_snippet_4

LANGUAGE: APIDOC
CODE:
```
smart_paths: boolean (default: false)
  Description: If enabled smart path resolver will be used which makes providing path arguments or options easier and faster. When active Argon will try to locate the file with its shorter form e.g. argon serve dev instead of argon serve dev.project.json.
```

----------------------------------------

TITLE: Visualize Roblox Studio Game Structure After Argon Processing
DESCRIPTION: This snippet illustrates the game project's structure within Roblox Studio after Argon processing. It shows the hierarchy of scripts, modules, and assets within the Roblox DataModel.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/examples/place.mdx#_snippet_2

LANGUAGE: txt
CODE:
```
game
│
├── StarterPlayer
│   └── StarterPlayerScripts
│       ├── Loader (LocalScript)
│       └── Controller (LocalScript)
│           ├── Camera (ModuleScript)
│           └── Input (ModuleScript)
│
├── ServerScriptService
│   ├── Main (Script)
│   └── Test (Script)
│
└── ReplicatedStorage
    ├── Models (Folder)
    │   ├── Clickable (ClickDetector)
    │   │   └── Handler (Script)
    │   │
    │   └── Car (Part)
    │       └── Spray (Highlight)
    │
    ├── Packages (Folder)
    ├── Assets (ModuleScript)
    ├── Keybinds (ModuleScript)
    └── Utils (ModuleScript)
```

----------------------------------------

TITLE: VS Code Command: Exec
DESCRIPTION: Executes Luau code directly in Roblox Studio. Requires an active Live Sync session.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/vscode.mdx#_snippet_6

LANGUAGE: APIDOC
CODE:
```
Exec:
  Description: Execute Luau code in Roblox Studio, Requires running Live Sync session.
```

----------------------------------------

TITLE: Filesystem to Roblox Instance Mapping with Children
DESCRIPTION: Illustrates how a filesystem structure with an 'init.server.lua' script and other scripts within a folder 'Foo' is transformed into a Roblox hierarchy where 'Foo' becomes a Script instance containing a LocalScript and a ModuleScript.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/api/file-types.mdx#_snippet_0

LANGUAGE: mermaid
CODE:
```
graph TD;
  foo(Foo/)
  init(init.server.lua)
  bar(Bar.client.lua)
  baz(Baz.lua)

foo --> init
foo --> bar
foo --> baz
```

LANGUAGE: mermaid
CODE:
```
graph TD;
  foo("Foo (Script)")
  bar("Bar (LocalScript)")
  baz("Baz (ModuleScript)")

  foo --> bar
  foo --> baz
```

----------------------------------------

TITLE: VS Code Command: Settings
DESCRIPTION: Opens Argon-specific settings within Visual Studio Code's user or workspace settings.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/vscode.mdx#_snippet_10

LANGUAGE: APIDOC
CODE:
```
Settings:
  Description: Open Argon only settings in the Visual Studio Code user or workspace settings.
```

----------------------------------------

TITLE: check_updates Configuration
DESCRIPTION: Whether to check for new Argon releases on CLI startup (limited to once per hour). This setting also updates Argon plugin if install_plugin is enabled and project templates if update_templates is enabled.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/configuration.mdx#_snippet_7

LANGUAGE: APIDOC
CODE:
```
check_updates: boolean (default: true)
  Description: Whether to check for new Argon releases on CLI startup (limited to once per hour). This setting also updates Argon plugin if install_plugin is enabled and project templates if update_templates is enabled.
```

----------------------------------------

TITLE: with_sourcemap Configuration
DESCRIPTION: Whether Argon should generate sourcemap by default when running Serve or Build command. Useful for Luau LSP users.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/configuration.mdx#_snippet_5

LANGUAGE: APIDOC
CODE:
```
with_sourcemap: boolean (default: false)
  Description: Whether Argon should generate sourcemap by default when running Serve or Build command. Useful for Luau LSP users.
```

----------------------------------------

TITLE: Configure Syncback Settings for Argon Projects
DESCRIPTION: Details the settings available to control which instances and properties should be synced back to the file system in an Argon project. These settings allow for excluding files, instances by name or class, and specific properties from the syncback process.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/api/project.mdx#_snippet_3

LANGUAGE: APIDOC
CODE:
```
Setting | Description
ignoreGlobs | Exclude files that match any of these globs from processing changes
ignoreNames | Exclude instances with these names from processing changes
ignoreClasses | Exclude instances with these classes from processing changes
ignoreProperties | Exclude these properties from being saved to the file system
```

----------------------------------------

TITLE: Convert YAML to Lua ModuleScript
DESCRIPTION: Explains the conversion of `.yaml` or `.yml` files into a `ModuleScript` that returns a Lua table with the same structure. YAML's easy syntax also makes it a good choice for configuration files.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/api/file-types.mdx#_snippet_6

LANGUAGE: YAML
CODE:
```
string: abc
bool: true

array:
  - 1
  - 2
  - 3

object:
  int: 1337
  float: 4.2
```

LANGUAGE: Lua
CODE:
```
return {
	["string"] = "abc",
	["bool"] = true,
	["array"] = {1, 2, 3},
	["object"] = {
		["int"] = 1337,
		["float"] = 4.2,
	}
}
```

----------------------------------------

TITLE: Convert TOML to Lua ModuleScript
DESCRIPTION: Details how `.toml` files are converted into a `ModuleScript` that returns a Lua table mirroring the TOML structure. TOML's human-readable format makes it suitable for configuration files.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/api/file-types.mdx#_snippet_5

LANGUAGE: TOML
CODE:
```
string = "abc"
bool = true
array = [1, 2, 3]

[object]
int = 1337
float = 4.2
```

LANGUAGE: Lua
CODE:
```
return {
	["string"] = "abc",
	["bool"] = true,
	["array"] = {1, 2, 3},
	["object"] = {
		["int"] = 1337,
		["float"] = 4.2,
	}
}
```

----------------------------------------

TITLE: ts_mode Configuration
DESCRIPTION: Whether to use roblox-ts by default when creating, serving or building any project.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/configuration.mdx#_snippet_12

LANGUAGE: APIDOC
CODE:
```
ts_mode: boolean (default: false)
  Description: Whether to use roblox-ts by default when creating, serving or building any project.
```

----------------------------------------

TITLE: VS Code Command: Sourcemap
DESCRIPTION: Generates a JSON sourcemap of the project, which is highly useful for Luau LSP. It can watch for changes and include non-script files.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/vscode.mdx#_snippet_2

LANGUAGE: APIDOC
CODE:
```
Sourcemap:
  Description: Generate JSON sourcemap of the project. Very useful when using Luau LSP.
  Arguments:
    project: project to generate sourcemap of
    output: name of the output file (sourcemap is recommended)
  Options:
    Watch for changes: Whether to regenerate sourcemap every time files change
    Include non-scripts: Whether non-script files should be included in the sourcemap
```

----------------------------------------

TITLE: Argon Project File JSON Schema
DESCRIPTION: Defines the structure and fields for Argon project configuration files (.project.json), controlling instance tree generation and file processing. It includes settings for server hosting, client syncing, file exclusion, and custom processing rules.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/api/project.mdx#_snippet_0

LANGUAGE: APIDOC
CODE:
```
Project File Schema:
  name: string
    Default: "default"
    Description: The name of the project, displayed by Argon. Hot-reloaded.
  tree: Instance Description
    Required: true
    Description: An Instance Description describing the root instance of the project. Hot-reloaded.
  host: string
    Default: "localhost"
    Description: The host name that Argon server should be running on.
  port: number
    Default: 8000
    Description: The port number that Argon server should be running on.
  gameId: string | null
    Default: null
    Description: Limit Argon clients to only sync with this project when the game ID matches. Hot-reloaded.
  placeIds: string[]
    Default: []
    Description: Limit Argon clients to only sync with this project when one of the place IDs matches. Hot-reloaded.
  ignoreGlobs: string[]
    Default: []
    Description: Exclude files that match any of these globs from processing and syncing.
  syncRules: Sync Rule[]
    Default: []
    Description: Custom set of user-defined Sync Rules that define how files should be processed.
  syncback: Syncback Settings | null
    Default: null
    Description: Syncback Settings that control how instances are synced back to the file system.
  legacyScripts: boolean
    Default: true
    Description: Use the legacy script run context.

Rojo Compatibility:
  serveAddress maps to host
  servePort maps to port
  servePlaceIds maps to placeIds
  globIgnorePaths maps to ignoreGlobs
  emitLegacyScripts maps to legacyScripts
```

----------------------------------------

TITLE: Argon Instance Description JSON Schema
DESCRIPTION: Defines the structure for describing individual Roblox Instances within an Argon project, including their class name, associated file path, and properties. It also specifies how unknown instances are handled and how nested instances are defined.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/api/project.mdx#_snippet_1

LANGUAGE: APIDOC
CODE:
```
Instance Description Schema:
  $className: string
    Description: The ClassName of the Instance being described.
  $path: string
    Description: The path on the filesystem that should be the source of this instance.
  $properties: object
    Description: Properties to apply to the instance.
  $keepUnknowns: boolean
    Description: Whether instances that Argon doesn't know about should be deleted.
  Other fields: object
    Description: All other fields in an Instance Description are turned into instances whose name is the key, with values being nested Instance Descriptions.

Constraints:
  Cannot set both $className and $path at the same time.
```

----------------------------------------

TITLE: Define Sync Rule Configuration Fields
DESCRIPTION: Describes the fields available for defining a Sync Rule, which dictates how specific files are interpreted and mapped to instance names within an Argon project. It covers file type, glob patterns for matching and exclusion, and suffix stripping for instance naming.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/api/project.mdx#_snippet_2

LANGUAGE: APIDOC
CODE:
```
Field | Description
type | The type of file this rule applies to, valid options are: Project, InstanceData, ServerScript, ClientScript, ModuleScript, StringValue, RichStringValue, LocalizationTable, JsonModule, TomlModule, YamlModule, MsgpackModule, JsonModel, RbxmModel, RbxmxModel
pattern | A glob pattern that matches the file path
childPattern | A glob pattern that matches folder-contained file path
exclude | A list of glob patterns that exclude the file path from this rule
suffix | A suffix to stripe from the file path to get the instance name
```

----------------------------------------

TITLE: Argon Workspace Configuration
DESCRIPTION: Explains how workspace-level configuration overrides global settings by creating an `argon.toml` file in the project root. It also notes the conditions under which Argon can load the workspace config.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/configuration.mdx#_snippet_14

LANGUAGE: APIDOC
CODE:
```
Workspace Config:
  Behavior: Works exactly the same as the Global Config but is specified at workspace level.
  Initialization: Create 'argon.toml' file in the root of your project (right next to the Project File).
  Override: If workspace config exists, it will override the global one.
  Loading Conditions:
    Argon will only be able to load workspace config if it exists in the current working directory or parent directory of the 'PROJECT' argument.
    Applies to: 'init', 'serve', 'build', and 'sourcemap' commands.
```

----------------------------------------

TITLE: Generate Argon Sourcemap
DESCRIPTION: Generates a JSON sourcemap of the project, which is very useful when using Luau LSP. This command supports optional project and session arguments. Options allow specifying the output path, enabling watch mode for regeneration on file changes, including non-script files, and running Argon asynchronously (requires watch mode).

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/cli.mdx#_snippet_6

LANGUAGE: bash
CODE:
```
argon sourcemap [project] [session] --options
```

----------------------------------------

TITLE: Execute Luau Code in Roblox Studio
DESCRIPTION: Executes Luau code directly within Roblox Studio, requiring an active Live Sync session. The code can be provided as a string or a path to a file. An optional session name can be specified to target a particular session, defaulting to the last one. Options include focusing the Roblox Studio window, running the code as a separate process, and targeting a session by host or port.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/cli.mdx#_snippet_10

LANGUAGE: bash
CODE:
```
argon exec [code] [session] --options
```

----------------------------------------

TITLE: Create Localization Table from CSV
DESCRIPTION: Details how `.csv` files are transformed into a `LocalizationTable` instance, requiring adherence to a specific Roblox CSV format for localization data.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/api/file-types.mdx#_snippet_9

LANGUAGE: CSV
CODE:
```
Key,Source,Context,Example,pl
Wow,Wow!,,An expression of surprise,Łał!
```

----------------------------------------

TITLE: Define Roblox Instances with JSON Model
DESCRIPTION: Describes how `.model.json` files are used to define single complex instances or multiple instances, specifying their ClassName, Properties, and Children.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/api/file-types.mdx#_snippet_3

LANGUAGE: JSON
CODE:
```
{
  "ClassName": "Part",
  "Properties": {
    "Size": [2, 2, 2]
  },
  "Children": [
    {
      "Name": "Input",
      "ClassName": "ClickDetector"
    },
    {
      "Name": "Send",
      "ClassName": "RemoteEvent"
    }
  ]
}
```

----------------------------------------

TITLE: QDir Property Type Support
DESCRIPTION: Details the support for the 'QDir' property type, exemplified by `Studio.Auto-Save Path`, across various Argon Roblox data formats.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/src/components/PropertyCoverage.md#_snippet_39

LANGUAGE: APIDOC
CODE:
```
PropertyType: QDir
ExampleProperty: Studio.Auto-Save Path
Support:
  CLI: Never
  Plugin: Never
  XML: Never
  Binary: Never
```

----------------------------------------

TITLE: Process Plain Text Files
DESCRIPTION: Explains that any file with the `.txt` extension is transformed into a `StringValue` instance, with its `Value` property set directly to the file's contents.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/api/file-types.mdx#_snippet_8

LANGUAGE: Plain Text
CODE:
```
Hello world!
```

----------------------------------------

TITLE: Configure Argon CLI Settings
DESCRIPTION: Allows users to edit global or workspace configuration settings for Argon directly from the command line. It supports specifying a setting name and a new value, or using options to list all available settings or restore them to their default values.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/cli.mdx#_snippet_13

LANGUAGE: bash
CODE:
```
argon config [setting] [value] --options
```

----------------------------------------

TITLE: scan_ports Configuration
DESCRIPTION: When enabled Argon will scan for the first available port if selected one is already in use.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/configuration.mdx#_snippet_2

LANGUAGE: APIDOC
CODE:
```
scan_ports: boolean (default: true)
  Description: When enabled Argon will scan for the first available port if selected one is already in use.
```

----------------------------------------

TITLE: update_templates Configuration
DESCRIPTION: Whether to update default project templates when new ones are available and check_updates setting is enabled.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/configuration.mdx#_snippet_10

LANGUAGE: APIDOC
CODE:
```
update_templates: boolean (default: true)
  Description: Whether to update default project templates when new ones are available and check_updates setting is enabled.
```

----------------------------------------

TITLE: Argon .meta.json Data File Specification
DESCRIPTION: Defines the structure and available properties for `.meta.json` files, which configure `Folder` instances in Argon projects. These files specify class names, instance properties, and handling of unknown children.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/api/file-types.mdx#_snippet_10

LANGUAGE: APIDOC
CODE:
```
.meta.json File Structure:
  className: string
    description: Sets the ClassName of a containing Folder instance.
  properties: object
    description: A map of properties to apply on the instance.
  keepUnknowns: boolean
    description: Whether children that Argon doesn't know about should be deleted.
```

----------------------------------------

TITLE: Convert JSON to Lua ModuleScript
DESCRIPTION: Explains how generic `.json` files (not models, projects, or data files) are transformed into a `ModuleScript` that returns a Lua table representing the JSON structure. This is useful for storing bulk data like asset IDs.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/api/file-types.mdx#_snippet_4

LANGUAGE: JSON
CODE:
```
{
  "string": "abc",
  "bool": true,
  "array": [1, 2, 3],
  "object": {
    "int": 1337,
    "float": 4.2
  }
}
```

LANGUAGE: Lua
CODE:
```
return {
	["string"] = "abc",
	["bool"] = true,
	["array"] = {1, 2, 3},
	["object"] = {
		["int"] = 1337,
		["float"] = 4.2,
	}
}
```

----------------------------------------

TITLE: Update Argon Components
DESCRIPTION: Manually checks for and updates Argon components if newer versions are available. The update mode can be specified as `cli`, `plugin`, `templates`, or `all` (which is the default). A `--force` option is available to compel an update even if no newer version is detected.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/cli.mdx#_snippet_11

LANGUAGE: bash
CODE:
```
argon update [mode] --options
```

----------------------------------------

TITLE: QFont Property Type Support
DESCRIPTION: Details the support for the 'QFont' property type, exemplified by `Studio.Font`, across various Argon Roblox data formats.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/src/components/PropertyCoverage.md#_snippet_40

LANGUAGE: APIDOC
CODE:
```
PropertyType: QFont
ExampleProperty: Studio.Font
Support:
  CLI: Never
  Plugin: Never
  XML: Never
  Binary: Never
```

----------------------------------------

TITLE: rojo_mode Configuration
DESCRIPTION: When enabled Argon will use Rojo namespace by default when creating a new project.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/configuration.mdx#_snippet_11

LANGUAGE: APIDOC
CODE:
```
rojo_mode: boolean (default: true)
  Description: When enabled Argon will use Rojo namespace by default when creating a new project.
```

----------------------------------------

TITLE: Convert Markdown to Roblox Rich Text
DESCRIPTION: Describes how `.md` files are transformed into a `StringValue` instance, with Markdown content translated into Roblox Rich Text Markup for display within the engine.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/api/file-types.mdx#_snippet_7

LANGUAGE: Markdown
CODE:
```
# Heading

> Block quote

- Unordered list item A
- Unordered list item B

1. Ordered list item A
2. Ordered list item B

Some **Bold** text, with addition of _italic_ and `code`
```

LANGUAGE: Roblox Rich Text Markup
CODE:
```
<b>Heading</b>

<i>Block quote</i>

<b>•</b> Unordered list item A
<b>•</b> Unordered list item B

1. Ordered list item A
2. Ordered list item B

Some <b>Bold</b> text, with addition of <i>italic</i> and <font family='rbxasset://fonts/families/RobotoMono.json'>code</font>
```

----------------------------------------

TITLE: VS Code Command: Update
DESCRIPTION: Forcefully checks for and applies updates to Argon components, including CLI, Plugin, and Templates.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/docs/commands/vscode.mdx#_snippet_9

LANGUAGE: APIDOC
CODE:
```
Update:
  Description: Forcefully check for updates and update Argon components if available.
  Modes:
    CLI: Update Argon CLI only
    Plugin: Update Argon Roblox Studio plugin only
    Templates: Update project templates only
    All: Update all above Argon components
```

----------------------------------------

TITLE: PhysicalProperties Data Format
DESCRIPTION: Describes the JSON format for PhysicalProperties. Both implicit and explicit values can be the string 'Default' or an object with 'density', 'friction', 'elasticity', 'frictionWeight', and 'elasticityWeight' fields.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/api/properties.mdx#_snippet_21

LANGUAGE: json
CODE:
```
{
  "$properties": {
    "Implicit1": "Default",
    "Implicit2": {
      "density": 0.5,
      "friction": 1.0,
      "elasticity": 0.0,
      "frictionWeight": 50.0,
      "elasticityWeight": 25.0
    },
    "Explicit1": { "PhysicalProperties": "Default" },
    "Explicit2": {
      "PhysicalProperties": {
        "density": 0.5,
        "friction": 1.0,
        "elasticity": 0.0,
        "frictionWeight": 50.0,
        "elasticityWeight": 25.0
      }
    }
  }
}
```

----------------------------------------

TITLE: SecurityCapabilities Property Type Support
DESCRIPTION: Details the support for the 'SecurityCapabilities' property type, exemplified by `Folder.SecurityCapabilities`, across various Argon Roblox data formats.

SOURCE: https://github.com/argon-rbx/argon-wiki/blob/main/src/components/PropertyCoverage.md#_snippet_29

LANGUAGE: APIDOC
CODE:
```
PropertyType: SecurityCapabilities
ExampleProperty: Folder.SecurityCapabilities
Support:
  CLI: Implemented
  Plugin: Unimplemented
  XML: Implemented
  Binary: Implemented
```