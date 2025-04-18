-- WindUI Feature Utilities
-- Provides common utility functions for feature implementations

local Utils = {}

-- Check if a player/character is visible from a position
function Utils:IsVisible(fromPosition, toPosition)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}
    
    local direction = (toPosition - fromPosition).Unit
    local result = workspace:Raycast(fromPosition, direction * 1000, rayParams)
    
    return result and result.Instance:IsDescendantOf(game.Players.LocalPlayer.Character) or false
end

-- Get character root part with error handling
function Utils:GetCharacterRoot(player)
    if not player or not player.Character then return nil end
    return player.Character:FindFirstChild("HumanoidRootPart")
end

-- Get character head with error handling
function Utils:GetCharacterHead(player)
    if not player or not player.Character then return nil end
    return player.Character:FindFirstChild("Head")
end

-- Get all player characters except local player
function Utils:GetEnemyCharacters()
    local characters = {}
    local localPlayer = game.Players.LocalPlayer
    
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            table.insert(characters, player.Character)
        end
    end
    
    return characters
end

-- Create a part with specified properties
function Utils:CreatePart(properties)
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    
    for property, value in pairs(properties or {}) do
        part[property] = value
    end
    
    return part
end

-- Create a beam with specified properties
function Utils:CreateBeam(attachment0, attachment1, properties)
    local beam = Instance.new("Beam")
    beam.Attachment0 = attachment0
    beam.Attachment1 = attachment1
    
    for property, value in pairs(properties or {}) do
        beam[property] = value
    end
    
    return beam
end

-- Create an attachment with specified properties
function Utils:CreateAttachment(parent, position, properties)
    local attachment = Instance.new("Attachment")
    attachment.Parent = parent
    attachment.Position = position or Vector3.new(0, 0, 0)
    
    for property, value in pairs(properties or {}) do
        attachment[property] = value
    end
    
    return attachment
end

-- Create a billboard gui with specified properties
function Utils:CreateBillboardGui(properties)
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.AlwaysOnTop = true
    billboardGui.Size = UDim2.new(0, 100, 0, 100)
    
    for property, value in pairs(properties or {}) do
        billboardGui[property] = value
    end
    
    return billboardGui
end

-- Create a trail with specified properties
function Utils:CreateTrail(attachment0, attachment1, properties)
    local trail = Instance.new("Trail")
    trail.Attachment0 = attachment0
    trail.Attachment1 = attachment1
    
    for property, value in pairs(properties or {}) do
        trail[property] = value
    end
    
    return trail
end

-- Play sound at specified position
function Utils:PlaySound(soundId, position, properties)
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    
    for property, value in pairs(properties or {}) do
        sound[property] = value
    end
    
    if position then
        local part = Instance.new("Part")
        part.Anchored = true
        part.CanCollide = false
        part.Transparency = 1
        part.Position = position
        part.Parent = workspace
        sound.Parent = part
        
        -- Clean up after playing
        sound.Ended:Connect(function()
            part:Destroy()
        end)
    end
    
    sound:Play()
    return sound
end

-- Calculate hit position using prediction
function Utils:PredictHitPosition(target, method, pingMultiplier)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return nil end
    
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
    local velocity = target.HumanoidRootPart.Velocity
    local position = target.HumanoidRootPart.Position
    
    pingMultiplier = pingMultiplier or 1
    
    if method == "Division" then
        return position + (velocity * (ping / pingMultiplier))
    elseif method == "Multiplication" then
        return position + (velocity * (ping * pingMultiplier))
    else -- Default
        return position + (velocity * ping)
    end
end

-- Check distance between two vectors
function Utils:Distance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

-- Check if a point is within a field of view
function Utils:IsInFOV(from, to, fovAngle)
    local direction = (to - from).Unit
    local lookVector = workspace.CurrentCamera.CFrame.LookVector
    
    local angle = math.acos(direction:Dot(lookVector))
    return math.deg(angle) <= fovAngle / 2
end

return Utils
