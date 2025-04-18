-- WindUI User Interface Module
-- Implements UI for controlling WindUI features

local UI = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Store references to other modules
UI.WindUI = nil
UI.Visuals = nil
UI.Combat = nil
UI.Settings = nil

-- UI Elements
UI.Elements = {
    MainMenu = nil,
    Tabs = {},
    Notifications = {}
}

-- Initialize the UI module
function UI:Init(windUI, visuals, combat, settings)
    self.WindUI = windUI
    self.Visuals = visuals
    self.Combat = combat
    self.Settings = settings
    
    -- Create main UI
    self:CreateMainMenu()
    
    -- Connect update loop
    RunService.RenderStepped:Connect(function(dt)
        self:Update(dt)
    end)
    
    return self
end

-- Main update loop
function UI:Update(dt)
    -- Update notifications
    self:UpdateNotifications(dt)
end

-- Create main menu UI
function UI:CreateMainMenu()
    -- Check if WindUI is available
    if not self.WindUI then
        warn("UI Module: WindUI not found, creating fallback UI.")
        self:CreateFallbackUI()
        return
    end
    
    -- Use WindUI to create the interface
    local menu = self.WindUI.Create("Window", {
        Title = "WindUI Features",
        Size = Vector2.new(600, 400),
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Draggable = true,
        Resizable = true
    })
    
    -- Create tabs
    local visualsTab = self.WindUI.Create("Tab", {
        Parent = menu,
        Title = "Visuals"
    })
    
    local combatTab = self.WindUI.Create("Tab", {
        Parent = menu,
        Title = "Combat"
    })
    
    local settingsTab = self.WindUI.Create("Tab", {
        Parent = menu,
        Title = "Settings"
    })
    
    -- Populate tabs with controls
    self:PopulateVisualsTab(visualsTab)
    self:PopulateCombatTab(combatTab)
    self:PopulateSettingsTab(settingsTab)
    
    -- Store references
    self.Elements.MainMenu = menu
    self.Elements.Tabs.Visuals = visualsTab
    self.Elements.Tabs.Combat = combatTab
    self.Elements.Tabs.Settings = settingsTab
    
    -- Hide menu initially
    menu.Visible = false
end

-- Create fallback UI when WindUI is not available
function UI:CreateFallbackUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "WindUIFeaturesFallback"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 1000
    
    -- Create main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Create title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(1, -40, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 16
    titleText.Font = Enum.Font.SourceSansBold
    titleText.Text = "WindUI Features"
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.BackgroundTransparency = 1
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 16
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Text = "X"
    closeButton.Parent = titleBar
    
    -- Create tab buttons
    local tabButtons = Instance.new("Frame")
    tabButtons.Name = "TabButtons"
    tabButtons.Size = UDim2.new(1, 0, 0, 30)
    tabButtons.Position = UDim2.new(0, 0, 0, 30)
    tabButtons.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tabButtons.BorderSizePixel = 0
    tabButtons.Parent = mainFrame
    
    local visualsButton = Instance.new("TextButton")
    visualsButton.Name = "VisualsButton"
    visualsButton.Size = UDim2.new(0, 100, 1, 0)
    visualsButton.Position = UDim2.new(0, 0, 0, 0)
    visualsButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    visualsButton.BorderSizePixel = 0
    visualsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    visualsButton.TextSize = 14
    visualsButton.Font = Enum.Font.SourceSans
    visualsButton.Text = "Visuals"
    visualsButton.Parent = tabButtons
    
    local combatButton = Instance.new("TextButton")
    combatButton.Name = "CombatButton"
    combatButton.Size = UDim2.new(0, 100, 1, 0)
    combatButton.Position = UDim2.new(0, 100, 0, 0)
    combatButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    combatButton.BorderSizePixel = 0
    combatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    combatButton.TextSize = 14
    combatButton.Font = Enum.Font.SourceSans
    combatButton.Text = "Combat"
    combatButton.Parent = tabButtons
    
    local settingsButton = Instance.new("TextButton")
    settingsButton.Name = "SettingsButton"
    settingsButton.Size = UDim2.new(0, 100, 1, 0)
    settingsButton.Position = UDim2.new(0, 200, 0, 0)
    settingsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    settingsButton.BorderSizePixel = 0
    settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    settingsButton.TextSize = 14
    settingsButton.Font = Enum.Font.SourceSans
    settingsButton.Text = "Settings"
    settingsButton.Parent = tabButtons
    
    -- Create content frames
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, 0, 1, -60)
    contentContainer.Position = UDim2.new(0, 0, 0, 60)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = mainFrame
    
    local visualsTab = Instance.new("ScrollingFrame")
    visualsTab.Name = "VisualsTab"
    visualsTab.Size = UDim2.new(1, 0, 1, 0)
    visualsTab.BackgroundTransparency = 1
    visualsTab.BorderSizePixel = 0
    visualsTab.ScrollBarThickness = 6
    visualsTab.Visible = true
    visualsTab.Parent = contentContainer
    
    local combatTab = Instance.new("ScrollingFrame")
    combatTab.Name = "CombatTab"
    combatTab.Size = UDim2.new(1, 0, 1, 0)
    combatTab.BackgroundTransparency = 1
    combatTab.BorderSizePixel = 0
    combatTab.ScrollBarThickness = 6
    combatTab.Visible = false
    combatTab.Parent = contentContainer
    
    local settingsTab = Instance.new("ScrollingFrame")
    settingsTab.Name = "SettingsTab"
    settingsTab.Size = UDim2.new(1, 0, 1, 0)
    settingsTab.BackgroundTransparency = 1
    settingsTab.BorderSizePixel = 0
    settingsTab.ScrollBarThickness = 6
    settingsTab.Visible = false
    settingsTab.Parent = contentContainer
    
    -- Add tab switching logic
    visualsButton.MouseButton1Click:Connect(function()
        visualsTab.Visible = true
        combatTab.Visible = false
        settingsTab.Visible = false
        
        visualsButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        combatButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        settingsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)
    
    combatButton.MouseButton1Click:Connect(function()
        visualsTab.Visible = false
        combatTab.Visible = true
        settingsTab.Visible = false
        
        visualsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        combatButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        settingsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)
    
    settingsButton.MouseButton1Click:Connect(function()
        visualsTab.Visible = false
        combatTab.Visible = false
        settingsTab.Visible = true
        
        visualsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        combatButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        settingsButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)
    
    -- Add close button logic
    closeButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
    end)
    
    -- Store references
    self.Elements.MainMenu = screenGui
    self.Elements.Tabs.Visuals = visualsTab
    self.Elements.Tabs.Combat = combatTab
    self.Elements.Tabs.Settings = settingsTab
    
    -- Try to add to PlayerGui
    local localPlayer = Players.LocalPlayer
    if localPlayer then
        local playerGui = localPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            screenGui.Parent = playerGui
        else
            screenGui.Parent = game:GetService("CoreGui")
        end
    else
        screenGui.Parent = game:GetService("CoreGui")
    end
    
    -- Hide menu initially
    mainFrame.Visible = false
