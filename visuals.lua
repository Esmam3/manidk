-- WindUI Visual Features
-- Implements visual effects features for WindUI

local Visuals = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Utils = require(script.Parent.utils)

-- Main container for all visual effects
Visuals.Effects = {}

-- Config container for all visual settings
Visuals.Config = {
    Fog = {
        Enabled = false,
        Color = Color3.fromRGB(128, 128, 128),
        Start = 0,
        End = 100,
        Density = 0.5
    },
    Rain = {
        Enabled = false,
        Intensity = 50,
        Size = 0.1,
        Speed = 50
    },
    Ambient = {
        Enabled = false,
        Ambient = Color3.fromRGB(127, 127, 127),
        OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    },
    Clock = {
        Enabled = false,
        Time = 14, -- 24 hour format
        CycleSpeed = 0 -- 0 means static time
    },
    Brightness = {
        Enabled = false,
        Value = 1
    },
    Exposure = {
        Enabled = false,
        Value = 0
    },
    ChinaHat = {
        Enabled = false,
        Color = Color3.fromRGB(255, 0, 0),
        Size = 2,
        Transparency = 0.5
    },
    Capes = {
        Enabled = false,
        Color = Color3.fromRGB(255, 0, 0),
        Texture = "",
        Size = Vector2.new(2, 3),
        Physics = true
    },
    Trail = {
        Enabled = false,
        Color = ColorSequence.new(Color3.fromRGB(255, 0, 0)),
        Transparency = NumberSequence.new(0.5),
        Width = NumberSequence.new(1),
        Lifetime = 1
    },
    Backtrack = {
        Enabled = false,
        Duration = 1, -- seconds
        Color = Color3.fromRGB(255, 0, 0),
        Transparency = 0.5,
        LatencyBased = true
    },
    Balls = {
        Enabled = false,
        Size = 1,
        Color = Color3.fromRGB(255, 0, 0),
        BounceHeight = 1,
        Speed = 1
    },
    Morphs = {
        Enabled = false,
        Selected = "Default"
    }
}

-- Initialize the visual effects module
function Visuals:Init()
    -- Setup fog system
    self:SetupFog()
    
    -- Setup rain system
    self:SetupRain()
    
    -- Setup ambient lighting
    self:SetupAmbient()
    
    -- Setup clock
    self:SetupClock()
    
    -- Setup brightness
    self:SetupBrightness()
    
    -- Setup exposure
    self:SetupExposure()
    
    -- Setup China Hat
    self:SetupChinaHat()
    
    -- Setup Capes
    self:SetupCapes()
    
    -- Setup Trail
    self:SetupTrail()
    
    -- Setup Backtrack
    self:SetupBacktrack()
    
    -- Setup Balls (funny)
    self:SetupBalls()
    
    -- Setup Morphs
    self:SetupMorphs()
    
    -- Connect update loop
    RunService.RenderStepped:Connect(function(dt)
        self:Update(dt)
    end)
    
    return self
end

-- Update method called every frame
function Visuals:Update(dt)
    -- Update fog
    self:UpdateFog(dt)
    
    -- Update rain
    self:UpdateRain(dt)
    
    -- Update clock
    self:UpdateClock(dt)
    
    -- Update China Hat
    self:UpdateChinaHat(dt)
    
    -- Update Capes
    self:UpdateCapes(dt)
    
    -- Update Trail
    self:UpdateTrail(dt)
    
    -- Update Backtrack
    self:UpdateBacktrack(dt)
    
    -- Update Balls
    self:UpdateBalls(dt)
end

-- Fog implementation
function Visuals:SetupFog()
    -- Store original fog settings
    self.OriginalFog = {
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd,
        FogColor = Lighting.FogColor
    }
    
    -- Create atmosphere if needed
    if not Lighting:FindFirstChild("Atmosphere") then
        local atmosphere = Instance.new("Atmosphere")
        atmosphere.Name = "WindUIAtmosphere"
        atmosphere.Parent = Lighting
    end
    
    self.Effects.Fog = {
        Active = false
    }
end

