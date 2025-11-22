-- This component is responsible for creating and managing the visual
-- representation of a projectile on the client.
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ProjectileTypes = require(script.Parent.GammaCast.ProjectileTypes)
local Game = require(ReplicatedStorage.Utility.Game)

local ClientProjectileVisuals = {}
ClientProjectileVisuals.__index = ClientProjectileVisuals

function ClientProjectileVisuals.new()
	if RunService:IsServer() then
		warn("ClientProjectileVisuals is a client-only component")
		return
	end
	
	return setmetatable({}, ClientProjectileVisuals)
end

function ClientProjectileVisuals:play(simulation: any)
	-- For hitscan, we just draw a single beam and destroy it.
	if simulation.hitscan then
		local result = simulation:start()
		if result and result.Position then
			local config = (ProjectileTypes :: any)[simulation.typeName] or ProjectileTypes.Default
			local thickness = config.thickness or 0.2
			local color = config.color or Color3.new(1, 1, 0)
			local material = config.material or Enum.Material.Neon

			local visualBeam = Instance.new("Part")
			visualBeam.Material = material
			visualBeam.Color = color
			visualBeam.Anchored = true
			visualBeam.CanCollide = false
			visualBeam.CanQuery = false
			visualBeam.Name = "VisualBeam"
			visualBeam.Parent = Game.Folders.Projectiles

			local moveVec = result.Position - simulation.origin
			visualBeam.Size = Vector3.new(thickness, thickness, moveVec.Magnitude)
			visualBeam.CFrame = CFrame.lookAt(simulation.origin, result.Position)
				* CFrame.new(0, 0, -moveVec.Magnitude / 2)
			Debris:AddItem(visualBeam, 0.5)
		end
		return
	end

	-- For traveling projectiles, we create a part and update it each frame.
	task.spawn(function()
		local config = (ProjectileTypes :: any)[simulation.typeName] or ProjectileTypes.Default
		local thickness = config.thickness or 0.3
		local color = config.color or Color3.fromRGB(255, 0, 255)
		local material = config.material or Enum.Material.SmoothPlastic

		local visualPart = Instance.new("Part")
		visualPart.Anchored = true
		visualPart.CanCollide = false
		visualPart.CanQuery = false
		visualPart.Name = "VisualProjectile"
		visualPart.Material = material
		visualPart.Color = color
		-- The size will be updated each frame to represent the trail
		visualPart.Parent = Game.Folders.Projectiles

		while simulation.traveled < simulation.range do
			local startTime = os.clock()
			local lastPosition = simulation.position
			local result = simulation:step()
			simulation.elapsedTime = os.clock() - startTime

			if not result and simulation.position then
				-- No hit, update the visual trail
				local moveVec = simulation.position - lastPosition
				if moveVec.Magnitude > 0 then
					visualPart.Size = Vector3.new(thickness, thickness, moveVec.Magnitude)
					visualPart.CFrame = CFrame.lookAt(lastPosition, simulation.position)
						* CFrame.new(0, 0, -moveVec.Magnitude / 2)
				end
			else
				-- A hit occurred, or something went wrong. Stop the loop.
				break
			end

			local sleepTime = math.max(0, simulation.timeStep - simulation.elapsedTime)
			task.wait(sleepTime)
		end

		-- Clean up the visual part
		if visualPart then
			Debris:AddItem(visualPart, 0.1)
		end
	end)
end

return ClientProjectileVisuals