end

-- Populate visuals tab with controls
function UI:PopulateVisualsTab(tab)
    -- Implementation depends on whether we're using WindUI or fallback
    if self.WindUI then
        -- Use WindUI components
        self:AddVisualsControlsWithWindUI(tab)
    else
        -- Use fallback UI
        self:AddVisualsControlsWithFallback(tab)
    end
end

-- Populate combat tab with controls
function UI:PopulateCombatTab(tab)
    -- Implementation depends on whether we're using WindUI or fallback
    if self.WindUI then
        -- Use WindUI components
        self:AddCombatControlsWithWindUI(tab)
    else
        -- Use fallback UI
        self:AddCombatControlsWithFallback(tab)
    end
end

-- Populate settings tab with controls
function UI:PopulateSettingsTab(tab)
    -- Implementation depends on whether we're using WindUI or fallback
    if self.WindUI then
        -- Use WindUI components
        self:AddSettingsControlsWithWindUI(tab)
    else
        -- Use fallback UI
        self:AddSettingsControlsWithFallback(tab)
    end
end

-- Add visual controls using WindUI
function UI:AddVisualsControlsWithWindUI(tab)
    if not self.Visuals then return end
    
    -- Create sections for different visual feature categories
    local atmosphereSection = self.WindUI.Create("Section", {
        Parent = tab,
        Title = "Atmosphere"
    })
    
    local playerSection = self.WindUI.Create("Section", {
        Parent = tab,
        Title = "Player"
    })
    
    local effectsSection = self.WindUI.Create("Section", {
        Parent = tab,
        Title = "Effects"
    })
    
    -- Add Fog controls
    self:AddToggle(atmosphereSection, "Fog", function(enabled)
        self.Visuals.Config.Fog.Enabled = enabled
    end, self.Visuals.Config.Fog.Enabled)
    
    self:AddColorPicker(atmosphereSection, "Fog Color", function(color)
        self.Visuals.Config.Fog.Color = color
    end, self.Visuals.Config.Fog.Color)
    
    self:AddSlider(atmosphereSection, "Fog Start", function(value)
        self.Visuals.Config.Fog.Start = value
    end, self.Visuals.Config.Fog.Start, 0, 1000, 10)
    
    self:AddSlider(atmosphereSection, "Fog End", function(value)
        self.Visuals.Config.Fog.End = value
    end, self.Visuals.Config.Fog.End, 0, 1000, 10)
    
    self:AddSlider(atmosphereSection, "Fog Density", function(value)
        self.Visuals.Config.Fog.Density = value
    end, self.Visuals.Config.Fog.Density, 0, 1, 0.05)
    
    -- Add Rain controls
    self:AddToggle(atmosphereSection, "Rain", function(enabled)
        self.Visuals.Config.Rain.Enabled = enabled
    end, self.Visuals.Config.Rain.Enabled)
    
    self:AddSlider(atmosphereSection, "Rain Intensity", function(value)
        self.Visuals.Config.Rain.Intensity = value
    end, self.Visuals.Config.Rain.Intensity, 0, 200, 5)
    
    self:AddSlider(atmosphereSection, "Rain Size", function(value)
        self.Visuals.Config.Rain.Size = value
    end, self.Visuals.Config.Rain.Size, 0.01, 1, 0.01)
    
    self:AddSlider(atmosphereSection, "Rain Speed", function(value)
        self.Visuals.Config.Rain.Speed = value
    end, self.Visuals.Config.Rain.Speed, 10, 200, 5)
    
    -- Add Ambient controls
    self:AddToggle(atmosphereSection, "Ambient", function(enabled)
        self.Visuals.Config.Ambient.Enabled = enabled
    end, self.Visuals.Config.Ambient.Enabled)
    
    self:AddColorPicker(atmosphereSection, "Ambient Color", function(color)
        self.Visuals.Config.Ambient.Ambient = color
    end, self.Visuals.Config.Ambient.Ambient)
    
    self:AddColorPicker(atmosphereSection, "Outdoor Ambient", function(color)
        self.Visuals.Config.Ambient.OutdoorAmbient = color
    end, self.Visuals.Config.Ambient.OutdoorAmbient)
    
    -- Add Clock controls
    self:AddToggle(atmosphereSection, "Clock", function(enabled)
        self.Visuals.Config.Clock.Enabled = enabled
    end, self.Visuals.Config.Clock.Enabled)
    
    self:AddSlider(atmosphereSection, "Time", function(value)
        self.Visuals.Config.Clock.Time = value
    end, self.Visuals.Config.Clock.Time, 0, 24, 0.5)
    
    self:AddSlider(atmosphereSection, "Cycle Speed", function(value)
        self.Visuals.Config.Clock.CycleSpeed = value
    end, self.Visuals.Config.Clock.CycleSpeed, 0, 10, 0.1)
    
    -- Add Brightness controls
    self:AddToggle(atmosphereSection, "Brightness", function(enabled)
        self.Visuals.Config.Brightness.Enabled = enabled
    end, self.Visuals.Config.Brightness.Enabled)
    
    self:AddSlider(atmosphereSection, "Brightness Value", function(value)
        self.Visuals.Config.Brightness.Value = value
    end, self.Visuals.Config.Brightness.Value, 0, 5, 0.1)
    
    -- Add Exposure controls
    self:AddToggle(atmosphereSection, "Exposure", function(enabled)
        self.Visuals.Config.Exposure.Enabled = enabled
    end, self.Visuals.Config.Exposure.Enabled)
    
    self:AddSlider(atmosphereSection, "Exposure Value", function(value)
        self.Visuals.Config.Exposure.Value = value
    end, self.Visuals.Config.Exposure.Value, 0, 3, 0.1)
    
    -- Add China Hat controls
    self:AddToggle(playerSection, "China Hat", function(enabled)
        self.Visuals.Config.ChinaHat.Enabled = enabled
    end, self.Visuals.Config.ChinaHat.Enabled)
    
    self:AddColorPicker(playerSection, "China Hat Color", function(color)
        self.Visuals.Config.ChinaHat.Color = color
    end, self.Visuals.Config.ChinaHat.Color)
    
    self:AddSlider(playerSection, "China Hat Size", function(value)
        self.Visuals.Config.ChinaHat.Size = value
    end, self.Visuals.Config.ChinaHat.Size, 0.5, 5, 0.1)
    
    self:AddSlider(playerSection, "China Hat Transparency", function(value)
        self.Visuals.Config.ChinaHat.Transparency = value
    end, self.Visuals.Config.ChinaHat.Transparency, 0, 1, 0.05)
    
    -- Add Capes controls
    self:AddToggle(playerSection, "Capes", function(enabled)
        self.Visuals.Config.Capes.Enabled = enabled
    end, self.Visuals.Config.Capes.Enabled)
    
    self:AddColorPicker(playerSection, "Cape Color", function(color)
        self.Visuals.Config.Capes.Color = color
    end, self.Visuals.Config.Capes.Color)
    
    self:AddToggle(playerSection, "Cape Physics", function(enabled)
        self.Visuals.Config.Capes.Physics = enabled
    end, self.Visuals.Config.Capes.Physics)
    
    -- Add Trail controls
    self:AddToggle(playerSection, "Trail", function(enabled)
        self.Visuals.Config.Trail.Enabled = enabled
    end, self.Visuals.Config.Trail.Enabled)
    
    self:AddColorPicker(playerSection, "Trail Color", function(color)
        -- Update the color sequence
        self.Visuals.Config.Trail.Color = ColorSequence.new(color)
    end, self.Visuals.Config.Trail.Color.Keypoints[1].Value)
    
    self:AddSlider(playerSection, "Trail Lifetime", function(value)
        self.Visuals.Config.Trail.Lifetime = value
    end, self.Visuals.Config.Trail.Lifetime, 0.1, 5, 0.1)
    
    -- Add Backtrack controls
    self:AddToggle(effectsSection, "Backtrack", function(enabled)
        self.Visuals.Config.Backtrack.Enabled = enabled
    end, self.Visuals.Config.Backtrack.Enabled)
    
    self:AddSlider(effectsSection, "Backtrack Duration", function(value)
        self.Visuals.Config.Backtrack.Duration = value
    end, self.Visuals.Config.Backtrack.Duration, 0.1, 5, 0.1)
    
    self:AddColorPicker(effectsSection, "Backtrack Color", function(color)
        self.Visuals.Config.Backtrack.Color = color
    end, self.Visuals.Config.Backtrack.Color)
    
    self:AddToggle(effectsSection, "Latency Based", function(enabled)
        self.Visuals.Config.Backtrack.LatencyBased = enabled
    end, self.Visuals.Config.Backtrack.LatencyBased)
    
    -- Add Balls (funny) controls
    self:AddToggle(effectsSection, "Balls (Funny)", function(enabled)
        self.Visuals.Config.Balls.Enabled = enabled
    end, self.Visuals.Config.Balls.Enabled)
    
    self:AddSlider(effectsSection, "Ball Size", function(value)
        self.Visuals.Config.Balls.Size = value
    end, self.Visuals.Config.Balls.Size, 0.1, 5, 0.1)
    
    self:AddColorPicker(effectsSection, "Ball Color", function(color)
        self.Visuals.Config.Balls.Color = color
    end, self.Visuals.Config.Balls.Color)
    
    self:AddSlider(effectsSection, "Bounce Height", function(value)
        self.Visuals.Config.Balls.BounceHeight = value
    end, self.Visuals.Config.Balls.BounceHeight, 0.1, 10, 0.1)
    
    -- Add Morphs controls
    self:AddToggle(effectsSection, "Morphs", function(enabled)
        self.Visuals.Config.Morphs.Enabled = enabled
    end, self.Visuals.Config.Morphs.Enabled)
    
    local morphs = self:GetAvailableMorphs()
    if #morphs > 0 then
        self:AddDropdown(effectsSection, "Morph Type", function(selected)
            self.Visuals.Config.Morphs.Selected = selected
        end, morphs, self.Visuals.Config.Morphs.Selected)
    end