function Visuals:UpdateFog(dt)
    local config = self.Config.Fog
    
    if config.Enabled and not self.Effects.Fog.Active then
        -- Enable fog
        Lighting.FogStart = config.Start
        Lighting.FogEnd = config.End
        Lighting.FogColor = config.Color
        
        local atmosphere = Lighting:FindFirstChild("WindUIAtmosphere")
        if atmosphere then
            atmosphere.Density = config.Density
            atmosphere.Color = config.Color
        end
        
        self.Effects.Fog.Active = true
    elseif not config.Enabled and self.Effects.Fog.Active then
        -- Disable fog, restore original settings
        Lighting.FogStart = self.OriginalFog.FogStart
        Lighting.FogEnd = self.OriginalFog.FogEnd
        Lighting.FogColor = self.OriginalFog.FogColor
        
        local atmosphere = Lighting:FindFirstChild("WindUIAtmosphere")
        if atmosphere then
            atmosphere.Density = 0
        end
        
        self.Effects.Fog.Active = false
    elseif config.Enabled then
        -- Update fog settings if enabled
        Lighting.FogStart = config.Start
        Lighting.FogEnd = config.End
        Lighting.FogColor = config.Color
        
        local atmosphere = Lighting:FindFirstChild("WindUIAtmosphere")
        if atmosphere then
            atmosphere.Density = config.Density
            atmosphere.Color = config.Color
        end
    end
end

-- Rain implementation
function Visuals:SetupRain()
    self.Effects.Rain = {
        Active = false,
        Particles = {},
        Container = nil
    }
end

function Visuals:UpdateRain(dt)
    local config = self.Config.Rain
    
    if config.Enabled and not self.Effects.Rain.Active then
        -- Create rain container if it doesn't exist
        if not self.Effects.Rain.Container then
            local container = Instance.new("Part")
            container.Name = "RainContainer"
            container.Anchored = true
            container.CanCollide = false
            container.Transparency = 1
            container.Size = Vector3.new(50, 1, 50)
            container.Parent = workspace
            
            self.Effects.Rain.Container = container
            
            -- Create rain particles
            local rainEmitter = Instance.new("ParticleEmitter")
            rainEmitter.Rate = config.Intensity
            rainEmitter.Speed = NumberRange.new(config.Speed)
            rainEmitter.Lifetime = NumberRange.new(5)
            rainEmitter.Size = NumberSequence.new(config.Size)
            rainEmitter.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.5),
                NumberSequenceKeypoint.new(1, 0.5)
            })
            rainEmitter.Color = ColorSequence.new(Color3.fromRGB(200, 200, 255))
            rainEmitter.Texture = "rbxassetid://241666073" -- Rain drop texture
            rainEmitter.Acceleration = Vector3.new(0, -workspace.Gravity, 0)
            rainEmitter.Rotation = NumberRange.new(0, 0)
            rainEmitter.RotSpeed = NumberRange.new(0, 0)
            rainEmitter.SpreadAngle = Vector2.new(15, 15)
            rainEmitter.Parent = container
            
            table.insert(self.Effects.Rain.Particles, rainEmitter)
        end
        
        self.Effects.Rain.Active = true
    elseif not config.Enabled and self.Effects.Rain.Active then
        -- Remove rain container and particles
        if self.Effects.Rain.Container then
            self.Effects.Rain.Container:Destroy()
            self.Effects.Rain.Container = nil
            self.Effects.Rain.Particles = {}
        end
        
        self.Effects.Rain.Active = false
    elseif config.Enabled and self.Effects.Rain.Active then
        -- Update rain settings
        if self.Effects.Rain.Container and #self.Effects.Rain.Particles > 0 then
            local rainEmitter = self.Effects.Rain.Particles[1]
            rainEmitter.Rate = config.Intensity
            rainEmitter.Speed = NumberRange.new(config.Speed)
            rainEmitter.Size = NumberSequence.new(config.Size)
            
            -- Position container above camera
            local camera = workspace.CurrentCamera
            if camera then
                self.Effects.Rain.Container.Position = camera.CFrame.Position + Vector3.new(0, 30, 0)
            end
        end
    end
end

-- Ambient lighting implementation
function Visuals:SetupAmbient()
    -- Store original ambient settings
    self.OriginalAmbient = {
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient
    }
    
    self.Effects.Ambient = {
        Active = false
    }
end

