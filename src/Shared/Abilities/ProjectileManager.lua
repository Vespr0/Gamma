local ProjectileManager = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Remotes = ReplicatedStorage.Remotes

local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

--local ServerModules 
local ExplosionModule 

local IsServer = RunService:IsServer()
if IsServer then
	--ServerModules = ServerScriptService.Modules
	--ExplosionModule = require(ServerModules.Entities.ExplosionModule)
end
local AssetsDealer = require(ReplicatedStorage.AssetsDealer)
local Game = require(ReplicatedStorage.Utility.Game)
--[[
local function TweenVisualProjectile(Object,Direction)
	local Info = TweenInfo.new(.5,Enum.EasingStyle.Linear)
	local Tween = TweenService:Create(Object,Info,{Size = Object.Size*3,Transparency = 1,Position = Object.Position+Direction})
	Tween:Play()
	wait(.2)
	Object:Destroy()
end]]

local function TweenProjectile(Object,MySize,Time)
	local Info = TweenInfo.new(Time,Enum.EasingStyle.Linear)
	local Tween = TweenService:Create(Object,Info,{Size = MySize,Transparency = 1})
	Tween:Play()
end

local function TweenCFrame(Part,Time,Value)
	local TweenInfo = TweenInfo.new(Time,Enum.EasingStyle.Linear,Enum.EasingDirection.In)
	local Tween = TweenService:Create(Part,TweenInfo,{CFrame = Value})
	Tween:Play()
end


local function TweenPosition(Part,Time,Value)
	task.spawn(function()
		local TweenInfo = TweenInfo.new(Time,Enum.EasingStyle.Linear,Enum.EasingDirection.In)
		local Tween = TweenService:Create(Part,TweenInfo,{Position = Value})
		Tween:Play()
	end)
end 

-- function ProjectileManager.Generic(Origin:Vector3,Direction:Vector3,Character:Instance,Color:Color3,Thickness:number)
-- 	Color = Color or Color3.fromRGB(255, 214, 66)
-- 	Thickness = Thickness or .1

-- 	local RayInfo = RaycastParams.new()
-- 	RayInfo.FilterType = Enum.RaycastFilterType.Exclude
-- 	RayInfo.FilterDescendantsInstances = {Character,workspace.Nodes}

-- 	local ProjectileRay = workspace:Raycast(Origin,Direction,RayInfo)

-- 	local function CastProjectile(hit)
-- 		local XDirection
-- 		if hit then
-- 			XDirection = Direction.Unit*((Origin-ProjectileRay.Position).magnitude)
-- 		else
-- 			XDirection = Direction
-- 		end
-- 		local CenterPoint = Origin + XDirection/2
-- 		local beam = Instance.new("Part",workspace.Nodes.FX)
-- 		beam.Anchored = true
-- 		beam.CanCollide = false
-- 		beam.Color = Color
-- 		beam.Transparency = .5

-- 		beam.CFrame = CFrame.new(CenterPoint,Origin)
-- 		beam.Size = Vector3.new(Thickness,Thickness,XDirection.magnitude)
-- 		TweenProjectile(beam,Vector3.new(beam.Size.X/4,beam.Size.Y/4,beam.Size.Z),.2)
-- 		Debris:AddItem(beam,.1)
-- 	end

-- 	if ProjectileRay then
-- 		CastProjectile(true)
-- 		local instance = ProjectileRay.Instance
-- 		if instance then
-- 			local Model = instance.Parent
-- 			if not Model:FindFirstChild("Team") then
-- 				return
-- 			end
-- 			for _,Entity in pairs(workspace.Entities:GetChildren()) do
-- 				if Entity:FindFirstChild("Humanoid") and Entity:FindFirstChild("Team") then
-- 					if instance:IsDescendantOf(Entity) then
-- 						return {[1]=instance,[2]=Entity,[3]=ProjectileRay.Position}
-- 					end					
-- 				end
-- 			end
-- 			return {[1]=ProjectileRay.Position,[2]=instance,[3]=ProjectileRay.Normal}
-- 		end
-- 	else
-- 		CastProjectile(false)
-- 	end
-- end

