-- WindUI Combat Features
-- Implements combat-related features for WindUI

local Combat = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utils = require(script.Parent.utils)

-- Main container for all combat effects
Combat.Effects = {}

-- Config container for all combat settings
Combat.Config = {
    BulletOrigin = {
        Enabled = false,
        Color = Color3.fromRGB(255, 0, 0),
        Transparency = 0.5,
        Size = 0.2,
        Duration = 2
    },
    BulletImpact = {
        Enabled = false,
        Color = Color3.fromRGB(255, 0, 0),
        Transparency = 0.5,
        Size = 0.5,
        Duration = 2
    },
    BulletTracer = {
        Enabled = false,
        Color = Color3.fromRGB(255, 0, 0),
        Transparency = 0.5,
        Width = 0.1,
        Duration = 0.5
    },
    ShootSound = {
        Enabled = false,
        SoundId = "rbxassetid://168143136", -- Default gun sound
        Volume = 0.5,
        PlaybackSpeed = 1
    },
    HitChams = {
        Enabled = false,
        Color = Color3.fromRGB(255, 0, 0),
        Transparency = 0.5,
        Duration = 0.5
    },
    HitEffects = {
        Enabled = false,
        Type = "Spark", -- Spark, Blood, Smoke
        Color = Color3.fromRGB(255, 0, 0),
        Size = 0.5,
        Duration = 0.5
    },
    HitSkeleton = {
        Enabled = false,
        Color = Color3.fromRGB(255, 0, 0),
        Transparency = 0.5,
        Duration = 1,
        LineThickness = 0.1
    },
    HitSound = {
        Enabled = false,
        SoundId = "rbxassetid://3744371342", -- Hit marker sound
        Volume = 0.5,
        PlaybackSpeed = 1
    },
    ForceHit = {
        Enabled = false,
        BypassWalls = false,
        HitPart = "Head" -- Head, HumanoidRootPart, Random
    },
    InvisibleBullets = {
        Enabled = false,
        RemoveEffects = true
    },
    Wallbang = {
        Enabled = false,
        WallTypes = {"Part"}, -- Types of instances that can be penetrated
        MaxThickness = 5, -- Maximum wall thickness
        DamageMultiplier = 0.5 -- Reduced damage through walls
    },
    LookAt = {
        Enabled = false,
        Target = "Closest", -- Closest, Crosshair, Random
        SmoothFactor = 0.2, -- Lower = smoother
        MaxDistance = 100
    },
    ViewAt = {
        Enabled = false,
        Target = "Closest", -- Closest, Shot
        SmoothFactor = 0.5, -- Lower = smoother
        Duration = 1
    },
    BulletTP = {
        Enabled = false,
        Distance = 10, -- Distance behind target
        TeleportBack = true,
        TeleportDelay = 0.2
    },
    CameraLock = {
        Enabled = false,
        Target = "Closest", -- Closest, Crosshair, Health
        SmoothFactor = 0.2,
        MaxDistance = 100,
        LockPart = "Head" -- Head, HumanoidRootPart, Torso
    },
    FOVMode = {
        Enabled = false,
        Size = 100,
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 0.8,
        Filled = false
    },
    Prediction = {
        Enabled = false,
        Method = "Division", -- Division, Multiplication
        Factor = 1, -- Multiplier/divisor for ping
        VisualizeTarget = false,
        VisualColor = Color3.fromRGB(0, 255, 0)
    },
    AutoPrediction = {
        Enabled = false,
        MinFactor = 1,
        MaxFactor = 5,
        AutoAdjust = true
    },
    CustomAutoPrediction = {
        Enabled = false,
        BaseFactor = 2,
        MaxPing = 300,
        DynamicScaling = true
    }
}

-- Initialize the combat module
function Combat:Init()
    -- Setup bullet origin visualization
    self:SetupBulletOrigin()
    
    -- Setup bullet impact visualization
    self:SetupBulletImpact()
    
    -- Setup bullet tracer
    self:SetupBulletTracer()
    
    -- Setup shoot sound
    self:SetupShootSound()
    
    -- Setup hit chams
    self:SetupHitChams()
    
    -- Setup hit effects
    self:SetupHitEffects()
    
    -- Setup hit skeleton
    self:SetupHitSkeleton()
    
    -- Setup hit sound
    self:SetupHitSound()
    
    -- Setup force hit
    self:SetupForceHit()
    
    -- Setup invisible bullets
    self:SetupInvisibleBullets()
    
    -- Setup wallbang
    self:SetupWallbang()
    
    -- Setup look at
    self:SetupLookAt()
    
    -- Setup view at
    self:SetupViewAt()
    
    -- Setup bullet TP
    self:SetupBulletTP()
    
    -- Setup camera lock
    self:SetupCameraLock()
    
    -- Setup FOV display
    self:SetupFOVMode()
    
    -- Setup prediction methods
    self:SetupPrediction()
    
    -- Setup auto prediction
    self:SetupAutoPrediction()
    
    -- Setup custom auto prediction
    self:SetupCustomAutoPrediction()
    
    -- Connect update loop
    RunService.RenderStepped:Connect(function(dt)
        self:Update(dt)
    end)
    
    -- Connect input events
    self:ConnectInputEvents()
    
    return self
end

-- Update method called every frame
function Combat:Update(dt)
    -- Update bullet origin visualization
    self:UpdateBulletOrigin(dt)
    
    -- Update bullet impact visualization
    self:UpdateBulletImpact(dt)
    
    -- Update bullet tracer
    self:UpdateBulletTracer(dt)
    
    -- Update hit chams
    self:UpdateHitChams(dt)
    
    -- Update hit skeleton
    self:UpdateHitSkeleton(dt)
    
    -- Update look at
    self:UpdateLookAt(dt)
    
    -- Update view at
    self:UpdateViewAt(dt)
    
    -- Update camera lock
    self:UpdateCameraLock(dt)
    
    -- Update FOV display
    self:UpdateFOVMode(dt)
end

-- Connect to input events
function Combat:ConnectInputEvents()
    -- Monitor mouse buttons for shooting events
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:OnShoot()
        end
    end)
    
    -- Monitor custom keybinds
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.Z then
            -- Toggle aim assist
            self.Config.LookAt.Enabled = not self.Config.LookAt.Enabled
        elseif input.KeyCode == Enum.KeyCode.X then
            -- Toggle camera lock
            self.Config.CameraLock.Enabled = not self.Config.CameraLock.Enabled
        elseif input.KeyCode == Enum.KeyCode.V then
            -- Toggle bullet TP
            self.Config.BulletTP.Enabled = not self.Config.BulletTP.Enabled
        end
    end)