function Visuals:UpdateAmbient()
    local config = self.Config.Ambient
    
    if config.Enabled and not self.Effects.Ambient.Active then
        -- Enable custom ambient
        Lighting.Ambient = config.Ambient
        Lighting.OutdoorAmbient = config.OutdoorAmbient
        
        self.Effects.Ambient.Active = true
    elseif not config.Enabled and self.Effects.Ambient.Active then
        -- Disable custom ambient, restore original
        Lighting.Ambient = self.OriginalAmbient.Ambient
        Lighting.OutdoorAmbient = self.OriginalAmbient.OutdoorAmbient
        
        self.Effects.Ambient.Active = false
    elseif config.Enabled then
        -- Update ambient settings
        Lighting.Ambient = config.Ambient
        Lighting.OutdoorAmbient = config.OutdoorAmbient
    end
end

-- Clock implementation
function Visuals:SetupClock()
    -- Store original clock time
    self.OriginalClock = {
        ClockTime = Lighting.ClockTime,
        TimeOfDay = Lighting.TimeOfDay
    }
    
    self.Effects.Clock = {
        Active = false,
        ElapsedTime = 0
    }
end

function Visuals:UpdateClock(dt)
    local config = self.Config.Clock
    
    if config.Enabled and not self.Effects.Clock.Active then
        -- Enable custom clock time
        Lighting.ClockTime = config.Time
        
        self.Effects.Clock.Active = true
    elseif not config.Enabled and self.Effects.Clock.Active then
        -- Disable custom clock, restore original
        Lighting.ClockTime = self.OriginalClock.ClockTime
        
        self.Effects.Clock.Active = false
        self.Effects.Clock.ElapsedTime = 0
    elseif config.Enabled then
        -- Update clock
        if config.CycleSpeed > 0 then
            self.Effects.Clock.ElapsedTime = self.Effects.Clock.ElapsedTime + dt * config.CycleSpeed
            local cycleClock = (config.Time + self.Effects.Clock.ElapsedTime) % 24
            Lighting.ClockTime = cycleClock
        else
            -- Static time
            Lighting.ClockTime = config.Time
        end
    end
end

-- Brightness implementation
function Visuals:SetupBrightness()
    -- Store original brightness
    self.OriginalBrightness = Lighting.Brightness
    
    self.Effects.Brightness = {
        Active = false
    }
end

function Visuals:UpdateBrightness()
    local config = self.Config.Brightness
    
    if config.Enabled and not self.Effects.Brightness.Active then
        -- Enable custom brightness
        Lighting.Brightness = config.Value
        
        self.Effects.Brightness.Active = true
    elseif not config.Enabled and self.Effects.Brightness.Active then
        -- Disable custom brightness, restore original
        Lighting.Brightness = self.OriginalBrightness
        
        self.Effects.Brightness.Active = false
    elseif config.Enabled then
        -- Update brightness
        Lighting.Brightness = config.Value
    end
end

-- Exposure implementation
function Visuals:SetupExposure()
    -- Create exposure effect if needed
    if not Lighting:FindFirstChild("WindUIExposure") then
        local exposure = Instance.new("BloomEffect")
        exposure.Name = "WindUIExposure"
        exposure.Enabled = false
        exposure.Intensity = 0.5
        exposure.Size = 20
        exposure.Threshold = 0.8
        exposure.Parent = Lighting
    end
    
    self.Effects.Exposure = {
        Active = false
    }
end

function Visuals:UpdateExposure()
    local config = self.Config.Exposure
    local exposure = Lighting:FindFirstChild("WindUIExposure")
    
    if not exposure then
        return
    end
    
    if config.Enabled and not self.Effects.Exposure.Active then
        -- Enable exposure
        exposure.Enabled = true
        exposure.Intensity = config.Value
        
        self.Effects.Exposure.Active = true
    elseif not config.Enabled and self.Effects.Exposure.Active then
        -- Disable exposure
        exposure.Enabled = false
        
        self.Effects.Exposure.Active = false
    elseif config.Enabled then
        -- Update exposure
        exposure.Intensity = config.Value
    end
end

-- China Hat implementation
function Visuals:SetupChinaHat()
    self.Effects.ChinaHat = {
        Active = false,
        Model = nil
    }
end

