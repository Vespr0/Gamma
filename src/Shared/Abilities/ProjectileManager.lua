local ProjectileManager = {}

-- Services
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Constants
local GRAVITY_FACTOR = 1
local IS_SERVER = RunService:IsServer()

-- Modules
local AssetsDealer = require(ReplicatedStorage.AssetsDealer)
local Game = require(ReplicatedStorage.Utility.Game)

-- Helper Functions
local function createTween(object: Instance, tweenInfo: TweenInfo, properties: {[string]: any})
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function tweenProjectileSize(object: Instance, targetSize: Vector3, duration: number)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    createTween(object, tweenInfo, {Size = targetSize, Transparency = 1})
end

local function tweenProjectileCFrame(part: BasePart, duration: number, targetCFrame: CFrame)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
    createTween(part, tweenInfo, {CFrame = targetCFrame})
end

local function tweenProjectilePosition(part: BasePart, duration: number, targetPosition: Vector3)
    task.spawn(function()
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
        createTween(part, tweenInfo, {Position = targetPosition})
    end)
end

-- Projectile Setup Functions
local function setupProjectileVisuals(args: {[string]: any}, currentPosition: Vector3, currentDirection: Vector3)
    local projectile
    local projectileLength = currentDirection.Magnitude
    local startPosition = currentPosition + (currentDirection.Unit * (projectileLength/2))

    if not IS_SERVER then
        if args.CustomProjectile then
            projectile = AssetsDealer.GetDir("Meshes", args.CustomProjectile, "Clone")
        else
            projectile = Instance.new("Part")
            projectile.Color = args.Color or Color3.fromRGB(255, 245, 96)
            projectile.Transparency = 1
            projectile.Material = Enum.Material.Neon
            projectile.Size = Vector3.new(args.Thickness, args.Thickness, projectileLength)
            
            -- Fade in the projectile
            task.spawn(function()
                local tweenInfo = TweenInfo.new(3)
                createTween(projectile, tweenInfo, {Transparency = 0.5})
            end)
        end

        -- Add particles if specified
        if args.Particle then
            local particle = AssetsDealer.GetDir("Particles", args.Particle, "Clone")
            particle.Parent = projectile
            particle.Enabled = true
            particle.Rate = 30
        end
    else
        projectile = Instance.new("Part")
        projectile.Color = Color3.new(1, 0, 0)
        projectile.Material = Enum.Material.Neon
        projectile.Transparency = 0.5
        projectile.Size = Vector3.new(0.3, 0.3, args.Amplitude)
    end

    -- Common setup for all projectiles
    projectile.Parent = Game.Folders.Projectiles
    projectile.Anchored = true
    projectile.CanCollide = false
    projectile.CFrame = CFrame.lookAt(startPosition, startPosition + currentDirection)

    return projectile
end

-- Main Functions
function ProjectileManager.Dynamic(args: {[string]: any})
    -- Set default values
    args.Amplitude = args.Amplitude or 40
    args.Bounces = args.Bounces or 0
    args.Range = args.Range or 1000
    args.Speed = args.Speed or 200
    args.Thickness = args.Thickness or 0.1

    -- Calculate projectile properties
    local gravity = args.Amplitude / args.Speed * GRAVITY_FACTOR
    local stepTime = args.Amplitude / args.Speed
    local bounces = args.Bounces

    -- Initialize projectile
    local currentPosition = args.Origin
    local currentDirection = args.Direction.Unit * args.Amplitude
    local projectile = setupProjectileVisuals(args, currentPosition, currentDirection)

    local function handleBounce()
        if not IS_SERVER and args.ClientBounceEvent then
            args.ClientBounceEvent(stepTime, projectile)
        end
        currentDirection = (currentDirection - (2 * currentDirection:Dot(Raycast.Normal) * Raycast.Normal)).Unit * currentDirection.Magnitude
        bounces -= 1
    end

    local function handleExplosion()
        -- TODO: Implement explosion logic
        -- ExplosionModule.Ignite(Raycast.Position-CurrentDirection.Unit, args.ExplosionRadius, args.ExplosionForce, args.Team)
    end

    local function step()
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        args.RaycastBlacklist = args.RaycastBlacklist or {}
        table.insert(args.RaycastBlacklist, workspace.Nodes)
        raycastParams.FilterDescendantsInstances = args.RaycastBlacklist
        raycastParams.IgnoreWater = true

        local raycast = workspace:Raycast(currentPosition, currentDirection, raycastParams)

        if raycast then
            if IS_SERVER then
                local instance = raycast.Instance
                if instance then
                    for _, entity in CollectionService:GetTagged("Entity") do
                        local team = entity:GetAttribute("Team")
                        if entity:FindFirstChild("Humanoid") and team then
                            if instance:IsDescendantOf(entity) then
                                if args.IsExplosive then
                                    handleExplosion()
                                end
                                local isTeammate = team ~= "None" and team == args.Team
                                return {
                                    Position = raycast.Position,
                                    Normal = raycast.Normal,
                                    Instance = instance,
                                    Entity = entity,
                                    IsTeammate = isTeammate
                                }
                            end
                        end
                    end
                end
            end

            if bounces > 0 then
                handleBounce()
            else
                if args.IsExplosive then
                    handleExplosion()
                end
                return {
                    Position = raycast.Position,
                    Instance = raycast.Instance,
                    Normal = raycast.Normal
                }
            end
        end

        -- Update projectile position
        currentPosition += currentDirection
        currentDirection -= Vector3.new(0, gravity, 0)

        if not IS_SERVER and args.ClientStepEvent then
            args.ClientStepEvent(stepTime, projectile)
        end

        local newCFrame = CFrame.lookAt(currentPosition, currentPosition + currentDirection)
        tweenProjectileCFrame(projectile, stepTime, newCFrame)
        task.wait(stepTime)

        return false
    end

    -- Main projectile loop
    for i = 1, args.Range/args.Amplitude do
        local result = step()
        if result then
            -- Handle final step
            currentDirection -= Vector3.new(0, gravity, 0)
            currentPosition += currentDirection

            if not IS_SERVER then
                local finalStepLength = args.Amplitude/2
                local finalStepTime = stepTime * (finalStepLength/args.Amplitude)
                local finalCFrame = CFrame.lookAt(currentPosition, currentPosition + (currentDirection * finalStepLength))
                tweenProjectileCFrame(projectile, finalStepTime, finalCFrame)

                if not args.CustomProjectile then
                    projectile.Size = Vector3.new(args.Thickness, args.Thickness, finalStepLength)
                end

                task.wait(finalStepTime)
                projectile:Destroy()
            end

            return result
        end
    end

    if not IS_SERVER then
        projectile:Destroy()
    end

    return "Expired"
end

return ProjectileManager