end

-- Event handler for when player shoots
function Combat:OnShoot()
    local localPlayer = Players.LocalPlayer
    local camera = workspace.CurrentCamera
    local mousePosition = UserInputService:GetMouseLocation()
    local rayFromScreen = camera:ViewportPointToRay(mousePosition.X, mousePosition.Y)
    
    -- Get ray origin and direction
    local rayOrigin = rayFromScreen.Origin
    local rayDirection = rayFromScreen.Direction * 1000
    
    -- Check for ForceHit
    if self.Config.ForceHit.Enabled then
        self:HandleForceHit(rayOrigin, rayDirection)
        return
    end
    
    -- Normal shooting
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {localPlayer.Character}
    
    -- Handle wallbang if enabled
    if self.Config.Wallbang.Enabled then
        self:HandleWallbang(rayOrigin, rayDirection)
        return
    end
    
    -- Normal raycast
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    -- Show bullet origin
    if self.Config.BulletOrigin.Enabled then
        self:AddBulletOrigin(rayOrigin)
    end
    
    -- Play shoot sound
    if self.Config.ShootSound.Enabled then
        self:PlayShootSound(rayOrigin)
    end
    
    if raycastResult then
        local hitPosition = raycastResult.Position
        local hitInstance = raycastResult.Instance
        local hitNormal = raycastResult.Normal
        
        -- Handle Bullet TP
        if self.Config.BulletTP.Enabled then
            self:HandleBulletTP(hitInstance)
        end
        
        -- Handle bullet impact
        if self.Config.BulletImpact.Enabled then
            self:AddBulletImpact(hitPosition, hitNormal)
        end
        
        -- Handle bullet tracer
        if self.Config.BulletTracer.Enabled then
            self:AddBulletTracer(rayOrigin, hitPosition)
        end
        
        -- Check if hit player
        local hitPlayer = self:GetPlayerFromHitInstance(hitInstance)
        if hitPlayer then
            -- Handle hit chams
            if self.Config.HitChams.Enabled then
                self:AddHitChams(hitPlayer)
            end
            
            -- Handle hit effects
            if self.Config.HitEffects.Enabled then
                self:AddHitEffect(hitPosition)
            end
            
            -- Handle hit skeleton
            if self.Config.HitSkeleton.Enabled then
                self:AddHitSkeleton(hitPlayer)
            end
            
            -- Handle hit sound
            if self.Config.HitSound.Enabled then
                self:PlayHitSound(hitPosition)
            end
            
            -- Handle view at
            if self.Config.ViewAt.Enabled and self.Config.ViewAt.Target == "Shot" then
                self:SetViewTarget(hitPlayer)
            end
        end
    else
        -- No hit, still show tracer to maximum distance
        if self.Config.BulletTracer.Enabled then
            self:AddBulletTracer(rayOrigin, rayOrigin + rayDirection)
        end
    end
end

-- Bullet Origin implementation
function Combat:SetupBulletOrigin()
    self.Effects.BulletOrigin = {
        Origins = {}
    }
end

function Combat:AddBulletOrigin(position)
    local config = self.Config.BulletOrigin
    
    local part = Instance.new("Part")
    part.Name = "BulletOrigin"
    part.Shape = Enum.PartType.Ball
    part.Color = config.Color
    part.Transparency = config.Transparency
    part.Size = Vector3.new(config.Size, config.Size, config.Size)
    part.Anchored = true
    part.CanCollide = false
    part.Material = Enum.Material.Neon
    part.Position = position
    part.Parent = workspace
    
    table.insert(self.Effects.BulletOrigin.Origins, {
        Part = part,
        CreationTime = tick()
    })
end

function Combat:UpdateBulletOrigin(dt)
    local config = self.Config.BulletOrigin
    local originsToRemove = {}
    
    -- Update existing origins
    for i, originData in ipairs(self.Effects.BulletOrigin.Origins) do
        local age = tick() - originData.CreationTime
        
        if age > config.Duration then
            -- Mark for removal
            table.insert(originsToRemove, i)
        else
            -- Fade out over time
            local fade = age / config.Duration
            originData.Part.Transparency = config.Transparency + (fade * (1 - config.Transparency))
        end
    end
    
    -- Remove old origins
    for i = #originsToRemove, 1, -1 do
        local index = originsToRemove[i]
        self.Effects.BulletOrigin.Origins[index].Part:Destroy()
        table.remove(self.Effects.BulletOrigin.Origins, index)
    end
end

-- Bullet Impact implementation
function Combat:SetupBulletImpact()
    self.Effects.BulletImpact = {
        Impacts = {}
    }
end

function Combat:AddBulletImpact(position, normal)
    local config = self.Config.BulletImpact
    
    local part = Instance.new("Part")
    part.Name = "BulletImpact"
    part.Shape = Enum.PartType.Ball
    part.Color = config.Color
    part.Transparency = config.Transparency
    part.Size = Vector3.new(config.Size, config.Size, config.Size)
    part.Anchored = true
    part.CanCollide = false
    part.Material = Enum.Material.Neon
    part.Position = position
    part.Parent = workspace
    
    -- Create impact particles
    local particleEmitter = Instance.new("ParticleEmitter")
    particleEmitter.Texture = "rbxassetid://2581223252" -- Spark particle
    particleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 0)
    })
    particleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    particleEmitter.Speed = NumberRange.new(5, 10)
    particleEmitter.Lifetime = NumberRange.new(0.2, 0.5)
    particleEmitter.Rate = 0
    particleEmitter.Rotation = NumberRange.new(0, 360)
    particleEmitter.RotSpeed = NumberRange.new(-90, 90)
    particleEmitter.SpreadAngle = Vector2.new(50, 50)
    particleEmitter.Acceleration = Vector3.new(0, -10, 0)
    particleEmitter.Drag = 5
    particleEmitter.EmissionDirection = Enum.NormalId.Front
    particleEmitter.Color = ColorSequence.new(config.Color)
    particleEmitter.Parent = part
    
    -- Emit a burst of particles
    particleEmitter:Emit(20)
    
    table.insert(self.Effects.BulletImpact.Impacts, {
        Part = part,
        CreationTime = tick()
    })
end

