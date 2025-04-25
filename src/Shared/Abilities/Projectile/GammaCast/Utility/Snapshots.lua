--!strict
-- Snapshot utility for GammaCast lag compensation (full port from SecureCast)

-- Services
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Dependencies
local Voxels = require(script.Parent.Voxels)
local Physics = require(script.Parent.Physics) 
local Settings = require(script.Parent.Parent.Settings)
local Game = require(ReplicatedStorage.Utility.Game)
local Draw = require(ReplicatedStorage.Utility.Draw)
local TypeRig = require(ReplicatedStorage.Types.TypeRig)

local IS_SERVER = RunService:IsServer()
local HEARTBEAT_CONNECTION = nil -- Store connection to disconnect if needed

export type Record = { Time: number, CFrames: {[string]: CFrame} }
export type Snapshot = {
    Time: number,
    Grid: Voxels.Grid<Instance>, -- Key grid by Rig
    Records: {[Instance]: Record}, -- Key records by Rig
}

export type Orientations = {
    [Instance]: {
        [string]: CFrame
    }
}

export type EntityHitResult = {Rig: TypeRig.Rig, Position: Vector3, Distance: number, PartName: string}

local Utility = {}
Utility.snapshots = {} -- Use standard table

local function ClearTable(tbl: {[any]: any}, deep: boolean?)
    for k,_ in pairs(tbl) do
        if deep and type(tbl[k]) == "table" then
            ClearTable(tbl[k], true)
        end
        tbl[k] = nil
    end
end

local function InterpolateRecord(prevRecord: Record, nextRecord: Record, t: number): Record
    local interpolatedRecord: Record = {
        Time = prevRecord.Time,
        CFrames = {},
    }

    for partName, prevPartCFrame in pairs(prevRecord.CFrames) do
        local nextPartCFrame = nextRecord.CFrames[partName]
        if nextPartCFrame then
            interpolatedRecord.CFrames[partName] = prevPartCFrame:Lerp(nextPartCFrame, t)
        else
            interpolatedRecord.CFrames[partName] = prevPartCFrame
        end
    end

    return interpolatedRecord
end

-- TODO: Binary search?
function Utility.GetSnapshots(time: number): (Snapshot?, Snapshot?)
    assert(IS_SERVER, "Snapshots.GetSnapshots should only be called on the server!")

    local prevSnap: Snapshot? = nil
    local nextSnap: Snapshot? = nil
    
    -- Find the two snapshots surrounding the given time
    for i = #Utility.snapshots, 1, -1 do
        local snap = Utility.snapshots[i]
        if snap.Time <= time then
            prevSnap = snap
            if i < #Utility.snapshots then
                nextSnap = Utility.snapshots[i+1]
            else
                nextSnap = snap -- If it's the last snapshot, use it as next too (or handle differently?)
            end
            break
        end
    end

    -- Return nil, nil if either snapshot is not found
    if prevSnap and nextSnap then
        return prevSnap, nextSnap
    else
        return nil, nil
    end
end

-- Renamed from GetSnapshotsAtTime, returns Record? now
function Utility.GetOrientationAtTime(entity: Instance, time: number): Record?
	local prevSnap, nextSnap = Utility.GetSnapshots(time)
	
    if prevSnap and nextSnap then -- Check if snapshots are valid
        local pSnap: Snapshot = prevSnap
        local nSnap: Snapshot = nextSnap

        local prevRecord = pSnap.Records[entity]
        local nextRecord = nSnap.Records[entity]
        
        if prevRecord and nextRecord then -- Check if entity exists in both
            -- Avoid division by zero and handle potential floating point issues
            local timeDiff = nSnap.Time - pSnap.Time
            if timeDiff <= 1e-6 then 
                return nextRecord -- Return the state at the next snapshot if times are too close
            end 
            local t = (time - pSnap.Time) / timeDiff
            return InterpolateRecord(prevRecord, nextRecord, t)
        else
            return nil -- Entity not in both records
        end
    else
        return nil -- Snapshots not found
    end
end