function Visuals:UpdateChinaHat(dt)
    local config = self.Config.ChinaHat
    local localPlayer = Players.LocalPlayer
    
    if not localPlayer or not localPlayer.Character then
        return
    end
    
    if config.Enabled and not self.Effects.ChinaHat.Active then
        -- Create China Hat model
        local hatModel = Instance.new("Model")
        hatModel.Name = "ChinaHat"
        
        -- Create cone mesh
        local conePart = Instance.new("Part")
        conePart.Name = "Cone"
        conePart.Anchored = true
        conePart.CanCollide = false
        conePart.Transparency = config.Transparency
        conePart.Color = config.Color
        conePart.Size = Vector3.new(config.Size, config.Size, config.Size)
        conePart.Parent = hatModel
        
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://1033714"  -- Cone mesh
        mesh.Scale = Vector3.new(1, 1, 1)
        mesh.Parent = conePart
        
        hatModel.Parent = workspace
        self.Effects.ChinaHat.Model = hatModel
        self.Effects.ChinaHat.Active = true
    elseif not config.Enabled and self.Effects.ChinaHat.Active then
        -- Remove China Hat model
        if self.Effects.ChinaHat.Model then
            self.Effects.ChinaHat.Model:Destroy()
            self.Effects.ChinaHat.Model = nil
        end
        
        self.Effects.ChinaHat.Active = false
    elseif config.Enabled and self.Effects.ChinaHat.Active then
        -- Update China Hat position
        local head = localPlayer.Character:FindFirstChild("Head")
        if head and self.Effects.ChinaHat.Model then
            local conePart = self.Effects.ChinaHat.Model:FindFirstChild("Cone")
            if conePart then
                conePart.Color = config.Color
                conePart.Transparency = config.Transparency
                conePart.Size = Vector3.new(config.Size, config.Size, config.Size)
                conePart.CFrame = head.CFrame * CFrame.new(0, 1, 0) * CFrame.Angles(math.rad(180), 0, 0)
            end
        end
    end
end

-- Capes implementation
function Visuals:SetupCapes()
    self.Effects.Capes = {
        Active = false,
        Cape = nil
    }
end

function Visuals:UpdateCapes(dt)
    local config = self.Config.Capes
    local localPlayer = Players.LocalPlayer
    
    if not localPlayer or not localPlayer.Character then
        return
    end
    
    if config.Enabled and not self.Effects.Capes.Active then
        -- Create cape
        local character = localPlayer.Character
        local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
        
        if torso then
            local cape = Instance.new("Part")
            cape.Name = "WindUICape"
            cape.Anchored = false
            cape.CanCollide = false
            cape.Transparency = 0
            cape.Color = config.Color
            cape.Size = Vector3.new(0.1, config.Size.Y, config.Size.X)
            cape.Material = Enum.Material.SmoothPlastic
            
            -- Create mesh
            local mesh = Instance.new("BlockMesh")
            mesh.Scale = Vector3.new(0.1, 1, 1)
            mesh.Parent = cape
            
            -- Add texture if specified
            if config.Texture ~= "" then
                local decal = Instance.new("Decal")
                decal.Face = Enum.NormalId.Back
                decal.Texture = config.Texture
                decal.Parent = cape
            end
            
            -- Create attachment points
            local attachment1 = Instance.new("Attachment")
            attachment1.Position = Vector3.new(0, config.Size.Y/2, 0)
            attachment1.Parent = cape
            
            local attachment2 = Instance.new("Attachment")
            attachment2.Position = Vector3.new(0, -config.Size.Y/2, 0)
            attachment2.Parent = cape
            
            -- Create weld constraint to attach to torso
            local weld = Instance.new("Weld")
            weld.Part0 = torso
            weld.Part1 = cape
            weld.C0 = CFrame.new(0, 0, 0.9)
            weld.Parent = cape
            
            -- Add rope constraint for physics if enabled
            if config.Physics then
                local constraint = Instance.new("RopeConstraint")
                constraint.Attachment0 = attachment1
                constraint.Attachment1 = attachment2
                constraint.Length = config.Size.Y
                constraint.Thickness = 0.1
                constraint.Parent = cape
            end
            
            cape.Parent = character
            self.Effects.Capes.Cape = cape
            self.Effects.Capes.Active = true
        end
    elseif not config.Enabled and self.Effects.Capes.Active then
        -- Remove cape
        if self.Effects.Capes.Cape then
            self.Effects.Capes.Cape:Destroy()
            self.Effects.Capes.Cape = nil
        end
        
        self.Effects.Capes.Active = false
    elseif config.Enabled and self.Effects.Capes.Active then
        -- Update cape
        local cape = self.Effects.Capes.Cape
        if cape then
            cape.Color = config.Color
            cape.Size = Vector3.new(0.1, config.Size.Y, config.Size.X)
            
            -- Update physics if changed
            local constraint = cape:FindFirstChildOfClass("RopeConstraint")
            if config.Physics and not constraint then
                local attachment1 = cape:FindFirstChild("Attachment")
                local attachment2 = cape:FindFirstChild("Attachment", 1)
                
                if attachment1 and attachment2 then
                    constraint = Instance.new("RopeConstraint")
                    constraint.Attachment0 = attachment1
                    constraint.Attachment1 = attachment2
                    constraint.Length = config.Size.Y
                    constraint.Thickness = 0.1
                    constraint.Parent = cape
                end
            elseif not config.Physics and constraint then
                constraint:Destroy()
            end
            
            -- Update texture if changed
            local decal = cape:FindFirstChildOfClass("Decal")
            if config.Texture ~= "" and not decal then
                decal = Instance.new("Decal")
                decal.Face = Enum.NormalId.Back
                decal.Texture = config.Texture
                decal.Parent = cape
            elseif config.Texture ~= "" and decal then
                decal.Texture = config.Texture
            elseif config.Texture == "" and decal then
                decal:Destroy()
            end
        end
    end