function Combat:UpdateBulletImpact(dt)
    local config = self.Config.BulletImpact
    local impactsToRemove = {}
    
    -- Update existing impacts
    for i, impactData in ipairs(self.Effects.BulletImpact.Impacts) do
        local age = tick() - impactData.CreationTime
        
        if age > config.Duration then
            -- Mark for removal
            table.insert(impactsToRemove, i)
        else
            -- Fade out over time
            local fade = age / config.Duration
            impactData.Part.Transparency = config.Transparency + (fade * (1 - config.Transparency))
        end
    end
    
    -- Remove old impacts
    for i = #impactsToRemove, 1, -1 do
        local index = impactsToRemove[i]
        self.Effects.BulletImpact.Impacts[index].Part:Destroy()
        table.remove(self.Effects.BulletImpact.Impacts, index)
    end
end

-- Bullet Tracer implementation
function Combat:SetupBulletTracer()
    self.Effects.BulletTracer = {
        Tracers = {}
    }
end

function Combat:AddBulletTracer(startPosition, endPosition)
    local config = self.Config.BulletTracer
    
    -- Create tracer parts
    local distance = (endPosition - startPosition).Magnitude
    local midPoint = startPosition:Lerp(endPosition, 0.5)
    local direction = (endPosition - startPosition).Unit
    
    local tracerPart = Instance.new("Part")
    tracerPart.Name = "BulletTracer"
    tracerPart.Shape = Enum.PartType.Cylinder
    tracerPart.Color = config.Color
    tracerPart.Transparency = config.Transparency
    tracerPart.Size = Vector3.new(config.Width, distance, config.Width)
    tracerPart.Anchored = true
    tracerPart.CanCollide = false
    tracerPart.Material = Enum.Material.Neon
    
    -- Align the cylinder along the ray path
    local cf = CFrame.new(midPoint, endPosition)
    tracerPart.CFrame = cf * CFrame.Angles(0, math.rad(90), 0)
    tracerPart.Parent = workspace
    
    table.insert(self.Effects.BulletTracer.Tracers, {
        Part = tracerPart,
        CreationTime = tick()
    })
end

function Combat:UpdateBulletTracer(dt)
    local config = self.Config.BulletTracer
    local tracersToRemove = {}
    
    -- Update existing tracers
    for i, tracerData in ipairs(self.Effects.BulletTracer.Tracers) do
        local age = tick() - tracerData.CreationTime
        
        if age > config.Duration then
            -- Mark for removal
            table.insert(tracersToRemove, i)
        else
            -- Fade out over time
            local fade = age / config.Duration
            tracerData.Part.Transparency = config.Transparency + (fade * (1 - config.Transparency))
        end
    end
    
    -- Remove old tracers
    for i = #tracersToRemove, 1, -1 do
        local index = tracersToRemove[i]
        self.Effects.BulletTracer.Tracers[index].Part:Destroy()
        table.remove(self.Effects.BulletTracer.Tracers, index)
    end
end

-- Shoot Sound implementation
function Combat:SetupShootSound()
    self.Effects.ShootSound = {
        Sounds = {}
    }
end

function Combat:PlayShootSound(position)
    local config = self.Config.ShootSound
    
    local sound = Instance.new("Sound")
    sound.SoundId = config.SoundId
    sound.Volume = config.Volume
    sound.PlaybackSpeed = config.PlaybackSpeed
    
    local part = Instance.new("Part")
    part.Name = "ShootSoundPart"
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    part.Size = Vector3.new(1, 1, 1)
    part.Position = position
    part.Parent = workspace
    
    sound.Parent = part
    sound:Play()
    
    -- Clean up after playing
    sound.Ended:Connect(function()
        part:Destroy()
    end)
    
    table.insert(self.Effects.ShootSound.Sounds, {
        Sound = sound,
        Part = part,
        CreationTime = tick()
    })
end

-- Hit Chams implementation
function Combat:SetupHitChams()
    self.Effects.HitChams = {
        ChamedPlayers = {}
    }
end

function Combat:AddHitChams(player)
    local config = self.Config.HitChams
    
    -- Remove existing chams for this player
    self:RemoveHitChams(player)
    
    -- Add new chams
    local character = player.Character
    if not character then return end
    
    local chamParts = {}
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            -- Store original properties
            local originalProperties = {
                Color = part.Color,
                Material = part.Material,
                Transparency = part.Transparency
            }
            
            -- Apply chams
            part.Color = config.Color
            part.Material = Enum.Material.ForceField
            part.Transparency = config.Transparency
            
            table.insert(chamParts, {
                Part = part,
                OriginalProperties = originalProperties
            })
        end
    end
    
    self.Effects.HitChams.ChamedPlayers[player.Name] = {
        Player = player,
        Parts = chamParts,
        CreationTime = tick()
    }
end

function Combat:RemoveHitChams(player)
    local chamData = self.Effects.HitChams.ChamedPlayers[player.Name]
    
    if chamData then
        -- Restore original properties
        for _, partData in ipairs(chamData.Parts) do
            if partData.Part and partData.Part:IsA("BasePart") then
                partData.Part.Color = partData.OriginalProperties.Color
                partData.Part.Material = partData.OriginalProperties.Material
                partData.Part.Transparency = partData.OriginalProperties.Transparency
            end
        end
        
        self.Effects.HitChams.ChamedPlayers[player.Name] = nil
    end
end

function Combat:UpdateHitChams(dt)
    local config = self.Config.HitChams
    local playersToRemove = {}
    
    -- Update chams
    for playerName, chamData in pairs(self.Effects.HitChams.ChamedPlayers) do
        local age = tick() - chamData.CreationTime
        
        if age > config.Duration then
            -- Mark for removal
            table.insert(playersToRemove, playerName)
        else
            -- Fade out over time
            local fade = age / config.Duration
            local newTransparency = config.Transparency + (fade * (1 - config.Transparency))
            
            for _, partData in ipairs(chamData.Parts) do
                if partData.Part and partData.Part:IsA("BasePart") then
                    partData.Part.Transparency = newTransparency
                end
            end
        end
    end
    
    -- Remove expired chams
    for _, playerName in ipairs(playersToRemove) do
        local chamData = self.Effects.HitChams.ChamedPlayers[playerName]
        if chamData then
            self:RemoveHitChams(chamData.Player)
        end
    end
end

-- Hit Effects implementation
function Combat:SetupHitEffects()
    self.Effects.HitEffects = {
        Effects = {}
    }
