-- WindUI Feature Settings
-- Handles saving and loading settings for WindUI features

local Settings = {}

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Default settings filename
Settings.FileName = "WindUIFeatures_Settings.json"

-- Initialize the settings module
function Settings:Init()
    -- Create settings directory if it doesn't exist
    pcall(function()
        if not isfolder("WindUI") then
            makefolder("WindUI")
        end
    end)
    
    return self
end

-- Save config to file
function Settings:SaveConfig(config)
    if not config then return false end
    
    -- Try to convert config to JSON
    local success, jsonData = pcall(function()
        return HttpService:JSONEncode(config)
    end)
    
    if not success then
        warn("WindUIFeatures: Failed to encode settings to JSON.")
        return false
    end
    
    -- Try to write to file
    local writeSuccess = pcall(function()
        writefile("WindUI/" .. self.FileName, jsonData)
    end)
    
    return writeSuccess
end

-- Load config from file
function Settings:LoadConfig()
    -- Check if file exists
    local fileExists = pcall(function()
        return isfile("WindUI/" .. self.FileName)
    end)
    
    if not fileExists then
        return nil
    end
    
    -- Try to read file
    local success, fileData = pcall(function()
        return readfile("WindUI/" .. self.FileName)
    end)
    
    if not success or not fileData then
        warn("WindUIFeatures: Failed to read settings file.")
        return nil
    end
    
    -- Try to parse JSON
    local parseSuccess, parsedData = pcall(function()
        return HttpService:JSONDecode(fileData)
    end)
    
    if not parseSuccess or not parsedData then
        warn("WindUIFeatures: Failed to parse settings JSON.")
        return nil
    end
    
    return parsedData
end

-- Delete settings file
function Settings:DeleteConfig()
    if not isfile("WindUI/" .. self.FileName) then
        return true
    end
    
    local success = pcall(function()
        delfile("WindUI/" .. self.FileName)
    end)
    
    return success
end

-- Export settings to clipboard
function Settings:ExportToClipboard()
    local config = self:LoadConfig()
    if not config then return false end
    
    local success = pcall(function()
        setclipboard(HttpService:JSONEncode(config))
    end)
    
    return success
end

-- Import settings from clipboard
function Settings:ImportFromClipboard()
    local success, clipboardData = pcall(function()
        return getclipboard()
    end)
    
    if not success or not clipboardData then
        warn("WindUIFeatures: Failed to get clipboard data.")
        return false
    end
    
    -- Try to parse JSON
    local parseSuccess, parsedData = pcall(function()
        return HttpService:JSONDecode(clipboardData)
    end)
    
    if not parseSuccess or not parsedData then
        warn("WindUIFeatures: Clipboard does not contain valid settings JSON.")
        return false
    end
    
    -- Save the imported settings
    return self:SaveConfig(parsedData)
end

-- Check if a settings file exists
function Settings:HasSavedConfig()
    local fileExists = pcall(function()
        return isfile("WindUI/" .. self.FileName)
    end)
    
    return fileExists
end

return Settings
