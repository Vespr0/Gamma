local Loading = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

function Loading.LoadAssetsDealer()
	require(ReplicatedStorage.AssetsDealer).Init()
end

Loading.Initialized = {}

function Loading.LoadModules(folder,blacklist)
	local descendants = folder:GetDescendants()
	local modules = {}

	-- Get all modules in the folder
	for _,d in descendants do
		if not d:IsA("ModuleScript") or (blacklist and table.find(blacklist, d)) then continue end

		table.insert(modules,d)
	end

	for _,module in modules do
		local _,err = pcall(function()
			-- Require the module and look for the Init function.
			print(`⌛ Loading "{module.Name}" module`)
			local required = require(module)

			-- Ignore modules that return other stuff, like a single function
			if typeof(required) ~= "table" then return end

			-- Check if the module depends on other modules, if so, put it at the bottom of the queue
			if required.Dependencies then
				for _,d in required.Dependencies do
					if not Loading.Initialized[d] then
						print(`{module.Name} depends on {d}, putting it at the bottom of the queue`)
						table.insert(modules,module)
						return
					end
				end
			end

			-- Make sure the module doesn't return other stuff, like a single function
			if typeof(required) ~= "table" then return end

			if required.Init then
				-- Initiliaze the module.
				required.Init()
				Loading.Initialized[module.Name] = true

				print(`✅ Initialized "{module.Name}" module`)
			end
		end)
		
		if err then
			error(`❌ Module "{module.Name}" could not be loaded: {err}`)
		end
	end
end

return Loading