end

function Combat:AddHitEffect(position)
    local config = self.Config.HitEffects
    
    local part = Instance.new("Part")
    part.Name = "HitEffect"
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    part.Size = Vector3.new(1, 1, 1)
    part.Position = position
    part.Parent = workspace
    
    local particleEmitter = Instance.new("ParticleEmitter")
    
    -- Configure based on effect type
    if config.Type == "Spark" then
        particleEmitter.Texture = "rbxassetid://2581223252" -- Spark texture
        particleEmitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, config.Size),
            NumberSequenceKeypoint.new(1, 0)
        })
        particleEmitter.Speed = NumberRange.new(5, 10)
        particleEmitter.Lifetime = NumberRange.new(0.2, 0.5)
        particleEmitter.SpreadAngle = Vector2.new(180, 180)
    elseif config.Type == "Blood" then
        particleEmitter.Texture = "rbxassetid://539294959" -- Blood splatter
        particleEmitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, config.Size * 0.5),
            NumberSequenceKeypoint.new(1, config.Size)
        })
        particleEmitter.Speed = NumberRange.new(2, 5)
        particleEmitter.Lifetime = NumberRange.new(0.3, 0.7)
        particleEmitter.SpreadAngle = Vector2.new(90, 90)
    elseif config.Type == "Smoke" then
        particleEmitter.Texture = "rbxassetid://133619974" -- Smoke
        particleEmitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, config.Size * 0.5),
            NumberSequenceKeypoint.new(1, config.Size * 2)
        })
        particleEmitter.Speed = NumberRange.new(1, 3)
        particleEmitter.Lifetime = NumberRange.new(0.5, 1)
        particleEmitter.SpreadAngle = Vector2.new(90, 90)
    end
    
    particleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    particleEmitter.Rate = 0 -- Emit in bursts only
    particleEmitter.Rotation = NumberRange.new(0, 360)
    particleEmitter.RotSpeed = NumberRange.new(-90, 90)
    particleEmitter.Acceleration = Vector3.new(0, -5, 0)
    particleEmitter.Color = ColorSequence.new(config.Color)
    particleEmitter.Parent = part
    
    -- Emit a burst of particles
    particleEmitter:Emit(30)
    
    table.insert(self.Effects.HitEffects.Effects, {
        Part = part,
        CreationTime = tick()
    })
    
    -- Schedule cleanup
    game:GetService("Debris"):AddItem(part, config.Duration)
end

-- Hit Skeleton implementation
function Combat:SetupHitSkeleton()
    self.Effects.HitSkeleton = {
        Skeletons = {}
    }
end

function Combat:AddHitSkeleton(player)
    local config = self.Config.HitSkeleton
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Get all important parts
    local head = character:FindFirstChild("Head")
    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    local lowerTorso = character:FindFirstChild("LowerTorso")
    local leftArm = character:FindFirstChild("LeftUpperArm") or character:FindFirstChild("Left Arm")
    local rightArm = character:FindFirstChild("RightUpperArm") or character:FindFirstChild("Right Arm")
    local leftLeg = character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg")
    local rightLeg = character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg")
    
    if not head or not torso then return end
    
    -- Create skeleton container
    local skeletonFolder = Instance.new("Folder")
    skeletonFolder.Name = "HitSkeleton_" .. player.Name
    skeletonFolder.Parent = workspace
    
    local lines = {}
    
    -- Connect head to torso
    if head and torso then
        local line = self:CreateSkeletonLine(head.Position, torso.Position, config)
        line.Parent = skeletonFolder
        table.insert(lines, line)
    end
    
    -- Connect torso to limbs
    if torso then
        if leftArm then
            local line = self:CreateSkeletonLine(torso.Position, leftArm.Position, config)
            line.Parent = skeletonFolder
            table.insert(lines, line)
        end
        
        if rightArm then
            local line = self:CreateSkeletonLine(torso.Position, rightArm.Position, config)
            line.Parent = skeletonFolder
            table.insert(lines, line)
        end
        
        if lowerTorso then
            local line = self:CreateSkeletonLine(torso.Position, lowerTorso.Position, config)
            line.Parent = skeletonFolder
            table.insert(lines, line)
            
            -- R15 connections
            if leftLeg and lowerTorso then
                local line = self:CreateSkeletonLine(lowerTorso.Position, leftLeg.Position, config)
                line.Parent = skeletonFolder
                table.insert(lines, line)
            end
            
            if rightLeg and lowerTorso then
                local line = self:CreateSkeletonLine(lowerTorso.Position, rightLeg.Position, config)
                line.Parent = skeletonFolder
                table.insert(lines, line)
            end
        else
            -- R6 connections
            if leftLeg and torso then
                local line = self:CreateSkeletonLine(torso.Position, leftLeg.Position, config)
                line.Parent = skeletonFolder
                table.insert(lines, line)
            end
            
            if rightLeg and torso then
                local line = self:CreateSkeletonLine(torso.Position, rightLeg.Position, config)
                line.Parent = skeletonFolder
                table.insert(lines, line)
            end
        end
    end
    
    table.insert(self.Effects.HitSkeleton.Skeletons, {
        Folder = skeletonFolder,
        Lines = lines,
        CreationTime = tick()
    })
end

function Combat:CreateSkeletonLine(startPos, endPos, config)
    local distance = (endPos - startPos).Magnitude
    local midPoint = startPos:Lerp(endPos, 0.5)
    local direction = (endPos - startPos).Unit
    
    local line = Instance.new("Part")
    line.Shape = Enum.PartType.Cylinder
    line.Size = Vector3.new(config.LineThickness, distance, config.LineThickness)
    line.Color = config.Color
    line.Transparency = config.Transparency
    line.Anchored = true
    line.CanCollide = false
    line.Material = Enum.Material.Neon
    
    -- Orient the cylinder to match the line
    local cf = CFrame.new(midPoint, endPos)
    line.CFrame = cf * CFrame.Angles(0, math.rad(90), 0)
    
    return line
end

