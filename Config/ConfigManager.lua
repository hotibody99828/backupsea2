-- ==================================================
-- CONFIG MANAGER (Auto Save & Load - DEBUG)
-- ==================================================

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

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
local SAVE_INTERVAL = 1

-- ==================================================
-- CHECK WRITEFILE/READFILE SUPPORT
-- ==================================================
local function checkFileSupport()
    local success, err = pcall(function()
        return isfile and writefile and readfile
    end)
    
    if not success or not isfile or not writefile or not readfile then
        print("⚠️ Executor does not support writefile/readfile!")
        print("⚠️ Config System will not work!")
        return false
    end
    return true
end

-- ==================================================
-- LOAD CONFIG
-- ==================================================
local function loadConfig()
    if not checkFileSupport() then return nil end
    
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
    
    print("📂 Config file not found, using default")
    return nil
end

-- ==================================================
-- SAVE CONFIG
-- ==================================================
local function saveConfig(data)
    if not checkFileSupport() then return end
    if isSaving then return end
    
    isSaving = true
    
    local success, err = pcall(function()
        local json = HttpService:JSONEncode(data)
        writefile(CONFIG_PATH, json)
        print("💾 Config Saved! (" .. CONFIG_PATH .. ")")
        print("   EliteHunter: " .. tostring(data.AutoEliteHunter))
        print("   Buso: " .. tostring(data.AutoBuso))
    end)
    
    if not success then
        warn("⚠️ Failed to save config: " .. tostring(err))
    end
    
    isSaving = false
end

-- ==================================================
-- GET CURRENT STATE FROM GLOBAL
-- ==================================================
local function getCurrentState()
    return {
        AutoEliteHunter = _G.YOKUDO_AutoEliteHunterEnabled or false,
        AutoBuso = _G.YOKUDO_BusoEnabled or false,
    }
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
    
    print("📂 Creating default config...")
    saveConfig(DEFAULT_CONFIG)
    currentConfig = DEFAULT_CONFIG
    return currentConfig
end

-- ==================================================
-- FORCE SAVE CURRENT STATE
-- ==================================================
function _G.YOKUDO_SaveCurrentState()
    if not checkFileSupport() then return false end
    
    local currentState = getCurrentState()
    local config = _G.YOKUDO_GetConfig()
    
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
-- FORCE LOAD CONFIG (ហៅពេលចង់ Load ឡើងវិញ)
-- ==================================================
function _G.YOKUDO_ReloadConfig()
    currentConfig = nil
    return _G.YOKUDO_GetConfig()
end

-- ==================================================
-- RESET CONFIG
-- ==================================================
function _G.YOKUDO_ResetConfig()
    currentConfig = DEFAULT_CONFIG
    saveConfig(DEFAULT_CONFIG)
    print("🔄 Config Reset to Default")
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

-- ==================================================
-- AUTO SAVE LOOP (រាល់ 1 វិនាទី)
-- ==================================================
task.spawn(function()
    while true do
        task.wait(SAVE_INTERVAL)
        
        if not checkFileSupport() then continue end
        
        local currentState = getCurrentState()
        local config = _G.YOKUDO_GetConfig()
        
        local hasChanged = false
        for key, value in pairs(currentState) do
            if config[key] ~= value then
                hasChanged = true
                break
            end
        end
        
        if hasChanged then
            for key, value in pairs(currentState) do
                config[key] = value
            end
            currentConfig = config
            saveConfig(config)
        end
    end
end)

-- ==================================================
-- HOOK INTO TOGGLE FUNCTIONS (Auto Save on Toggle)
-- ==================================================
local function setupToggleHooks()
    -- Hook Auto Elite Hunter
    local oldToggleElite = _G.YOKUDO_ToggleAutoEliteHunter
    if oldToggleElite then
        _G.YOKUDO_ToggleAutoEliteHunter = function()
            oldToggleElite()
            task.wait(0.1)
            _G.YOKUDO_SaveCurrentState()
            _G.YOKUDO_PrintConfig()
        end
        print("🔗 AutoEliteHunter hooked for config")
    else
        print("⚠️ AutoEliteHunter toggle not found, hook failed")
    end
    
    -- Hook Auto Buso
    local oldToggleBuso = _G.YOKUDO_ToggleAutoBuso
    if oldToggleBuso then
        _G.YOKUDO_ToggleAutoBuso = function()
            oldToggleBuso()
            task.wait(0.1)
            _G.YOKUDO_SaveCurrentState()
            _G.YOKUDO_PrintConfig()
        end
        print("🔗 AutoBuso hooked for config")
    else
        print("⚠️ AutoBuso toggle not found, hook failed")
    end
end

-- រង់ចាំ Features Load រួច ទើប Hook
task.spawn(function()
    task.wait(2)
    setupToggleHooks()
    print("✅ ConfigManager Ready")
end)

print("✅ ConfigManager Loaded")