function ProjectileManager.Dynamic(args--[[,toolArgs]])

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
	args["Amplitude"] = args["Amplitude"] or 20
	args["Gravity"] = args["Gravity"] or 0.1
	args["Bounces"] = args["Bounces"] or 0
	args["Range"] = args["Range"] or 1000
	args["Speed"] = args["Speed"] or 200
	args["Thickness"] = args["Thickness"] or 0.1
	local bounces = args["Bounces"]

	-- Client replication.
	if IsServer then
		for _,player in pairs(Players:GetChildren()) do
			--if not Args["ClientReplicationBlacklist"] or not table.find(Args["ClientReplicationBlacklist"],player.UserId) then

			-- Remember that functions cannot be passed trough remote events (no ClientStepFunction, ClientBounceFunction ecc.)
			Remotes.Projectile:FireClient(player,args--[[,toolargs]])


			--end
		end	
	end

	local stepTime = args["Amplitude"]/args["Speed"]
	-- local stepFinished = false

	local projectile 
	local debugbeam

	local CurrentPosition = args["StartingPosition"] 
	local CurrentDirection = (args["Direction"].Unit)*args["Amplitude"]

	-- Projectile visuals setup
	if not IsServer then
		if args["CustomMesh"] then
			-- projectile = AssetsDealer.GetMesh(args["CustomMesh"])
		else
			projectile = Instance.new("Part")
			projectile.Color = args["Color"] or Color3.fromRGB(255, 245, 96)
			projectile.Transparency = 1
			projectile.Material = Enum.Material.Neon
			projectile.Size = Vector3.new(args["Thickness"],args["Thickness"],CurrentDirection.Magnitude)
			local TransparencyTween = TweenService:Create(projectile,TweenInfo.new(3),{Transparency = .5})
			TransparencyTween:Play()
		end
		projectile.Parent = Game.Folders.Debug
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
		projectile = Instance.new("Part"); projectile.Parent = Game.Folders.Debug
		projectile.Anchored = true
		projectile.CanCollide = false
		projectile.Transparency = .5
		projectile.CFrame = CFrame.lookAt(CurrentPosition+CurrentDirection/2,CurrentPosition+CurrentDirection)
		projectile.Size = Vector3.new(.3,.3,args["Amplitude"])
		projectile.Color = Color3.new(1, 0, 0)
		projectile.Material = Enum.Material.Neon
	end

	local function Step()
		local RayInfo = RaycastParams.new()
		RayInfo.FilterType = Enum.RaycastFilterType.Exclude
		RayInfo.FilterDescendantsInstances = args["RaycastBlacklist"] or {workspace.Nodes}
		RayInfo.IgnoreWater = true
		--local CenterPoint = CurrentPosition + CurrentDirection/2

		-- Apply gravity before casting the ray.

		local Raycast = workspace:Raycast(CurrentPosition,CurrentDirection,RayInfo)

		--local bounced = false

		local function bounce()
			-- Boing!
			--bounced = true
			if not IsServer then
				print(args["ClientBounceEvent"])
				if args["ClientBounceEvent"] then
					args["ClientBounceEvent"](stepTime,projectile)
				end
			end	
			CurrentDirection = (CurrentDirection - (2 * CurrentDirection:Dot(Raycast.Normal) * Raycast.Normal)).Unit * CurrentDirection.Magnitude
			--CurrentPosition += CurrentDirection
			bounces -= 1
		end

		local function explode()
			-- Kaboom!
			--ExplosionModule.Ignite(Raycast.Position-CurrentDirection.Unit,args["ExplosionRadius"],args["ExplosionForce"],args["Team"])
		end

		if Raycast then
			if IsServer then
				local instance = Raycast.Instance
				if instance then
					local isGlass = instance.Material == Enum.Material.Ice and instance.Transparency > 0
					if isGlass then
						Remotes.FX:FireAllClients("GlassShatter",{Position = Raycast.Position,Instance = instance})
						instance.Transparency = 1
						instance.CanCollide = false
					end
					-- local model = instance.Parent
					-- local humanoid = model:FindFirstChild("Humanoid")
					for _,Entity in pairs(workspace.Entities:GetChildren()) do
						local team = Entity:GetAttribute("Team")
						if Entity:FindFirstChild("Humanoid") and team then
							if instance:IsDescendantOf(Entity) then
								if args["IsExplosive"] then
									explode()
								end
								local isTeammate = team ~= "None" and team == args["Team"] 
								return {["Position"]=Raycast.Position,["Normal"]=Raycast.Normal,["Instance"]=instance,["Entity"]=Entity,["IsTeammate"] = isTeammate}
							end					
						end
					end 
					if bounces > 0 then
						bounce()
					else
						if args["IsExplosive"] then
							explode()
						end
						return {["Position"]=Raycast.Position,["Instance"]=instance,["Normal"]=Raycast.Normal}
					end
				else
					if bounces > 0 then
						bounce()
					else
						if args["IsExplosive"] then
							explode()
						end
						return {["Position"]=Raycast.Position,["Normal"]=Raycast.Normal}
					end
				end			
			else
				if bounces > 0 then
					bounce()
				else
					return {["Position"]=Raycast.Position,["Normal"]=Raycast.Normal}
				end
			end
		end	

		--if not bounced then
		CurrentPosition += CurrentDirection--*CFrame.lookAt(CurrentPosition,TargetRoot.Position).LookVector
		CurrentDirection -= Vector3.new(0,args["Gravity"],0)
		--end

		if not IsServer then
			if args["ClientStepEvent"] then
				args["ClientStepEvent"](stepTime,projectile)
			end
		end
		local Cframe = CFrame.lookAt(CurrentPosition,CurrentPosition+CurrentDirection)
		TweenCFrame(projectile,stepTime,Cframe)
		task.wait(stepTime)

		stepFinished = true

		return false
	end

	for i = 1,args["Range"]/args["Amplitude"] do
		local func = Step()
		if func then
			CurrentDirection -= Vector3.new(0,args["Gravity"],0)
			CurrentPosition += CurrentDirection
			if not IsServer then
				local FinalStepLenght = args["Amplitude"]/2
				local FinalStepTime = stepTime*(FinalStepLenght/args["Amplitude"])				
				local Cframe = CFrame.lookAt(CurrentPosition,CurrentPosition+(CurrentDirection*FinalStepLenght))
				TweenCFrame(projectile,FinalStepTime,Cframe)
				projectile.Size = Vector3.new(args["Thickness"],args["Thickness"],FinalStepLenght)
				task.wait(FinalStepTime)
				projectile:Destroy()					
			end
			return func
		end
	end

	if not IsServer then
		projectile:Destroy()			
	end
	return "Expired"
end

function ProjectileManager.Init()
	if not IsServer then
		Remotes.Projectile.OnClientEvent:Connect(function(args--[[,toolArgs]])
			ProjectileManager.Dynamic(args--[[,toolArgs]])
		end)
	end
end

return ProjectileManager