function Combat:UpdateHitSkeleton(dt)
    local config = self.Config.HitSkeleton
    local skeletonsToRemove = {}
    
    -- Update skeletons
    for i, skeletonData in ipairs(self.Effects.HitSkeleton.Skeletons) do
        local age = tick() - skeletonData.CreationTime
        
        if age > config.Duration then
            -- Mark for removal
            table.insert(skeletonsToRemove, i)
        else
            -- Fade out over time
            local fade = age / config.Duration
            local newTransparency = config.Transparency + (fade * (1 - config.Transparency))
            
            for _, line in ipairs(skeletonData.Lines) do
                line.Transparency = newTransparency
            end
        end
    end
    
    -- Remove expired skeletons
    for i = #skeletonsToRemove, 1, -1 do
        local index = skeletonsToRemove[i]
        self.Effects.HitSkeleton.Skeletons[index].Folder:Destroy()
        table.remove(self.Effects.HitSkeleton.Skeletons, index)
    end
end

-- Hit Sound implementation
function Combat:SetupHitSound()
    self.Effects.HitSound = {
        Sounds = {}
    }
end

function Combat:PlayHitSound(position)
    local config = self.Config.HitSound
    
    local sound = Instance.new("Sound")
    sound.SoundId = config.SoundId
    sound.Volume = config.Volume
    sound.PlaybackSpeed = config.PlaybackSpeed
    
    local part = Instance.new("Part")
    part.Name = "HitSoundPart"
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    part.Size = Vector3.new(1, 1, 1)
    part.Position = position
    part.Parent = workspace
    
    sound.Parent = part
    sound:Play()
    
    -- Clean up after playing
    sound.Ended:Connect(function()
        part:Destroy()
    end)
    
    table.insert(self.Effects.HitSound.Sounds, {
        Sound = sound,
        Part = part,
        CreationTime = tick()
    })
end

-- Force Hit implementation
function Combat:SetupForceHit()
    self.Effects.ForceHit = {
        Active = false
    }
end