end

-- Add visual controls using fallback UI
function UI:AddVisualsControlsWithFallback(tab)
    -- Similar implementation as above but using standard Roblox UI elements
    -- This is a simplified version
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = tab
    
    local function addSection(title)
        local section = Instance.new("Frame")
        section.Name = title .. "Section"
        section.Size = UDim2.new(1, -20, 0, 30)
        section.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        section.BorderSizePixel = 0
        section.LayoutOrder = #tab:GetChildren()
        section.AutomaticSize = Enum.AutomaticSize.Y
        section.Parent = tab
        
        local sectionTitle = Instance.new("TextLabel")
        sectionTitle.Name = "Title"
        sectionTitle.Size = UDim2.new(1, 0, 0, 30)
        sectionTitle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        sectionTitle.BorderSizePixel = 0
        sectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        sectionTitle.TextSize = 14
        sectionTitle.Font = Enum.Font.SourceSansBold
        sectionTitle.Text = "  " .. title
        sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        sectionTitle.Parent = section
        
        local contentFrame = Instance.new("Frame")
        contentFrame.Name = "Content"
        contentFrame.Size = UDim2.new(1, 0, 0, 0)
        contentFrame.Position = UDim2.new(0, 0, 0, 30)
        contentFrame.BackgroundTransparency = 1
        contentFrame.AutomaticSize = Enum.AutomaticSize.Y
        contentFrame.Parent = section
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 5)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = contentFrame
        
        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 10)
        padding.PaddingRight = UDim.new(0, 10)
        padding.PaddingTop = UDim.new(0, 5)
        padding.PaddingBottom = UDim.new(0, 5)
        padding.Parent = contentFrame
        
        return contentFrame
    end
    
    -- Create sections
    local atmosphereSection = addSection("Atmosphere")
    local playerSection = addSection("Player")
    local effectsSection = addSection("Effects")
    
    -- Add basic controls for demonstration
    -- In a real implementation, you would add all controls for each feature
    
    -- Example: Add Toggle for Fog
    local fogToggle = Instance.new("Frame")
    fogToggle.Name = "FogToggle"
    fogToggle.Size = UDim2.new(1, 0, 0, 30)
    fogToggle.BackgroundTransparency = 1
    fogToggle.LayoutOrder = 1
    fogToggle.Parent = atmosphereSection
    
    local fogLabel = Instance.new("TextLabel")
    fogLabel.Name = "Label"
    fogLabel.Size = UDim2.new(0.7, 0, 1, 0)
    fogLabel.BackgroundTransparency = 1
    fogLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fogLabel.TextSize = 14
    fogLabel.Font = Enum.Font.SourceSans
    fogLabel.Text = "Fog"
    fogLabel.TextXAlignment = Enum.TextXAlignment.Left
    fogLabel.Parent = fogToggle
    
    local fogButton = Instance.new("TextButton")
    fogButton.Name = "Button"
    fogButton.Size = UDim2.new(0.3, 0, 1, 0)
    fogButton.Position = UDim2.new(0.7, 0, 0, 0)
    fogButton.BackgroundColor3 = self.Visuals.Config.Fog.Enabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    fogButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    fogButton.TextSize = 14
    fogButton.Font = Enum.Font.SourceSans
    fogButton.Text = self.Visuals.Config.Fog.Enabled and "ON" or "OFF"
    fogButton.Parent = fogToggle
    
    fogButton.MouseButton1Click:Connect(function()
        self.Visuals.Config.Fog.Enabled = not self.Visuals.Config.Fog.Enabled
        fogButton.BackgroundColor3 = self.Visuals.Config.Fog.Enabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        fogButton.Text = self.Visuals.Config.Fog.Enabled and "ON" or "OFF"
    end)
    
    -- Continue adding controls for other features...
