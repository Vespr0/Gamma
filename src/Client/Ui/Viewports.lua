local Viewports = {}

function Viewports.GetItemViewport(tool: Instance,existingViewport) 
    -- TODO Validate tool with centralized utility module
    local model = tool:FindFirstChild("Model"):Clone()

    -- Instances
    local viewport 
    if existingViewport then
        viewport = existingViewport
    else
        viewport = Instance.new("ViewportFrame")
        viewport.Size = UDim2.fromScale(1,1)
        viewport.Position = UDim2.fromScale(0.5,.5)
        viewport.AnchorPoint = Vector2.new(0.5,0.5)
        viewport.BackgroundTransparency = 1
    end
    viewport.Ambient = Color3.fromRGB(177, 187, 209)
    viewport.LightColor = Color3.fromRGB(178, 161, 182)
    viewport.LightDirection = Vector3.new(-0.4, -.8, 0)
    local camera = Instance.new("Camera")
    camera.Parent = viewport
    camera.FieldOfView = 40
    model.Parent = viewport
    viewport.CurrentCamera = camera

    -- Camera and model positioning
    local origin = Vector3.zero
    local bounds = model:GetExtentsSize()
    local maxAxis = math.max(bounds.X, bounds.Y, bounds.Z)
    local distance = maxAxis*1.2+1
    local height = 1

    -- Position model
    local modelAngles = CFrame.Angles(math.rad(10), math.rad(50), 0)
    local modelCFrame = CFrame.new(origin) * modelAngles
    model:PivotTo(modelCFrame)
    -- Position camera
    local cameraPosition = origin + Vector3.new(distance,height,0)
    local cameraCFrame = CFrame.lookAt(cameraPosition, origin)
    camera.CFrame = cameraCFrame

    return viewport
end

return Viewports