function Combat:HandleForceHit(rayOrigin, rayDirection)
    local config = self.Config.ForceHit
    
    if not config.Enabled then return end
    
    local localPlayer = Players.LocalPlayer
    local nearestPlayer, nearestPart, nearestDistance = nil, nil, math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local targetPart
            
            if config.HitPart == "Head" then
                targetPart = player.Character:FindFirstChild("Head")
            elseif config.HitPart == "HumanoidRootPart" then
                targetPart = player.Character:FindFirstChild("HumanoidRootPart")
            elseif config.HitPart == "Random" then
                local parts = {}
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        table.insert(parts, part)
                    end
                end
                if #parts > 0 then
                    targetPart = parts[math.random(1, #parts)]
                end
            end
            
            if targetPart then
                local distance = (targetPart.Position - rayOrigin).Magnitude
                
                -- Check visibility if not bypassing walls
                local isVisible = true
                if not config.BypassWalls then
                    local rayParams = RaycastParams.new()
                    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                    rayParams.FilterDescendantsInstances = {localPlayer.Character, player.Character}
                    
                    local result = workspace:Raycast(rayOrigin, targetPart.Position - rayOrigin, rayParams)
                    isVisible = result == nil
                end
                
                if isVisible and distance < nearestDistance then
                    nearestPlayer = player
                    nearestPart = targetPart
                    nearestDistance = distance
                end
            end
        end
    end
    
    if nearestPlayer and nearestPart then
        -- Show bullet tracer to target
        if self.Config.BulletTracer.Enabled then
            self:AddBulletTracer(rayOrigin, nearestPart.Position)
        end
        
        -- Show bullet impact
        if self.Config.BulletImpact.Enabled then
            self:AddBulletImpact(nearestPart.Position, Vector3.new(0, 1, 0))
        end
        
        -- Add hit effects
        if self.Config.HitChams.Enabled then
            self:AddHitChams(nearestPlayer)
        end
        
        if self.Config.HitEffects.Enabled then
            self:AddHitEffect(nearestPart.Position)
        end
        
        if self.Config.HitSkeleton.Enabled then
            self:AddHitSkeleton(nearestPlayer)
        end
        
        if self.Config.HitSound.Enabled then
            self:PlayHitSound(nearestPart.Position)
        end
    end
end

-- Invisible Bullets implementation
function Combat:SetupInvisibleBullets()
    self.Effects.InvisibleBullets = {
        Active = false,
        OriginalFunctions = {}
    }
end

-- Wallbang implementation
function Combat:SetupWallbang()
    self.Effects.Wallbang = {
        Active = false
    }
end

function Combat:HandleWallbang(rayOrigin, rayDirection)
    local config = self.Config.Wallbang
    
    if not config.Enabled then return end
    
    local localPlayer = Players.LocalPlayer
    
    -- First raycast to find the first hit (wall)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {localPlayer.Character}
    
    local wallHit = workspace:Raycast(rayOrigin, rayDirection, rayParams)
    
    if not wallHit then return end
    
    -- Check if the wall is a valid wall type
    local isValidWall = false
    for _, wallType in ipairs(config.WallTypes) do
        if wallHit.Instance:IsA(wallType) then
            isValidWall = true
            break
        end
    end
    
    if not isValidWall then return end
    
    -- Calculate wall thickness
    local wallEntry = wallHit.Position
    local wallDirection = rayDirection.Unit
    
    -- Second raycast from slightly beyond the wall to find exit point
    local exitRayOrigin = wallEntry + (wallDirection * 0.1)
    local exitRay = workspace:Raycast(exitRayOrigin, wallDirection * config.MaxThickness, rayParams)
    
    local wallThickness
    if exitRay then
        wallThickness = (exitRay.Position - wallEntry).Magnitude
    else
        wallThickness = config.MaxThickness
    end
    
    -- If wall is too thick, don't penetrate
    if wallThickness > config.MaxThickness then return end
    
    -- Raycast beyond the wall to find a player
    local beyondWallOrigin = wallEntry + (wallDirection * (wallThickness + 0.1))
    local beyondWallRayParams = RaycastParams.new()
    beyondWallRayParams.FilterType = Enum.RaycastFilterType.Blacklist
    beyondWallRayParams.FilterDescendantsInstances = {localPlayer.Character, wallHit.Instance}
    
    local playerHit = workspace:Raycast(beyondWallOrigin, wallDirection * 100, beyondWallRayParams)
    
    -- Show bullet impacts and tracers
    if self.Config.BulletImpact.Enabled then
        self:AddBulletImpact(wallEntry, wallHit.Normal)
        
        if exitRay then
            self:AddBulletImpact(exitRay.Position, -wallDirection)
        end
    end
    
    if self.Config.BulletTracer.Enabled then
        self:AddBulletTracer(rayOrigin, wallEntry)
        
        local exitPoint = exitRay and exitRay.Position or (wallEntry + wallDirection * wallThickness)
        self:AddBulletTracer(exitPoint, exitPoint + (wallDirection * 10))
    end
    
    if playerHit then
        local hitPlayer = self:GetPlayerFromHitInstance(playerHit.Instance)
        
        if hitPlayer then
            -- Apply hit effects with potentially reduced damage
            if self.Config.HitChams.Enabled then
                self:AddHitChams(hitPlayer)
            end
            
            if self.Config.HitEffects.Enabled then
                self:AddHitEffect(playerHit.Position)
            end
            
            if self.Config.HitSkeleton.Enabled then
                self:AddHitSkeleton(hitPlayer)
            end
            
            if self.Config.HitSound.Enabled then
                self:PlayHitSound(playerHit.Position)
            end
        end
    end
end

-- Look At implementation
function Combat:SetupLookAt()
    self.Effects.LookAt = {
        Active = false,
        CurrentTarget = nil
    }
end

function Combat:UpdateLookAt(dt)
    local config = self.Config.LookAt
    
    if not config.Enabled then
        self.Effects.LookAt.Active = false
        self.Effects.LookAt.CurrentTarget = nil
        return
    end
    
    local localPlayer = Players.LocalPlayer
    local camera = workspace.CurrentCamera
    
    if not localPlayer or not localPlayer.Character then return end
    
    local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Find target based on selected method
    local targetPosition = nil
    
    if config.Target == "Closest" then
        local closestPlayer, closestPart, closestDistance = self:FindClosestPlayer(config.MaxDistance)
        
        if closestPlayer and closestPart then
            targetPosition = closestPart.Position
            self.Effects.LookAt.CurrentTarget = closestPlayer
        end
    elseif config.Target == "Crosshair" then
        local crosshairTarget = self:FindCrosshairTarget(config.MaxDistance)
        
        if crosshairTarget then
            targetPosition = crosshairTarget.Position
            self.Effects.LookAt.CurrentTarget = self:GetPlayerFromHitInstance(crosshairTarget)
        end
    elseif config.Target == "Random" then
        local randomTarget = self:FindRandomVisiblePlayer(config.MaxDistance)
        
        if randomTarget then
            local targetPart = randomTarget.Character:FindFirstChild("Head")
            if targetPart then
                targetPosition = targetPart.Position
                self.Effects.LookAt.CurrentTarget = randomTarget
            end
        end
    end
    
    -- Apply aim if target found
    if targetPosition then
        local currentCameraCFrame = camera.CFrame
        local targetCFrame = CFrame.new(currentCameraCFrame.Position, targetPosition)
        
        -- Apply smoothing
        local smoothFactor = math.clamp(config.SmoothFactor, 0.01, 1)
        local newCameraCFrame = currentCameraCFrame:Lerp(targetCFrame, smoothFactor)
        
        camera.CFrame = newCameraCFrame
        self.Effects.LookAt.Active = true
    else
        self.Effects.LookAt.Active = false
        self.Effects.LookAt.CurrentTarget = nil
    end
end

-- View At implementation
function Combat:SetupViewAt()
    self.Effects.ViewAt = {
        Active = false,
        CurrentTarget = nil,
        StartTime = 0,
        OriginalCameraCFrame = nil
    }
end

function Combat:UpdateViewAt(dt)
    local config = self.Config.ViewAt
    
    if not config.Enabled then
        if self.Effects.ViewAt.Active then
            -- Reset camera position
            if self.Effects.ViewAt.OriginalCameraCFrame then
                workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            end
            
            self.Effects.ViewAt.Active = false
            self.Effects.ViewAt.CurrentTarget = nil
            self.Effects.ViewAt.StartTime = 0
            self.Effects.ViewAt.OriginalCameraCFrame = nil
        end
        return
    end
    
    local currentTime = tick()
    
    if self.Effects.ViewAt.Active then
        -- Check if view duration has expired
        if currentTime - self.Effects.ViewAt.StartTime > config.Duration then
            -- Reset camera
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            
            self.Effects.ViewAt.Active = false
            self.Effects.ViewAt.CurrentTarget = nil
            self.Effects.ViewAt.StartTime = 0
            self.Effects.ViewAt.OriginalCameraCFrame = nil
        else
            -- Update camera if target is still valid
            local target = self.Effects.ViewAt.CurrentTarget
            if target and target.Character then
                local head = target.Character:FindFirstChild("Head")
                if head then
                    local smoothFactor = math.clamp(config.SmoothFactor, 0.01, 1)
                    local currentCFrame = workspace.CurrentCamera.CFrame
                    local targetCFrame = CFrame.new(currentCFrame.Position, head.Position)
                    workspace.CurrentCamera.CFrame = currentCFrame:Lerp(targetCFrame, smoothFactor)
                end
            end
        end
    end
end

function Combat:SetViewTarget(player)
    local config = self.Config.ViewAt
    
    if not player or not player.Character then return end
    
    local head = player.Character:FindFirstChild("Head")
    if not head then return end
    
    -- Store original camera state
    if not self.Effects.ViewAt.Active then
        self.Effects.ViewAt.OriginalCameraCFrame = workspace.CurrentCamera.CFrame
    end
    
    -- Set camera to watch target
    workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    
    self.Effects.ViewAt.Active = true
    self.Effects.ViewAt.CurrentTarget = player
    self.Effects.ViewAt.StartTime = tick()
end

-- Bullet TP implementation
function Combat:SetupBulletTP()
    self.Effects.BulletTP = {
        Active = false,
        OriginalPosition = nil,
        TeleportTime = 0
    }
end

function Combat:HandleBulletTP(hitInstance)
    local config = self.Config.BulletTP
    
    if not config.Enabled then return end
    
    local hitPlayer = self:GetPlayerFromHitInstance(hitInstance)
    if not hitPlayer then return end
    
    local localPlayer = Players.LocalPlayer
    if not localPlayer or not localPlayer.Character then return end
    
    local character = localPlayer.Character
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local targetCharacter = hitPlayer.Character
    local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    -- Store original position
    self.Effects.BulletTP.OriginalPosition = root.CFrame
    
    -- Calculate position behind target
    local targetLookVector = targetRoot.CFrame.LookVector
    local positionBehindTarget = targetRoot.Position - (targetLookVector * config.Distance)
    
    -- Teleport behind target
    root.CFrame = CFrame.new(positionBehindTarget, targetRoot.Position)
    
    -- Save teleport time for return teleport
    self.Effects.BulletTP.TeleportTime = tick()
    self.Effects.BulletTP.Active = true
    
    -- Schedule return teleport if enabled
    if config.TeleportBack then
        delay(config.TeleportDelay, function()
            self:ReturnFromBulletTP()
        end)
    end
end

function Combat:ReturnFromBulletTP()
    if not self.Effects.BulletTP.Active then return end
    
    local localPlayer = Players.LocalPlayer
    if not localPlayer or not localPlayer.Character then return end
    
    local root = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- Return to original position
    if self.Effects.BulletTP.OriginalPosition then
        root.CFrame = self.Effects.BulletTP.OriginalPosition
    end
    
    self.Effects.BulletTP.Active = false
    self.Effects.BulletTP.OriginalPosition = nil
end

-- Camera Lock implementation
function Combat:SetupCameraLock()
    self.Effects.CameraLock = {
        Active = false,
        CurrentTarget = nil
    }
end

function Combat:UpdateCameraLock(dt)
    local config = self.Config.CameraLock
    
    if not config.Enabled then
        self.Effects.CameraLock.Active = false
        self.Effects.CameraLock.CurrentTarget = nil
        return
    end
    
    local localPlayer = Players.LocalPlayer
    local camera = workspace.CurrentCamera
    
    if not localPlayer or not localPlayer.Character then return end
    
    -- Find target based on selected method
    local targetPart = nil
    local targetPlayer = nil
    
    if config.Target == "Closest" then
        local closestPlayer, closestDistance = nil, math.huge
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                local part = nil
                
                if config.LockPart == "Head" then
                    part = player.Character:FindFirstChild("Head")
                elseif config.LockPart == "HumanoidRootPart" then
                    part = player.Character:FindFirstChild("HumanoidRootPart")
                elseif config.LockPart == "Torso" then
                    part = player.Character:FindFirstChild("UpperTorso") or player.Character:FindFirstChild("Torso")
                end
                
                if part then
                    local distance = (part.Position - camera.CFrame.Position).Magnitude
                    
                    if distance < closestDistance and distance <= config.MaxDistance then
                        closestPlayer = player
                        targetPart = part
                        closestDistance = distance
                    end
                end
            end
        end
        
        targetPlayer = closestPlayer
    elseif config.Target == "Crosshair" then
        local mousePosition = UserInputService:GetMouseLocation()
        local ray = camera:ViewportPointToRay(mousePosition.X, mousePosition.Y)
        
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = {localPlayer.Character}
        
        local raycastResult = workspace:Raycast(ray.Origin, ray.Direction * config.MaxDistance, raycastParams)
        
        if raycastResult then
            local hitPlayer = self:GetPlayerFromHitInstance(raycastResult.Instance)
            
            if hitPlayer then
                targetPlayer = hitPlayer
                
                if config.LockPart == "Head" then
                    targetPart = hitPlayer.Character:FindFirstChild("Head")
                elseif config.LockPart == "HumanoidRootPart" then
                    targetPart = hitPlayer.Character:FindFirstChild("HumanoidRootPart")
                elseif config.LockPart == "Torso" then
                    targetPart = hitPlayer.Character:FindFirstChild("UpperTorso") or hitPlayer.Character:FindFirstChild("Torso")
                end
            end
        end
    elseif config.Target == "Health" then
        local lowestHealth, lowestHealthPlayer = math.huge, nil
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                
                if humanoid and humanoid.Health > 0 then
                    local part = nil
                    
                    if config.LockPart == "Head" then
                        part = player.Character:FindFirstChild("Head")
                    elseif config.LockPart == "HumanoidRootPart" then
                        part = player.Character:FindFirstChild("HumanoidRootPart")
                    elseif config.LockPart == "Torso" then
                        part = player.Character:FindFirstChild("UpperTorso") or player.Character:FindFirstChild("Torso")
                    end
                    
                    if part then
                        local distance = (part.Position - camera.CFrame.Position).Magnitude
                        
                        if humanoid.Health < lowestHealth and distance <= config.MaxDistance then
                            lowestHealth = humanoid.Health
                            lowestHealthPlayer = player
                            targetPart = part
                        end
                    end
                end
            end
        end
        
        targetPlayer = lowestHealthPlayer
    end
    
    -- Apply camera lock if target found
    if targetPart and targetPlayer then
        local currentCameraCFrame = camera.CFrame
        local targetPosition = targetPart.Position
        
        -- Apply prediction if enabled
        if self.Config.Prediction.Enabled then
            targetPosition = self:ApplyPrediction(targetPosition, targetPart.Velocity)
        end
        
        local targetCFrame = CFrame.new(currentCameraCFrame.Position, targetPosition)
        
        -- Apply smoothing
        local smoothFactor = math.clamp(config.SmoothFactor, 0.01, 1)
        local newCameraCFrame = currentCameraCFrame:Lerp(targetCFrame, smoothFactor)
        
        camera.CFrame = newCameraCFrame
        self.Effects.CameraLock.Active = true
        self.Effects.CameraLock.CurrentTarget = targetPlayer
    else
        self.Effects.CameraLock.Active = false
        self.Effects.CameraLock.CurrentTarget = nil
    end
end

-- FOV Mode implementation
function Combat:SetupFOVMode()
    self.Effects.FOVMode = {
        Active = false,
        Circle = nil
    }
end

function Combat:UpdateFOVMode(dt)
    local config = self.Config.FOVMode
    
    if config.Enabled and not self.Effects.FOVMode.Active then
        -- Create FOV circle
        local circle = Drawing.new("Circle")
        circle.Visible = true
        circle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
        circle.Color = config.Color
        circle.Thickness = 1
        circle.Transparency = config.Transparency
        circle.NumSides = 60
        circle.Radius = config.Size
        circle.Filled = config.Filled
        
        self.Effects.FOVMode.Circle = circle
        self.Effects.FOVMode.Active = true
    elseif not config.Enabled and self.Effects.FOVMode.Active then
        -- Remove FOV circle
        if self.Effects.FOVMode.Circle then
            self.Effects.FOVMode.Circle:Remove()
            self.Effects.FOVMode.Circle = nil
        end
        
        self.Effects.FOVMode.Active = false
    elseif config.Enabled and self.Effects.FOVMode.Active then
        -- Update FOV circle
        local circle = self.Effects.FOVMode.Circle
        if circle then
            circle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
            circle.Color = config.Color
            circle.Transparency = config.Transparency
            circle.Radius = config.Size
            circle.Filled = config.Filled
        end
    end
end

-- Prediction implementation
function Combat:SetupPrediction()
    self.Effects.Prediction = {
        Active = false,
        VisualPart = nil
    }
end

function Combat:ApplyPrediction(position, velocity)
    local config = self.Config.Prediction
    
    if not config.Enabled then return position end
    
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
    local factor = config.Factor
    
    if self.Config.AutoPrediction.Enabled then
        factor = self:CalculateAutoPredictionFactor(ping)
    elseif self.Config.CustomAutoPrediction.Enabled then
        factor = self:CalculateCustomPredictionFactor(ping)
    end
    
    local predictedPosition
    
    if config.Method == "Division" then
        predictedPosition = position + (velocity * (ping / factor))
    elseif config.Method == "Multiplication" then
        predictedPosition = position + (velocity * (ping * factor))
    else
        predictedPosition = position + (velocity * ping)
    end
    
    -- Visualize target if enabled
    if config.VisualizeTarget and self.Effects.CameraLock.CurrentTarget then
        if not self.Effects.Prediction.VisualPart then
            local part = Instance.new("Part")
            part.Anchored = true
            part.CanCollide = false
            part.Size = Vector3.new(0.5, 0.5, 0.5)
            part.Shape = Enum.PartType.Ball
            part.Material = Enum.Material.Neon
            part.Color = config.VisualColor
            part.Transparency = 0.5
            part.Parent = workspace
            
            self.Effects.Prediction.VisualPart = part
        end
        
        self.Effects.Prediction.VisualPart.Position = predictedPosition
        self.Effects.Prediction.Active = true
    elseif self.Effects.Prediction.VisualPart then
        self.Effects.Prediction.VisualPart:Destroy()
        self.Effects.Prediction.VisualPart = nil
        self.Effects.Prediction.Active = false
    end
    
    return predictedPosition
end

-- Auto Prediction implementation
function Combat:SetupAutoPrediction()
    self.Effects.AutoPrediction = {
        Active = false,
        LastAdjustTime = 0,
        CurrentFactor = 1
    }
end

function Combat:CalculateAutoPredictionFactor(ping)
    local config = self.Config.AutoPrediction
    
    if not config.Enabled then return 1 end
    
    local currentTime = tick()
    
    -- Auto adjust based on ping
    if config.AutoAdjust and currentTime - self.Effects.AutoPrediction.LastAdjustTime > 1 then
        local pingBased = math.clamp(ping * 10, config.MinFactor, config.MaxFactor)
        self.Effects.AutoPrediction.CurrentFactor = pingBased
        self.Effects.AutoPrediction.LastAdjustTime = currentTime
    end
    
    return self.Effects.AutoPrediction.CurrentFactor
end

-- Custom Auto Prediction implementation
function Combat:SetupCustomAutoPrediction()
    self.Effects.CustomAutoPrediction = {
        Active = false,
        LastAdjustTime = 0,
        CurrentFactor = 2
    }
end

function Combat:CalculateCustomPredictionFactor(ping)
    local config = self.Config.CustomAutoPrediction
    
    if not config.Enabled then return 1 end
    
    local currentTime = tick()
    
    -- Dynamic scaling based on ping
    if config.DynamicScaling and currentTime - self.Effects.CustomAutoPrediction.LastAdjustTime > 0.5 then
        local pingRatio = math.clamp(ping / config.MaxPing, 0, 1)
        local factorRange = 4
        
        local customFactor = config.BaseFactor + (pingRatio * factorRange)
        self.Effects.CustomAutoPrediction.CurrentFactor = customFactor
        self.Effects.CustomAutoPrediction.LastAdjustTime = currentTime
    end
    
    return self.Effects.CustomAutoPrediction.CurrentFactor
end

-- Helper functions

-- Get player from hit instance
function Combat:GetPlayerFromHitInstance(instance)
    if not instance then return nil end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and instance:IsDescendantOf(player.Character) then
            return player
        end
    end
    
    return nil
end

-- Find closest player to camera
function Combat:FindClosestPlayer(maxDistance)
    local localPlayer = Players.LocalPlayer
    local camera = workspace.CurrentCamera
    local closestPlayer, closestPart, closestDistance = nil, nil, maxDistance or math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local distance = (head.Position - camera.CFrame.Position).Magnitude
                
                if distance < closestDistance then
                    closestPlayer = player
                    closestPart = head
                    closestDistance = distance
                end
            end
        end
    end
    
    return closestPlayer, closestPart, closestDistance
end

-- Find target at crosshair
function Combat:FindCrosshairTarget(maxDistance)
    local localPlayer = Players.LocalPlayer
    local camera = workspace.CurrentCamera
    local mousePosition = UserInputService:GetMouseLocation()
    
    local ray = camera:ViewportPointToRay(mousePosition.X, mousePosition.Y)
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {localPlayer.Character}
    
    local raycastResult = workspace:Raycast(ray.Origin, ray.Direction * (maxDistance or 1000), raycastParams)
    
    if raycastResult then
        local hitPlayer = self:GetPlayerFromHitInstance(raycastResult.Instance)
        
        if hitPlayer then
            return raycastResult.Instance
        end
    end
    
    return nil
end

-- Find random visible player
function Combat:FindRandomVisiblePlayer(maxDistance)
    local localPlayer = Players.LocalPlayer
    local camera = workspace.CurrentCamera
    local visiblePlayers = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local distance = (head.Position - camera.CFrame.Position).Magnitude
                
                if distance <= maxDistance then
                    local rayParams = RaycastParams.new()
                    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                    rayParams.FilterDescendantsInstances = {localPlayer.Character}
                    
                    local direction = (head.Position - camera.CFrame.Position).Unit
                    local result = workspace:Raycast(camera.CFrame.Position, direction * distance, rayParams)
                    
                    if result and self:GetPlayerFromHitInstance(result.Instance) == player then
                        table.insert(visiblePlayers, player)
                    end
                end
            end
        end
    end
    
    if #visiblePlayers > 0 then
        return visiblePlayers[math.random(1, #visiblePlayers)]
    end
    
    return nil
end

-- Set a config value
function Combat:SetConfig(feature, property, value)
    if self.Config[feature] and self.Config[feature][property] ~= nil then
        self.Config[feature][property] = value
        return true
    end
    
    return false
end

return Combat