end

-- Add combat controls using WindUI
function UI:AddCombatControlsWithWindUI(tab)
    if not self.Combat then return end
    
    -- Create sections for different combat feature categories
    local visualSection = self.WindUI.Create("Section", {
        Parent = tab,
        Title = "Visual Effects"
    })
    
    local aimSection = self.WindUI.Create("Section", {
        Parent = tab,
        Title = "Aim Features"
    })
    
    local bulletSection = self.WindUI.Create("Section", {
        Parent = tab,
        Title = "Bullet Modifications"
    })
    
    local predictionSection = self.WindUI.Create("Section", {
        Parent = tab,
        Title = "Prediction"
    })
    
    -- Add Bullet Origin controls
    self:AddToggle(visualSection, "Bullet Origin", function(enabled)
        self.Combat.Config.BulletOrigin.Enabled = enabled
    end, self.Combat.Config.BulletOrigin.Enabled)
    
    self:AddColorPicker(visualSection, "Origin Color", function(color)
        self.Combat.Config.BulletOrigin.Color = color
    end, self.Combat.Config.BulletOrigin.Color)
    
    self:AddSlider(visualSection, "Origin Size", function(value)
        self.Combat.Config.BulletOrigin.Size = value
    end, self.Combat.Config.BulletOrigin.Size, 0.1, 1, 0.1)
    
    -- Add Bullet Impact controls
    self:AddToggle(visualSection, "Bullet Impact", function(enabled)
        self.Combat.Config.BulletImpact.Enabled = enabled
    end, self.Combat.Config.BulletImpact.Enabled)
    
    self:AddColorPicker(visualSection, "Impact Color", function(color)
        self.Combat.Config.BulletImpact.Color = color
    end, self.Combat.Config.BulletImpact.Color)
    
    self:AddSlider(visualSection, "Impact Size", function(value)
        self.Combat.Config.BulletImpact.Size = value
    end, self.Combat.Config.BulletImpact.Size, 0.1, 2, 0.1)
    
    -- Add Bullet Tracer controls
    self:AddToggle(visualSection, "Bullet Tracer", function(enabled)
        self.Combat.Config.BulletTracer.Enabled = enabled
    end, self.Combat.Config.BulletTracer.Enabled)
    
    self:AddColorPicker(visualSection, "Tracer Color", function(color)
        self.Combat.Config.BulletTracer.Color = color
    end, self.Combat.Config.BulletTracer.Color)
    
    self:AddSlider(visualSection, "Tracer Width", function(value)
        self.Combat.Config.BulletTracer.Width = value
    end, self.Combat.Config.BulletTracer.Width, 0.01, 0.5, 0.01)
    
    -- Add Shoot Sound controls
    self:AddToggle(visualSection, "Shoot Sound", function(enabled)
        self.Combat.Config.ShootSound.Enabled = enabled
    end, self.Combat.Config.ShootSound.Enabled)
    
    self:AddTextBox(visualSection, "Sound ID", function(value)
        self.Combat.Config.ShootSound.SoundId = value
    end, self.Combat.Config.ShootSound.SoundId)
    
    self:AddSlider(visualSection, "Volume", function(value)
        self.Combat.Config.ShootSound.Volume = value
    end, self.Combat.Config.ShootSound.Volume, 0, 1, 0.05)
    
    -- Add Hit Chams controls
    self:AddToggle(visualSection, "Hit Chams", function(enabled)
        self.Combat.Config.HitChams.Enabled = enabled
    end, self.Combat.Config.HitChams.Enabled)
    
    self:AddColorPicker(visualSection, "Chams Color", function(color)
        self.Combat.Config.HitChams.Color = color
    end, self.Combat.Config.HitChams.Color)
    
    self:AddSlider(visualSection, "Chams Transparency", function(value)
        self.Combat.Config.HitChams.Transparency = value
    end, self.Combat.Config.HitChams.Transparency, 0, 1, 0.05)
    
    -- Add Hit Effects controls
    self:AddToggle(visualSection, "Hit Effects", function(enabled)
        self.Combat.Config.HitEffects.Enabled = enabled
    end, self.Combat.Config.HitEffects.Enabled)
    
    self:AddDropdown(visualSection, "Effect Type", function(selected)
        self.Combat.Config.HitEffects.Type = selected
    end, {"Spark", "Blood", "Smoke"}, self.Combat.Config.HitEffects.Type)
    
    self:AddColorPicker(visualSection, "Effect Color", function(color)
        self.Combat.Config.HitEffects.Color = color
    end, self.Combat.Config.HitEffects.Color)
    
    -- Add Hit Skeleton controls
    self:AddToggle(visualSection, "Hit Skeleton", function(enabled)
        self.Combat.Config.HitSkeleton.Enabled = enabled
    end, self.Combat.Config.HitSkeleton.Enabled)
    
    self:AddColorPicker(visualSection, "Skeleton Color", function(color)
        self.Combat.Config.HitSkeleton.Color = color
    end, self.Combat.Config.HitSkeleton.Color)
    
    self:AddSlider(visualSection, "Line Thickness", function(value)
        self.Combat.Config.HitSkeleton.LineThickness = value
    end, self.Combat.Config.HitSkeleton.LineThickness, 0.01, 0.5, 0.01)
    
    -- Add Hit Sound controls
    self:AddToggle(visualSection, "Hit Sound", function(enabled)
        self.Combat.Config.HitSound.Enabled = enabled
    end, self.Combat.Config.HitSound.Enabled)
    
    self:AddTextBox(visualSection, "Hit Sound ID", function(value)
        self.Combat.Config.HitSound.SoundId = value
    end, self.Combat.Config.HitSound.SoundId)
    
    self:AddSlider(visualSection, "Hit Volume", function(value)
        self.Combat.Config.HitSound.Volume = value
    end, self.Combat.Config.HitSound.Volume, 0, 1, 0.05)
    
    -- Add Force Hit controls
    self:AddToggle(bulletSection, "Force Hit", function(enabled)
        self.Combat.Config.ForceHit.Enabled = enabled
    end, self.Combat.Config.ForceHit.Enabled)
    
    self:AddToggle(bulletSection, "Bypass Walls", function(enabled)
        self.Combat.Config.ForceHit.BypassWalls = enabled
    end, self.Combat.Config.ForceHit.BypassWalls)
    
    self:AddDropdown(bulletSection, "Hit Part", function(selected)
        self.Combat.Config.ForceHit.HitPart = selected
    end, {"Head", "HumanoidRootPart", "Random"}, self.Combat.Config.ForceHit.HitPart)
    
    -- Add Invisible Bullets controls
    self:AddToggle(bulletSection, "Invisible Bullets", function(enabled)
        self.Combat.Config.InvisibleBullets.Enabled = enabled
    end, self.Combat.Config.InvisibleBullets.Enabled)
    
    self:AddToggle(bulletSection, "Remove Effects", function(enabled)
        self.Combat.Config.InvisibleBullets.RemoveEffects = enabled
    end, self.Combat.Config.InvisibleBullets.RemoveEffects)
    
    -- Add Wallbang controls
    self:AddToggle(bulletSection, "Wallbang", function(enabled)
        self.Combat.Config.Wallbang.Enabled = enabled
    end, self.Combat.Config.Wallbang.Enabled)
    
    self:AddSlider(bulletSection, "Max Thickness", function(value)
        self.Combat.Config.Wallbang.MaxThickness = value
    end, self.Combat.Config.Wallbang.MaxThickness, 1, 20, 1)
    
    self:AddSlider(bulletSection, "Damage Multiplier", function(value)
        self.Combat.Config.Wallbang.DamageMultiplier = value
    end, self.Combat.Config.Wallbang.DamageMultiplier, 0.1, 1, 0.1)
    
    -- Add Bullet TP controls
    self:AddToggle(bulletSection, "Bullet TP", function(enabled)
        self.Combat.Config.BulletTP.Enabled = enabled
    end, self.Combat.Config.BulletTP.Enabled)
    
    self:AddSlider(bulletSection, "TP Distance", function(value)
        self.Combat.Config.BulletTP.Distance = value
    end, self.Combat.Config.BulletTP.Distance, 1, 20, 1)
    
    self:AddToggle(bulletSection, "Teleport Back", function(enabled)
        self.Combat.Config.BulletTP.TeleportBack = enabled
    end, self.Combat.Config.BulletTP.TeleportBack)
    
    -- Add Look At controls
    self:AddToggle(aimSection, "Look At", function(enabled)
        self.Combat.Config.LookAt.Enabled = enabled
    end, self.Combat.Config.LookAt.Enabled)
    
    self:AddDropdown(aimSection, "Target", function(selected)
        self.Combat.Config.LookAt.Target = selected
    end, {"Closest", "Crosshair", "Random"}, self.Combat.Config.LookAt.Target)
    
    self:AddSlider(aimSection, "Smooth Factor", function(value)
        self.Combat.Config.LookAt.SmoothFactor = value
    end, self.Combat.Config.LookAt.SmoothFactor, 0.01, 1, 0.01)
    
    -- Add View At controls
    self:AddToggle(aimSection, "View At", function(enabled)
        self.Combat.Config.ViewAt.Enabled = enabled
    end, self.Combat.Config.ViewAt.Enabled)
    
    self:AddDropdown(aimSection, "View Target", function(selected)
        self.Combat.Config.ViewAt.Target = selected
    end, {"Closest", "Shot"}, self.Combat.Config.ViewAt.Target)
    
    self:AddSlider(aimSection, "View Smooth", function(value)
        self.Combat.Config.ViewAt.SmoothFactor = value
    end, self.Combat.Config.ViewAt.SmoothFactor, 0.1, 1, 0.1)
    
    -- Add Camera Lock controls
    self:AddToggle(aimSection, "Camera Lock", function(enabled)
        self.Combat.Config.CameraLock.Enabled = enabled
    end, self.Combat.Config.CameraLock.Enabled)
    
    self:AddDropdown(aimSection, "Lock Target", function(selected)
        self.Combat.Config.CameraLock.Target = selected
    end, {"Closest", "Crosshair", "Health"}, self.Combat.Config.CameraLock.Target)
    
    self:AddDropdown(aimSection, "Lock Part", function(selected)
        self.Combat.Config.CameraLock.LockPart = selected
    end, {"Head", "HumanoidRootPart", "Torso"}, self.Combat.Config.CameraLock.LockPart)
    
    -- Add FOV Mode controls
    self:AddToggle(aimSection, "FOV Circle", function(enabled)
        self.Combat.Config.FOVMode.Enabled = enabled
    end, self.Combat.Config.FOVMode.Enabled)
    
    self:AddSlider(aimSection, "FOV Size", function(value)
        self.Combat.Config.FOVMode.Size = value
    end, self.Combat.Config.FOVMode.Size, 10, 1000, 10)
    
    self:AddColorPicker(aimSection, "FOV Color", function(color)
        self.Combat.Config.FOVMode.Color = color
    end, self.Combat.Config.FOVMode.Color)
    
    self:AddToggle(aimSection, "FOV Filled", function(enabled)
        self.Combat.Config.FOVMode.Filled = enabled
    end, self.Combat.Config.FOVMode.Filled)
    
    -- Add Prediction controls
    self:AddToggle(predictionSection, "Prediction", function(enabled)
        self.Combat.Config.Prediction.Enabled = enabled
    end, self.Combat.Config.Prediction.Enabled)
    
    self:AddDropdown(predictionSection, "Method", function(selected)
        self.Combat.Config.Prediction.Method = selected
    end, {"Division", "Multiplication"}, self.Combat.Config.Prediction.Method)
    
    self:AddSlider(predictionSection, "Factor", function(value)
        self.Combat.Config.Prediction.Factor = value
    end, self.Combat.Config.Prediction.Factor, 0.1, 5, 0.1)
    
    -- Add Auto Prediction controls
    self:AddToggle(predictionSection, "Auto Prediction", function(enabled)
        self.Combat.Config.AutoPrediction.Enabled = enabled
    end, self.Combat.Config.AutoPrediction.Enabled)
    
    self:AddSlider(predictionSection, "Min Factor", function(value)
        self.Combat.Config.AutoPrediction.MinFactor = value
    end, self.Combat.Config.AutoPrediction.MinFactor, 0.1, 3, 0.1)
    
    self:AddSlider(predictionSection, "Max Factor", function(value)
        self.Combat.Config.AutoPrediction.MaxFactor = value
    end, self.Combat.Config.AutoPrediction.MaxFactor, 1, 10, 0.5)
    
    -- Add Custom Auto Prediction controls
    self:AddToggle(predictionSection, "Custom Auto Prediction", function(enabled)
        self.Combat.Config.CustomAutoPrediction.Enabled = enabled
    end, self.Combat.Config.CustomAutoPrediction.Enabled)
    
    self:AddSlider(predictionSection, "Base Factor", function(value)
        self.Combat.Config.CustomAutoPrediction.BaseFactor = value
    end, self.Combat.Config.CustomAutoPrediction.BaseFactor, 0.5, 5, 0.5)
    
    self:AddSlider(predictionSection, "Max Ping", function(value)
        self.Combat.Config.CustomAutoPrediction.MaxPing = value
    end, self.Combat.Config.CustomAutoPrediction.MaxPing, 100, 1000, 50)