-- Helper function similar to SecureCast
function Utility.GetEntityAtTime(entity: Instance, Time: number): {[string]: CFrame}? 
	assert(IS_SERVER, "Snapshots.GetEntityAtTime should only be called on the server!")

    local Next, Previous = Utility.GetSnapshots(Time)
    if not Next or not Previous then -- Check Fraction for nil
        return
    end

    local NextRecord = Next.Records[entity]
    local PreviousRecord = Previous.Records[entity]
    if not NextRecord or not PreviousRecord then
        return
    end

    local Orientations: {[string]: CFrame} = {}
    for partName, prevPartCFrame in pairs(PreviousRecord.CFrames) do
        Orientations[partName] = prevPartCFrame:Lerp(NextRecord.CFrames[partName], (Time - Previous.Time) / (Next.Time - Previous.Time))
    end
    
    return Orientations
end

-- Function to get the timestamp of the oldest snapshot
function Utility.GetOldestSnapshotTime(): number?
	if #Utility.snapshots > 0 then
		return Utility.snapshots[1].Time
	end
	return nil
end

-- Function to create a snapshot of all tagged entities at a given time
function Utility.CreateEntitiesSnapshot(time: number)
    -- Removed assert(IS_SERVER) check as this will now be called via Init on server
    local voxels: {[Instance]: Vector3} = {}
    local records: {[Instance]: Record} = {}
    
    for _, entityRig in Game.Folders.Entities:GetChildren() do
        if not entityRig:IsA("Model") then continue end

        local rootPart = entityRig.PrimaryPart or entityRig:FindFirstChild("HumanoidRootPart")
        if not rootPart or not rootPart:IsA("BasePart") then continue end

        local partCFrames: {[string]: CFrame} = {} -- Map to store CFrames
        local canRecord = false

        -- Use Settings.Parts which is already a map {PartName: Size}
        for partName, _ in pairs(Settings.Parts) do 
            local part = entityRig:FindFirstChild(partName, true)
            if part and part:IsA("BasePart") then
                partCFrames[partName] = part.CFrame
                canRecord = true
            else
                -- If any required part is missing, invalidate this entity's record for this snapshot
                canRecord = false
                -- warn("LagComp Entity", entityRig, "missing part", partName, "for snapshot at time", time)
                break 
            end
        end

        if canRecord then
            -- Create the record with Time and the CFrames map
            local record: Record = { Time = time, CFrames = partCFrames }
            records[entityRig] = record
            voxels[entityRig] = rootPart.Position
        end
    end
    
    table.insert(Utility.snapshots, {Time = time, Grid = Voxels.BuildVoxelGrid(voxels, Settings.HitboxSize), Records = records})
    -- prune
    for i = #Utility.snapshots, 1, -1 do -- Use # for size
        local snap = Utility.snapshots[i] -- Access by index
        if time - snap.Time > Settings.SnapshotLifetime then
            local rem = table.remove(Utility.snapshots, i) -- Use table.remove
            -- Explicitly clear nested tables instead of calling ClearTable(rem, true)
            if rem then
                if rem.Records then 
                    for _, record in pairs(rem.Records) do
                        ClearTable(record.CFrames) -- Clear the CFrames table within each record
                    end
                    ClearTable(rem.Records) -- Clear the top-level Records table
                end
            end
        else
            -- Optimization: Since snapshots are ordered by time, we can stop early
            break 
        end
    end
end