end

-- Trail implementation
function Visuals:SetupTrail()
    self.Effects.Trail = {
        Active = false,
        Trail = nil,
        Attachment1 = nil,
        Attachment2 = nil
    }
end

function Visuals:UpdateTrail(dt)
    local config = self.Config.Trail
    local localPlayer = Players.LocalPlayer
    
    if not localPlayer or not localPlayer.Character then
        return
    end
    
    if config.Enabled and not self.Effects.Trail.Active then
        -- Create trail
        local character = localPlayer.Character
        local root = character:FindFirstChild("HumanoidRootPart")
        
        if root then
            -- Create attachments
            local attachment1 = Instance.new("Attachment")
            attachment1.Name = "TrailAttachment1"
            attachment1.Position = Vector3.new(0, -1, 0)
            attachment1.Parent = root
            
            local attachment2 = Instance.new("Attachment")
            attachment2.Name = "TrailAttachment2"
            attachment2.Position = Vector3.new(0, 1, 0)
            attachment2.Parent = root
            
            -- Create trail
            local trail = Instance.new("Trail")
            trail.Attachment0 = attachment1
            trail.Attachment1 = attachment2
            trail.Color = config.Color
            trail.Transparency = config.Transparency
            trail.WidthScale = config.Width
            trail.Lifetime = config.Lifetime
            trail.Parent = root
            
            self.Effects.Trail.Trail = trail
            self.Effects.Trail.Attachment1 = attachment1
            self.Effects.Trail.Attachment2 = attachment2
            self.Effects.Trail.Active = true
        end
    elseif not config.Enabled and self.Effects.Trail.Active then
        -- Remove trail
        if self.Effects.Trail.Trail then
            self.Effects.Trail.Trail:Destroy()
            self.Effects.Trail.Trail = nil
        end
        
        if self.Effects.Trail.Attachment1 then
            self.Effects.Trail.Attachment1:Destroy()
            self.Effects.Trail.Attachment1 = nil
        end
        
        if self.Effects.Trail.Attachment2 then
            self.Effects.Trail.Attachment2:Destroy()
            self.Effects.Trail.Attachment2 = nil
        end
        
        self.Effects.Trail.Active = false
    elseif config.Enabled and self.Effects.Trail.Active then
        -- Update trail
        local trail = self.Effects.Trail.Trail
        if trail then
            trail.Color = config.Color
            trail.Transparency = config.Transparency
            trail.WidthScale = config.Width
            trail.Lifetime = config.Lifetime
        end
    end
end

-- Backtrack implementation
function Visuals:SetupBacktrack()
    self.Effects.Backtrack = {
        Active = false,
        Positions = {},
        Parts = {}
    }
end