end

-- Add combat controls using fallback UI
function UI:AddCombatControlsWithFallback(tab)
    -- Similar implementation as AddVisualsControlsWithFallback but for combat features
    -- For brevity, this implementation is omitted and would follow the same pattern
end

-- Add settings controls using WindUI
function UI:AddSettingsControlsWithWindUI(tab)
    if not self.Settings then return end
    
    local mainSection = self.WindUI.Create("Section", {
        Parent = tab,
        Title = "Settings Management"
    })
    
    -- Save settings button
    self.WindUI.Create("Button", {
        Parent = mainSection,
        Text = "Save Settings",
        Callback = function()
            self:SaveSettings()
            self:ShowNotification("Settings saved!")
        end
    })
    
    -- Load settings button
    self.WindUI.Create("Button", {
        Parent = mainSection,
        Text = "Load Settings",
        Callback = function()
            if self:LoadSettings() then
                self:ShowNotification("Settings loaded!")
            else
                self:ShowNotification("Failed to load settings!", Color3.fromRGB(255, 100, 100))
            end
        end
    })
    
    -- Reset settings button
    self.WindUI.Create("Button", {
        Parent = mainSection,
        Text = "Reset to Default",
        Callback = function()
            self:ResetSettings()
            self:ShowNotification("Settings reset to default!")
        end
    })
    
    -- Export settings button
    self.WindUI.Create("Button", {
        Parent = mainSection,
        Text = "Export Settings to Clipboard",
        Callback = function()
            if self.Settings:ExportToClipboard() then
                self:ShowNotification("Settings exported to clipboard!")
            else
                self:ShowNotification("Failed to export settings!", Color3.fromRGB(255, 100, 100))
            end
        end
    })
    
    -- Import settings button
    self.WindUI.Create("Button", {
        Parent = mainSection,
        Text = "Import Settings from Clipboard",
        Callback = function()
            if self.Settings:ImportFromClipboard() then
                self:LoadSettings()
                self:ShowNotification("Settings imported successfully!")
            else
                self:ShowNotification("Failed to import settings!", Color3.fromRGB(255, 100, 100))
            end
        end
    })