-- Updated Raycast function incorporating OBB checks
function Utility.RaycastEntities(casterEntity: Instance, origin: Vector3, direction: Vector3, time: number): EntityHitResult? 
    assert(IS_SERVER, "RaycastEntities only on server")
    -- DEBUG: log invocation parameters
    -- warn("RaycastEntities called. time=", time, "snapshotCount=", #Utility.snapshots)
     
    -- Get relevant snapshots for interpolation
    local prevSnap, nextSnap = Utility.GetSnapshots(time)
    if not prevSnap then warn("RaycastEntities: no prevSnap for time", time) end
    -- warn("prevSnap.Time=", prevSnap and prevSnap.Time, "nextSnap.Time=", nextSnap and nextSnap.Time)

    if prevSnap and nextSnap then -- Check if snapshots are valid
        -- Explicit typing within the block
        local pSnap: Snapshot = prevSnap 
        local _nSnap: Snapshot = nextSnap -- Prefixed unused variable

        local normDirection = direction.Unit
        local rayLength = direction.Magnitude

        -- Broadphase: Voxel Grid Traversal (keys are Entities)
        local potentialHits: {[Instance]: boolean} = Voxels.TraverseVoxelGrid(origin, direction, pSnap.Grid)
        -- DEBUG: count potential hits
        local potCount = 0
        for _ in pairs(potentialHits) do
            potCount += 1
        end
        -- warn("RaycastEntities: potentialHits count=", potCount)
         
        local closestHitDist = math.huge
        local finalHit: EntityHitResult? = nil

        for entity, _ in pairs(potentialHits) do
            -- warn("RaycastEntities: testing entity", entity)
            if entity == casterEntity then continue end -- Don't hit self

            -- Get interpolated orientation for the potential hit entity
            local targetRecord = Utility.GetOrientationAtTime(entity, time)
            if not targetRecord then continue end -- Skip if entity state unavailable at this time

            -- Narrowphase: OBB Raycast against character parts
            for partName, partCFrame in pairs(targetRecord.CFrames) do
                -- warn("RaycastEntities: testing part", partName)
                local partSize = Settings.Parts[partName]
                
                if partCFrame then
                    local hitDist = Physics.RaycastOBB(rayLength, origin, normDirection, partSize, partCFrame)
                    -- warn("RaycastEntities: hitDist for part", partName, "=", hitDist)
                    if hitDist and hitDist < closestHitDist then
                        closestHitDist = hitDist
                        finalHit = {
                            Rig = entity :: TypeRig.Rig,
                            Position = origin + normDirection * hitDist,
                            Distance = hitDist,
                            PartName = partName
                        }
                        -- warn("RaycastEntities: new closestHit", entity, partName, hitDist)
                    end
                end
            end
        end
        -- if finalHit then warn("RaycastEntities: finalHit", finalHit.Rig, finalHit.PartName, finalHit.Distance) end
        return finalHit
    else
        -- Cannot perform lag compensation without valid snapshots
        -- warn("RaycastEntities: insufficient snapshots (prevSnap,nextSnap)", prevSnap, nextSnap)
        return nil
    end
end

-- Function to visualize snapshots
function Utility.VisualizeSnapshots()
    if not IS_SERVER then return end -- Snapshots are created on the server

    for _,v in Game.Folders.Debug:GetChildren() do
        if v.Name == "DebugSnapshotPart" then
            v:Destroy()
        end
    end

    local vizColor = Color3.fromRGB(255, 0, 0)
    local vizTransparency = 0.5

    for _, snapshot in Utility.snapshots do
        if snapshot.Records then
            for entityInstance, record in snapshot.Records do
                if record and record.CFrames and entityInstance:IsA("Model") then -- Check if instance is valid and a Model
                    for partName, partCFrame in record.CFrames do
                        local actualPart = entityInstance:FindFirstChild(partName)
                        if actualPart and actualPart:IsA("BasePart") then
                            local partSize = actualPart.Size
                            local debugPart = Draw.box(partCFrame, partSize, vizColor, vizTransparency)
                            if debugPart then
                                debugPart.Name = "DebugSnapshotPart"
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Initialize the snapshot system to automatically create snapshots every frame
function Utility.Init()
    if not IS_SERVER then return end

    HEARTBEAT_CONNECTION = RunService.Heartbeat:Connect(function(step)
        local currentTime = workspace:GetServerTimeNow()
        Utility.CreateEntitiesSnapshot(currentTime)
    end)
end

-- Optional: Function to stop automatic snapshot creation
function Utility.Stop()
    if HEARTBEAT_CONNECTION then
    
        HEARTBEAT_CONNECTION:Disconnect()
        HEARTBEAT_CONNECTION = nil
    end
end

return Utility