function Visuals:UpdateBacktrack(dt)
    local config = self.Config.Backtrack
    
    if config.Enabled and not self.Effects.Backtrack.Active then
        -- Initialize backtrack
        self.Effects.Backtrack.Positions = {}
        self.Effects.Backtrack.Parts = {}
        self.Effects.Backtrack.Active = true
    elseif not config.Enabled and self.Effects.Backtrack.Active then
        -- Clear backtrack parts
        for _, part in pairs(self.Effects.Backtrack.Parts) do
            part:Destroy()
        end
        
        self.Effects.Backtrack.Positions = {}
        self.Effects.Backtrack.Parts = {}
        self.Effects.Backtrack.Active = false
    elseif config.Enabled then
        -- Update backtrack
        local duration = config.Duration
        if config.LatencyBased then
            -- Use ping for backtrack duration
            local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
            duration = math.min(ping, 1) -- Cap at 1 second to prevent excessive backtrack
        end
        
        -- Record positions for all players
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer and player.Character then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    -- Store position and timestamp
                    if not self.Effects.Backtrack.Positions[player.Name] then
                        self.Effects.Backtrack.Positions[player.Name] = {}
                    end
                    
                    table.insert(self.Effects.Backtrack.Positions[player.Name], {
                        Position = root.Position,
                        CFrame = root.CFrame,
                        Time = tick()
                    })
                    
                    -- Remove positions older than duration
                    local currentTime = tick()
                    local newPositions = {}
                    for _, posData in ipairs(self.Effects.Backtrack.Positions[player.Name]) do
                        if currentTime - posData.Time <= duration then
                            table.insert(newPositions, posData)
                        end
                    end
                    
                    self.Effects.Backtrack.Positions[player.Name] = newPositions
                    
                    -- Create or update backtrack parts
                    for i, posData in ipairs(self.Effects.Backtrack.Positions[player.Name]) do
                        local partKey = player.Name .. "_" .. i
                        
                        if not self.Effects.Backtrack.Parts[partKey] then
                            local part = Instance.new("Part")
                            part.Name = "Backtrack_" .. player.Name
                            part.Anchored = true
                            part.CanCollide = false
                            part.Transparency = config.Transparency
                            part.Color = config.Color
                            part.Size = Vector3.new(root.Size.X, root.Size.Y, root.Size.Z)
                            part.Material = Enum.Material.ForceField
                            part.Parent = workspace
                            
                            self.Effects.Backtrack.Parts[partKey] = part
                        end
                        
                        local part = self.Effects.Backtrack.Parts[partKey]
                        part.CFrame = posData.CFrame
                        
                        -- Fade out older positions
                        local age = (currentTime - posData.Time) / duration
                        part.Transparency = config.Transparency + age * (1 - config.Transparency)
                    end
                end
            end
        end
        
        -- Clean up unused parts
        for partKey, part in pairs(self.Effects.Backtrack.Parts) do
            local playerName = partKey:match("^(.-)_")
            local positions = self.Effects.Backtrack.Positions[playerName]
            
            if not positions then
                part:Destroy()
                self.Effects.Backtrack.Parts[partKey] = nil
            end
        end
    end
end

-- Balls (funny) implementation
function Visuals:SetupBalls()
    self.Effects.Balls = {
        Active = false,
        Balls = {},
        LastSpawn = 0
    }
end

function Visuals:UpdateBalls(dt)
    local config = self.Config.Balls
    local localPlayer = Players.LocalPlayer
    
    if not localPlayer or not localPlayer.Character then
        return
    end
    
    if config.Enabled and not self.Effects.Balls.Active then
        -- Initialize balls
        self.Effects.Balls.Balls = {}
        self.Effects.Balls.Active = true
    elseif not config.Enabled and self.Effects.Balls.Active then
        -- Clear balls
        for _, ball in pairs(self.Effects.Balls.Balls) do
            ball:Destroy()
        end
        
        self.Effects.Balls.Balls = {}
        self.Effects.Balls.Active = false
    elseif config.Enabled then
        -- Update balls
        local character = localPlayer.Character
        local root = character:FindFirstChild("HumanoidRootPart")
        
        if root then
            -- Create new ball occasionally based on speed
            local currentTime = tick()
            if currentTime - self.Effects.Balls.LastSpawn > (1 / config.Speed) then
                -- Create ball
                local ball = Instance.new("Part")
                ball.Name = "FunnyBall"
                ball.Shape = Enum.PartType.Ball
                ball.Anchored = true
                ball.CanCollide = false
                ball.Color = config.Color
                ball.Material = Enum.Material.Neon
                ball.Size = Vector3.new(config.Size, config.Size, config.Size)
                ball.Position = root.Position - Vector3.new(0, 1, 0)
                ball.Parent = workspace
                
                -- Store ball data
                table.insert(self.Effects.Balls.Balls, {
                    Part = ball,
                    CreationTime = currentTime,
                    InitialPosition = ball.Position,
                    Phase = 0
                })
                
                self.Effects.Balls.LastSpawn = currentTime
            end
            
            -- Update ball positions with bouncing effect
            local ballsToRemove = {}
            
            for i, ballData in ipairs(self.Effects.Balls.Balls) do
                local age = currentTime - ballData.CreationTime
                local ball = ballData.Part
                
                if age > 3 then
                    -- Mark for removal if too old
                    table.insert(ballsToRemove, i)
                else
                    -- Update ball phase and position
                    ballData.Phase = ballData.Phase + dt * config.Speed * 2
                    
                    -- Calculate bounce height using sine wave
                    local height = math.abs(math.sin(ballData.Phase)) * config.BounceHeight
                    
                    -- Move ball slightly away from player
                    local offset = (ball.Position - root.Position).Unit * (age * 2)
                    
                    -- Set new position with bouncing
                    ball.Position = ballData.InitialPosition + offset + Vector3.new(0, height, 0)
                    
                    -- Fade out over time
                    ball.Transparency = age / 3
                end
            end
            
            -- Remove old balls
            for i = #ballsToRemove, 1, -1 do
                local index = ballsToRemove[i]
                self.Effects.Balls.Balls[index].Part:Destroy()
                table.remove(self.Effects.Balls.Balls, index)
            end
        end
    end
