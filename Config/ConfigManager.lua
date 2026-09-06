-- ==================================================
-- CONFIG MANAGER (Save only on Toggle Change)
-- ==================================================

local HttpService = game:GetService("HttpService")

-- ==================================================
-- CONFIG PATH
-- ==================================================
local CONFIG_PATH = "YOKUDOHUB/sea3_config.json"

-- ==================================================
-- DEFAULT CONFIG
-- ==================================================
local DEFAULT_CONFIG = {
    AutoEliteHunter = false,
    AutoBuso = false,
}

-- ==================================================
-- STATE
-- ==================================================
local currentConfig = nil
local isSaving = false

-- ==================================================
-- LOAD CONFIG
-- ==================================================
local function loadConfig()
    local success, data = pcall(function()
        if isfile(CONFIG_PATH) then
            local content = readfile(CONFIG_PATH)
            return HttpService:JSONDecode(content)
        end
        return nil
    end)
    
    if success and data then
        print("📂 Config Loaded from: " .. CONFIG_PATH)
        return data
    end
    print("📂 Config not found, using default")
    return nil
end

-- ==================================================
-- SAVE CONFIG
-- ==================================================
local function saveConfig(data)
    if isSaving then return end
    isSaving = true
    
    local success, err = pcall(function()
        local json = HttpService:JSONEncode(data)
        writefile(CONFIG_PATH, json)
        print("💾 Config Saved!")
        print("   EliteHunter: " .. tostring(data.AutoEliteHunter))
        print("   Buso: " .. tostring(data.AutoBuso))
    end)
    
    if not success then
        warn("⚠️ Failed to save config: " .. tostring(err))
    end
    
    isSaving = false
end

-- ==================================================
-- GET CONFIG
-- ==================================================
function _G.YOKUDO_GetConfig()
    if currentConfig then
        return currentConfig
    end
    
    local config = loadConfig()
    if config then
        currentConfig = config
        return currentConfig
    end
    
    saveConfig(DEFAULT_CONFIG)
    currentConfig = DEFAULT_CONFIG
    return currentConfig
end

-- ==================================================
-- SAVE CURRENT STATE (ហៅពី Features ពេល Toggle)
-- ==================================================
function _G.YOKUDO_SaveCurrentState()
    local config = _G.YOKUDO_GetConfig()
    
    local currentState = {
        AutoEliteHunter = _G.YOKUDO_AutoEliteHunterEnabled or false,
        AutoBuso = _G.YOKUDO_BusoEnabled or false,
    }
    
    local hasChanged = false
    for key, value in pairs(currentState) do
        if config[key] ~= value then
            config[key] = value
            hasChanged = true
        end
    end
    
    if hasChanged then
        currentConfig = config
        saveConfig(config)
        return true
    end
    return false
end

-- ==================================================
-- RELOAD CONFIG
-- ==================================================
function _G.YOKUDO_ReloadConfig()
    currentConfig = nil
    return _G.YOKUDO_GetConfig()
end

-- ==================================================
-- PRINT CONFIG
-- ==================================================
function _G.YOKUDO_PrintConfig()
    local config = _G.YOKUDO_GetConfig()
    print("📋 Current Config:")
    print("   AutoEliteHunter: " .. tostring(config.AutoEliteHunter))
    print("   AutoBuso: " .. tostring(config.AutoBuso))
end

print("✅ ConfigManager Loaded")
