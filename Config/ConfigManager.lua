-- ==================================================
-- CONFIG MANAGER (Auto Save & Load - FULL)
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
local SAVE_INTERVAL = 0.5

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
        return data
    end
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
    
    saveConfig(DEFAULT_CONFIG)
    currentConfig = DEFAULT_CONFIG
    return currentConfig
end

-- ==================================================
-- FORCE SAVE CURRENT STATE
-- ==================================================
function _G.YOKUDO_SaveCurrentState()
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
-- RESET CONFIG
-- ==================================================
function _G.YOKUDO_ResetConfig()
    currentConfig = DEFAULT_CONFIG
    saveConfig(DEFAULT_CONFIG)
end

-- ==================================================
-- AUTO SAVE LOOP (រាល់ 0.5 វិនាទី)
-- ==================================================
task.spawn(function()
    while true do
        task.wait(SAVE_INTERVAL)
        
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
-- Hook Auto Elite Hunter
local oldToggleElite = _G.YOKUDO_ToggleAutoEliteHunter
if oldToggleElite then
    _G.YOKUDO_ToggleAutoEliteHunter = function()
        oldToggleElite()
        task.wait(0.1)
        _G.YOKUDO_SaveCurrentState()
    end
end

-- Hook Auto Buso
local oldToggleBuso = _G.YOKUDO_ToggleAutoBuso
if oldToggleBuso then
    _G.YOKUDO_ToggleAutoBuso = function()
        oldToggleBuso()
        task.wait(0.1)
        _G.YOKUDO_SaveCurrentState()
    end
end

print("✅ ConfigManager Loaded")
