-- ==================================================
-- CONFIG MANAGER (Auto Save & Load - Test)
-- ==================================================

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- ==================================================
-- CONFIG PATH
-- ==================================================
local CONFIG_PATH = "YOKUDOHUB/sea3_config.json"

-- ==================================================
-- DEFAULT CONFIG (សម្រាប់ Test)
-- ==================================================
local DEFAULT_CONFIG = {
    -- Auto Elite Hunter
    AutoEliteHunter = false,
    
    -- Auto Buso
    AutoBuso = false,
}

-- ==================================================
-- STATE
-- ==================================================
local currentConfig = nil
local isSaving = false
local lastSaveTime = 0
local SAVE_INTERVAL = 1 -- រក្សាទុករាល់ 1 វិនាទី

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
        print("💾 Config Auto-Saved!")
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
-- UPDATE CONFIG (Auto Save)
-- ==================================================
function _G.YOKUDO_UpdateConfig(key, value)
    local config = _G.YOKUDO_GetConfig()
    config[key] = value
    currentConfig = config
    saveConfig(config)
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
-- AUTO SAVE LOOP (រាល់ 1 វិនាទី)
-- ==================================================
task.spawn(function()
    while true do
        task.wait(SAVE_INTERVAL)
        
        if currentConfig and tick() - lastSaveTime >= SAVE_INTERVAL then
            local currentState = {
                AutoEliteHunter = _G.YOKUDO_AutoEliteHunterEnabled or false,
                AutoBuso = _G.YOKUDO_BusoEnabled or false,
            }
            
            -- ពិនិត្យថាមានការផ្លាស់ប្តូរឬអត់
            local hasChanged = false
            for key, value in pairs(currentState) do
                if currentConfig[key] ~= value then
                    hasChanged = true
                    break
                end
            end
            
            if hasChanged then
                for key, value in pairs(currentState) do
                    currentConfig[key] = value
                end
                saveConfig(currentConfig)
                lastSaveTime = tick()
            end
        end
    end
end)

print("✅ ConfigManager Loaded (Auto Save & Load)")