end

-- Add settings controls using fallback UI
function UI:AddSettingsControlsWithFallback(tab)
    -- Similar implementation as AddVisualsControlsWithFallback but for settings
    -- For brevity, this implementation is omitted and would follow the same pattern
end

-- Helper function to add a toggle control with WindUI
function UI:AddToggle(parent, name, callback, initialValue)
    if self.WindUI then
        return self.WindUI.Create("Toggle", {
            Parent = parent,
            Text = name,
            Callback = callback,
            Default = initialValue
        })
    end
end

-- Helper function to add a slider control with WindUI
function UI:AddSlider(parent, name, callback, initialValue, min, max, increment)
    if self.WindUI then
        return self.WindUI.Create("Slider", {
            Parent = parent,
            Text = name,
            Callback = callback,
            Default = initialValue,
            Min = min,
            Max = max,
            Increment = increment
        })
    end
end

-- Helper function to add a color picker control with WindUI
function UI:AddColorPicker(parent, name, callback, initialValue)
    if self.WindUI then
        return self.WindUI.Create("ColorPicker", {
            Parent = parent,
            Text = name,
            Callback = callback,
            Default = initialValue
        })
    end
end

-- Helper function to add a dropdown control with WindUI
function UI:AddDropdown(parent, name, callback, options, initialValue)
    if self.WindUI then
        return self.WindUI.Create("Dropdown", {
            Parent = parent,
            Text = name,
            Callback = callback,
            Options = options,
            Default = initialValue
        })
    end