end

-- Morphs implementation
function Visuals:SetupMorphs()
    self.Effects.Morphs = {
        Active = false,
        CurrentMorph = nil,
        OriginalAppearance = nil
    }
    
    -- Define available morphs
    self.AvailableMorphs = {
        Default = { -- Return to original appearance
            Description = "Default appearance"
        },
        Zombie = {
            Description = "Zombie appearance",
            BodyColors = {
                HeadColor3 = Color3.fromRGB(0, 180, 0),
                LeftArmColor3 = Color3.fromRGB(0, 180, 0),
                RightArmColor3 = Color3.fromRGB(0, 180, 0),
                LeftLegColor3 = Color3.fromRGB(0, 180, 0),
                RightLegColor3 = Color3.fromRGB(0, 180, 0),
                TorsoColor3 = Color3.fromRGB(0, 180, 0)
            },
            Animation = "rbxassetid://616158929", -- Zombie idle
            WalkSpeed = 12,
            JumpPower = 40
        },
        Robot = {
            Description = "Robot appearance",
            BodyColors = {
                HeadColor3 = Color3.fromRGB(120, 120, 120),
                LeftArmColor3 = Color3.fromRGB(120, 120, 120),
                RightArmColor3 = Color3.fromRGB(120, 120, 120),
                LeftLegColor3 = Color3.fromRGB(120, 120, 120),
                RightLegColor3 = Color3.fromRGB(120, 120, 120),
                TorsoColor3 = Color3.fromRGB(80, 80, 80)
            },
            Animation = "rbxassetid://616117076", -- Robot idle
            WalkSpeed = 20,
            JumpPower = 60
        },
        Ghost = {
            Description = "Ghost appearance",
            Transparency = 0.7,
            Animation = "rbxassetid://616168032", -- Ghost idle
            WalkSpeed = 25,
            JumpPower = 70
        }
    }
end

function Visuals:UpdateMorphs()
    local config = self.Config.Morphs
    local localPlayer = Players.LocalPlayer
    
    if not localPlayer or not localPlayer.Character then
        return
    end
    
    if config.Enabled and not self.Effects.Morphs.Active then
        -- Store original appearance
        local character = localPlayer.Character
        local humanoid = character:FindFirstChild("Humanoid")
        
        if humanoid then
            self.Effects.Morphs.OriginalAppearance = {
                WalkSpeed = humanoid.WalkSpeed,
                JumpPower = humanoid.JumpPower
            }
            
            -- Store body colors
            local bodyColors = character:FindFirstChild("BodyColors")
            if bodyColors then
                self.Effects.Morphs.OriginalAppearance.BodyColors = {
                    HeadColor3 = bodyColors.HeadColor3,
                    LeftArmColor3 = bodyColors.LeftArmColor3,
                    RightArmColor3 = bodyColors.RightArmColor3,
                    LeftLegColor3 = bodyColors.LeftLegColor3,
                    RightLegColor3 = bodyColors.RightLegColor3,
                    TorsoColor3 = bodyColors.TorsoColor3
                }
            end
            
            -- Store transparencies
            self.Effects.Morphs.OriginalAppearance.Transparencies = {}
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    self.Effects.Morphs.OriginalAppearance.Transparencies[part] = part.Transparency
                end
            end
            
            -- Apply selected morph
            self:ApplyMorph(config.Selected)
            
            self.Effects.Morphs.Active = true
        end
    elseif not config.Enabled and self.Effects.Morphs.Active then
        -- Restore original appearance
        self:ApplyMorph("Default")
        
        self.Effects.Morphs.Active = false
        self.Effects.Morphs.CurrentMorph = nil
    elseif config.Enabled and self.Effects.Morphs.Active and self.Effects.Morphs.CurrentMorph ~= config.Selected then
        -- Change to new morph
        self:ApplyMorph(config.Selected)
    end
