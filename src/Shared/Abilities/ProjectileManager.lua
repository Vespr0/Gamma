local ProjectileManager = {}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

-- Constants
local GRAVITY_FACTOR = 1
local IS_SERVER = RunService:IsServer()

-- Modules
local AssetsDealer = require(ReplicatedStorage.AssetsDealer)
local Game = require(ReplicatedStorage.Utility.Game)

-- Remotes
local Remotes = ReplicatedStorage.Remotes

--local ServerModules 
local ExplosionModule 

--[[
local function TweenVisualProjectile(Object,Direction)
	local Info = TweenInfo.new(.5,Enum.EasingStyle.Linear)
	local Tween = TweenService:Create(Object,Info,{Size = Object.Size*3,Transparency = 1,Position = Object.Position+Direction})
	Tween:Play()
	wait(.2)
	Object:Destroy()
end]]

-- Helper Functions
local function TweenProjectile(Object, MySize, Time)
	local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear)
	local Tween = TweenService:Create(Object, Info, {Size = MySize, Transparency = 1})
	Tween:Play()
end

local function TweenCFrame(Part, Time, Value)
	local TweenInfo = TweenInfo.new(Time, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
	local Tween = TweenService:Create(Part, TweenInfo, {CFrame = Value})
	Tween:Play()
end

local function TweenPosition(Part, Time, Value)
	task.spawn(function()
		local TweenInfo = TweenInfo.new(Time, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
		local Tween = TweenService:Create(Part, TweenInfo, {Position = Value})
		Tween:Play()
	end)
end 

-- Main Functions
function ProjectileManager.Dynamic(args)
	--[[ 
     	The arguments can either be a table or a module, if they are a module it means it's directlly referring to
     	the stats of a tool, witch specify certain variables with the keyword "Projectile", we need to convert the keys
     	of the dictionary to reflect the appropiate argument names.
	--]]
	-- if toolArgs then
	-- 	local rawToolArgs = require(toolArgs)

	-- 	args["Amplitude"] = rawToolArgs["ProjectileAmplitude"]
	-- 	args["Speed"] = rawToolArgs["ProjectileSpeed"]
	-- 	args["Gravity"] = rawToolArgs["ProjectileGravity"]
	-- 	args["Bounces"] = rawToolArgs["ProjectileBounces"]

	-- 	args["CustomMesh"] = rawToolArgs["ProjectileCustomMesh"]

	-- 	args["IsExplosive"] = rawToolArgs["IsProjectileExplosive"]
	-- 	args["ExplosionRadius"] = rawToolArgs["ProjectileExplosionRadius"]
	-- 	args["ExplosionForce"] = rawToolArgs["ProjectileExplosionForce"]

	-- 	args["ClientStepEvent"] = rawToolArgs["ClientProjectileStepEvent"]
	-- 	args["ClientBounceEvent"] = rawToolArgs["ClientProjectileBounceEvent"]
	-- end
	args.Amplitude = args.Amplitude or 40
	args.Bounces = args.Bounces or 0
	args.Range = args.Range or 1000
	args.Speed = args.Speed or 200
	args.Thickness = args.Thickness or 0.1
	local gravity = args.Amplitude / args.Speed * GRAVITY_FACTOR
	local stepTime = args.Amplitude / args.Speed
	local bounces = args.Bounces

	-- Client replication.
	if IS_SERVER then
		for _,player in pairs(Players:GetChildren()) do
			if not args.ClientReplicationBlacklist or not table.find(args.ClientReplicationBlacklist,player.UserId) then
				Remotes.Projectile:FireClient(player,args)
			end
		end	
	end

	local projectile 
	local debugbeam

	local CurrentPosition = args.Origin 
	local CurrentDirection = (args.Direction.Unit)*args.Amplitude

	-- Projectile visuals setup
	if not IS_SERVER then
		if args.CustomProjectile then
			projectile = AssetsDealer.GetDir("Meshes",args.CustomProjectile,"Clone")
		else
			projectile = Instance.new("Part")
			projectile.Color = args.Color or Color3.fromRGB(255, 245, 96)
			projectile.Transparency = 1
			projectile.Material = Enum.Material.Neon
			projectile.Size = Vector3.new(args.Thickness,args.Thickness,CurrentDirection.Magnitude)
			local TransparencyTween = TweenService:Create(projectile,TweenInfo.new(3),{Transparency = .5})
			TransparencyTween:Play()
		end
		projectile.Parent = Game.Folders.Projectiles
		projectile.Anchored = true
		projectile.CanCollide = false
		projectile.CFrame = CFrame.lookAt(CurrentPosition,CurrentPosition+CurrentDirection)
		-- if args["Particle"] then
		-- 	local particle = AssetsDealer.GetParticle(args["Particle"])
		-- 	particle.Parent = projectile
		-- 	particle.Enabled = true
		-- 	particle.Rate = 30
		-- end
	else
		projectile = Instance.new("Part"); projectile.Parent = Game.Folders.Projectiles
		projectile.Anchored = true
		projectile.CanCollide = false
		projectile.Transparency = .5
		projectile.CFrame = CFrame.lookAt(CurrentPosition+CurrentDirection/2,CurrentPosition+CurrentDirection)
		projectile.Size = Vector3.new(.3,.3,args.Amplitude)
		projectile.Color = Color3.new(1, 0, 0)
		projectile.Material = Enum.Material.Neon
	end

	local function Step()
		local RayInfo = RaycastParams.new()
		RayInfo.FilterType = Enum.RaycastFilterType.Exclude
		args.RaycastBlacklist = args.RaycastBlacklist or {}
		table.insert(args.RaycastBlacklist,workspace.Nodes)
		RayInfo.FilterDescendantsInstances = args.RaycastBlacklist
		RayInfo.IgnoreWater = true
		--local CenterPoint = CurrentPosition + CurrentDirection/2

		-- Apply gravity before casting the ray.

		local Raycast = workspace:Raycast(CurrentPosition,CurrentDirection,RayInfo)

		--local bounced = false

		local function bounce()
			if not IS_SERVER then
				if args.ClientBounceEvent then
					args.ClientBounceEvent(stepTime,projectile)
				end
			end	
			CurrentDirection = (CurrentDirection - (2 * CurrentDirection:Dot(Raycast.Normal) * Raycast.Normal)).Unit * CurrentDirection.Magnitude
			bounces -= 1
		end

		local function explode()
			-- TODO
			--ExplosionModule.Ignite(Raycast.Position-CurrentDirection.Unit,args["ExplosionRadius"],args["ExplosionForce"],args["Team"])
		end

		if Raycast then
			if IS_SERVER then
				local instance = Raycast.Instance
				if instance then
					-- local isGlass = instance.Material == Enum.Material.Ice and instance.Transparency > 0
					-- if isGlass then
					-- 	Remotes.FX:FireAllClients("GlassShatter",{Position = Raycast.Position,Instance = instance})
					-- 	instance.Transparency = 1
					-- 	instance.CanCollide = false
					-- end
					-- local model = instance.Parent
					-- local humanoid = model:FindFirstChild("Humanoid")
					for _,Entity in pairs(workspace.Entities:GetChildren()) do
						local team = Entity:GetAttribute("Team")
						if Entity:FindFirstChild("Humanoid") and team then
							if instance:IsDescendantOf(Entity) then
								if args.IsExplosive then
									explode()
								end
								local isTeammate = team ~= "None" and team == args.Team 
								return {["Position"]=Raycast.Position,["Normal"]=Raycast.Normal,["Instance"]=instance,["Entity"]=Entity,["IsTeammate"] = isTeammate}
							end					
						end
					end 
					if bounces > 0 then
						bounce()
					else
						if args.IsExplosive then
							explode()
						end
						return {["Position"]=Raycast.Position,["Instance"]=instance,["Normal"]=Raycast.Normal}
					end
				else
					if bounces > 0 then
						bounce()
					else
						if args.IsExplosive then
							explode()
						end
						return {["Position"]=Raycast.Position,["Normal"]=Raycast.Normal}
					end
				end			
			else
				if bounces > 0 then
					bounce()
				else
				
					return {["Position"]=Raycast.Position,["Instance"] = Raycast.Instance,["Normal"]=Raycast.Normal}
				end
			end
		end	

		--if not bounced then
		CurrentPosition += CurrentDirection--*CFrame.lookAt(CurrentPosition,TargetRoot.Position).LookVector
		CurrentDirection -= Vector3.new(0,gravity,0)
		--end

		if not IS_SERVER then
			if args.ClientStepEvent then
				args.ClientStepEvent(stepTime,projectile)
			end
		end
		local Cframe = CFrame.lookAt(CurrentPosition,CurrentPosition+CurrentDirection)
		TweenCFrame(projectile,stepTime,Cframe)
		task.wait(stepTime)

		stepFinished = true

		return false
	end

	for i = 1,args.Range/args.Amplitude do
		local func = Step()
		if func then
			CurrentDirection -= Vector3.new(0,gravity,0)
			CurrentPosition += CurrentDirection
			if not IS_SERVER then
				local FinalStepLenght = args.Amplitude/2
				local FinalStepTime = stepTime*(FinalStepLenght/args.Amplitude)				
				local Cframe = CFrame.lookAt(CurrentPosition,CurrentPosition+(CurrentDirection*FinalStepLenght))
				TweenCFrame(projectile,FinalStepTime,Cframe)
				if not args.CustomProjectile then
					projectile.Size = Vector3.new(args.Thickness,args.Thickness,FinalStepLenght)
				end
				task.wait(FinalStepTime)
				projectile:Destroy()					
			end
			return func
		end
	end

	if not IS_SERVER then
		projectile:Destroy()			
	end
	return "Expired"
end

function ProjectileManager.Init()
	if not IS_SERVER then
		Remotes.Projectile.OnClientEvent:Connect(function(args)
			ProjectileManager.Dynamic(args)
		end)
	end
end

return ProjectileManager