end

-- Helper function to add a text box control with WindUI
function UI:AddTextBox(parent, name, callback, initialValue)
    if self.WindUI then
        return self.WindUI.Create("TextBox", {
            Parent = parent,
            Text = name,
            Callback = callback,
            Default = initialValue
        })
    end
end

-- Helper function to get available morphs
function UI:GetAvailableMorphs()
    if self.Visuals then
        return self.Visuals:GetAvailableMorphs() or {"Default"}
    end
    return {"Default"}
end

-- Show notification
function UI:ShowNotification(message, color)
    local bgColor = color or Color3.fromRGB(40, 40, 40)
    local textColor = Color3.fromRGB(255, 255, 255)
    
    -- Create notification
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "WindUINotification"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 1001
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 250, 0, 60)
    notification.Position = UDim2.new(0.5, -125, 0.9, 0)
    notification.BackgroundColor3 = bgColor
    notification.BorderSizePixel = 0
    notification.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = notification
    
    local text = Instance.new("TextLabel")
    text.Name = "Message"
    text.Size = UDim2.new(1, -20, 1, 0)
    text.Position = UDim2.new(0, 10, 0, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = textColor
    text.TextSize = 16
    text.Font = Enum.Font.SourceSans
    text.Text = message
    text.TextWrapped = true
    text.Parent = notification
    
    -- Add to player gui
    local localPlayer = Players.LocalPlayer
    if localPlayer then
        local playerGui = localPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            screenGui.Parent = playerGui
        else
            screenGui.Parent = game:GetService("CoreGui")
        end
    else
        screenGui.Parent = game:GetService("CoreGui")
    end
    
    -- Animate in
    notification.Position = UDim2.new(0.5, -125, 1, 10)
    local inTween = TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -125, 0.9, -70)
    })
    inTween:Play()
    
    -- Wait and animate out
    delay(3, function()
        local outTween = TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -125, 1, 10)
        })
        outTween:Play()
        
        outTween.Completed:Connect(function()
            screenGui:Destroy()
        end)
    end)
    
    -- Add to notification list
    table.insert(self.Elements.Notifications, {
        GUI = screenGui,
        CreationTime = tick()
    })