end

function Visuals:ApplyMorph(morphName)
    local localPlayer = Players.LocalPlayer
    
    if not localPlayer or not localPlayer.Character then
        return
    end
    
    local character = localPlayer.Character
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not humanoid then
        return
    end
    
    -- Stop existing animations
    if self.Effects.Morphs.CurrentAnimation then
        self.Effects.Morphs.CurrentAnimation:Stop()
        self.Effects.Morphs.CurrentAnimation = nil
    end
    
    if morphName == "Default" and self.Effects.Morphs.OriginalAppearance then
        -- Restore original appearance
        humanoid.WalkSpeed = self.Effects.Morphs.OriginalAppearance.WalkSpeed
        humanoid.JumpPower = self.Effects.Morphs.OriginalAppearance.JumpPower
        
        -- Restore body colors
        local bodyColors = character:FindFirstChild("BodyColors")
        if bodyColors and self.Effects.Morphs.OriginalAppearance.BodyColors then
            for prop, color in pairs(self.Effects.Morphs.OriginalAppearance.BodyColors) do
                bodyColors[prop] = color
            end
        end
        
        -- Restore transparencies
        if self.Effects.Morphs.OriginalAppearance.Transparencies then
            for part, transparency in pairs(self.Effects.Morphs.OriginalAppearance.Transparencies) do
                if part and part:IsA("BasePart") then
                    part.Transparency = transparency
                end
            end
        end
    else
        -- Apply morph
        local morph = self.AvailableMorphs[morphName]
        if not morph then
            return
        end
        
        -- Apply body colors
        if morph.BodyColors then
            local bodyColors = character:FindFirstChild("BodyColors") or Instance.new("BodyColors", character)
            for prop, color in pairs(morph.BodyColors) do
                bodyColors[prop] = color
            end
        end
        
        -- Apply transparency
        if morph.Transparency then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = morph.Transparency
                end
            end
        end
        
        -- Apply movement changes
        if morph.WalkSpeed then
            humanoid.WalkSpeed = morph.WalkSpeed
        end
        
        if morph.JumpPower then
            humanoid.JumpPower = morph.JumpPower
        end
        
        -- Apply animation if provided
        if morph.Animation then
            local anim = Instance.new("Animation")
            anim.AnimationId = morph.Animation
            
            local animTrack = humanoid:LoadAnimation(anim)
            animTrack:Play()
            
            self.Effects.Morphs.CurrentAnimation = animTrack
        end
    end
    
    self.Effects.Morphs.CurrentMorph = morphName
end

-- Set a config value
function Visuals:SetConfig(feature, property, value)
    if self.Config[feature] and self.Config[feature][property] ~= nil then
        self.Config[feature][property] = value
        
        -- Update the effect immediately
        if feature == "Fog" then self:UpdateFog()
        elseif feature == "Rain" then self:UpdateRain()
        elseif feature == "Ambient" then self:UpdateAmbient()
        elseif feature == "Clock" then self:UpdateClock(0)
        elseif feature == "Brightness" then self:UpdateBrightness()
        elseif feature == "Exposure" then self:UpdateExposure()
        elseif feature == "ChinaHat" then self:UpdateChinaHat(0)
        elseif feature == "Capes" then self:UpdateCapes(0)
        elseif feature == "Trail" then self:UpdateTrail(0)
        elseif feature == "Backtrack" then self:UpdateBacktrack(0)
        elseif feature == "Balls" then self:UpdateBalls(0)
        elseif feature == "Morphs" then self:UpdateMorphs()
        end
        
        return true
    end
    
    return false
end

-- Get all available morphs
function Visuals:GetAvailableMorphs()
    local morphs = {}
    
    for name, data in pairs(self.AvailableMorphs) do
        table.insert(morphs, {
            Name = name,
            Description = data.Description
        })
    end
    
    return morphs
end

return Visuals
