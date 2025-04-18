-- WindUI Features Implementation
-- Main entry point for loading and initializing WindUI features
-- This script integrates visual and combat features with the WindUI library

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Load modules
local Visuals = require(script.Parent.modules.visuals)
local Combat = require(script.Parent.modules.combat)
local Settings = require(script.Parent.modules.settings)
local UI = require(script.Parent.modules.ui)

-- WindUI Features main module
local WindUIFeatures = {}
WindUIFeatures.Enabled = true
WindUIFeatures.Initialized = false

-- Reference to WindUI (parent library)
WindUIFeatures.WindUI = nil

-- Initialize the WindUI Features
function WindUIFeatures:Init(windUI)
    if self.Initialized then return self end
    
    -- Store reference to WindUI
    self.WindUI = windUI or _G.WindUI
    
    if not self.WindUI then
        warn("WindUIFeatures: WindUI not found, some features may not work correctly.")
    end
    
    -- Initialize settings first
    self.Settings = Settings:Init()
    
    -- Initialize visual and combat modules
    self.Visuals = Visuals:Init()
    self.Combat = Combat:Init()
    
    -- Initialize UI last (depends on other modules)
    self.UI = UI:Init(self.WindUI, self.Visuals, self.Combat, self.Settings)
    
    -- Connect input events
    self:ConnectInputEvents()
    
    -- Connect update loop
    RunService.RenderStepped:Connect(function(dt)
        if self.Enabled then
            self:Update(dt)
        end
    end)
    
    print("WindUIFeatures: Initialized successfully.")
    self.Initialized = true
    
    return self
end

-- Main update loop
function WindUIFeatures:Update(dt)
    -- Update modules (Visuals and Combat already have their own update loops connected in their Init methods)
    -- This is for any additional updates we may need
    
    -- Update UI elements
    if self.UI then
        self.UI:Update(dt)
    end
end

-- Connect global input events
function WindUIFeatures:ConnectInputEvents()
    -- Toggle main menu
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.RightControl then
            if self.UI then
                self.UI:ToggleMainMenu()
            end
        end
        
        -- Toggle features enabled/disabled
        if input.KeyCode == Enum.KeyCode.RightAlt then
            self.Enabled = not self.Enabled
            if self.UI then
                self.UI:ShowNotification("Features " .. (self.Enabled and "Enabled" or "Disabled"))
            end
        end
    end)
end

-- Public API to modify Visuals config
function WindUIFeatures:SetVisualConfig(feature, property, value)
    if not self.Visuals then return false end
    return self.Visuals:SetConfig(feature, property, value)
end

-- Public API to modify Combat config
function WindUIFeatures:SetCombatConfig(feature, property, value)
    if not self.Combat then return false end
    return self.Combat:SetConfig(feature, property, value)
end

-- Save all current settings to file
function WindUIFeatures:SaveSettings()
    if not self.Settings then return false end
    
    -- Collect current settings from modules
    local visualsConfig = {}
    for feature, settings in pairs(self.Visuals.Config) do
        visualsConfig[feature] = table.clone(settings)
    end
    
    local combatConfig = {}
    for feature, settings in pairs(self.Combat.Config) do
        combatConfig[feature] = table.clone(settings)
    end
    
    -- Save to settings
    return self.Settings:SaveConfig({
        Visuals = visualsConfig,
        Combat = combatConfig
    })
end

-- Load settings from file
function WindUIFeatures:LoadSettings()
    if not self.Settings then return false end
    
    local config = self.Settings:LoadConfig()
    if not config then return false end
    
    -- Apply loaded settings to modules
    if config.Visuals then
        for feature, settings in pairs(config.Visuals) do
            if self.Visuals.Config[feature] then
                for property, value in pairs(settings) do
                    self:SetVisualConfig(feature, property, value)
                end
            end
        end
    end
    
    if config.Combat then
        for feature, settings in pairs(config.Combat) do
            if self.Combat.Config[feature] then
                for property, value in pairs(settings) do
                    self:SetCombatConfig(feature, property, value)
                end
            end
        end
    end
    
    if self.UI then
        self.UI:UpdateAllControls()
    end
    
    return true
end

-- Reset settings to defaults
function WindUIFeatures:ResetSettings()
    if not self.Visuals or not self.Combat then return false end
    
    -- Re-initialize modules to reset configs to defaults
    self.Visuals = nil
    self.Combat = nil
    
    self.Visuals = Visuals:Init()
    self.Combat = Combat:Init()
    
    if self.UI then
        self.UI:UpdateAllControls()
    end
    
    return true
end

-- Get available morphs for UI
function WindUIFeatures:GetAvailableMorphs()
    if not self.Visuals then return {} end
    return self.Visuals:GetAvailableMorphs()
end

-- Initialization
local function CheckIfWindUILoaded()
    local windUI = _G.WindUI
    
    if windUI then
        -- WindUI is loaded, initialize features
        WindUIFeatures:Init(windUI)
    else
        -- Wait and try again
        warn("WindUIFeatures: WindUI not found, waiting...")
        delay(1, CheckIfWindUILoaded)
    end
end

-- Start initialization process
CheckIfWindUILoaded()

return WindUIFeatures