end

-- Update notifications (fade out old ones)
function UI:UpdateNotifications(dt)
    local notificationsToRemove = {}
    
    for i, notifData in ipairs(self.Elements.Notifications) do
        local age = tick() - notifData.CreationTime
        
        if age > 3.5 then
            -- Mark for removal (should be gone after the tween)
            table.insert(notificationsToRemove, i)
        end
    end
    
    -- Remove old notifications
    for i = #notificationsToRemove, 1, -1 do
        local index = notificationsToRemove[i]
        -- The actual destruction happens in the tween completed callback
        table.remove(self.Elements.Notifications, index)
    end
end

-- Toggle main menu visibility
function UI:ToggleMainMenu()
    if self.Elements.MainMenu then
        if self.WindUI then
            -- Using WindUI
            self.Elements.MainMenu.Visible = not self.Elements.MainMenu.Visible
        else
            -- Using fallback UI
            local mainFrame = self.Elements.MainMenu:FindFirstChild("MainFrame")
            if mainFrame then
                mainFrame.Visible = not mainFrame.Visible
            end
        end
    end
end

-- Update all UI controls to reflect current config values
function UI:UpdateAllControls()
    -- This would update all UI elements to match the current config values
    -- For brevity, this implementation is omitted
    -- In a real implementation, you would iterate through all controls and update them
    
    self:ShowNotification("UI updated with current settings")
end

-- Save settings
function UI:SaveSettings()
    if not self.Settings then return false end
    
    local windUIFeatures = require(script.Parent.Parent)
    return windUIFeatures:SaveSettings()
end

-- Load settings
function UI:LoadSettings()
    if not self.Settings then return false end
    
    local windUIFeatures = require(script.Parent.Parent)
    return windUIFeatures:LoadSettings()
end

-- Reset settings
function UI:ResetSettings()
    if not self.Settings then return false end
    
    local windUIFeatures = require(script.Parent.Parent)
    return windUIFeatures:ResetSettings()
end

return UI
