-- ==================================================
-- CONFIG MANAGER (SEA3 - Save & Load)
-- ==================================================

local HttpService = game:GetService("HttpService")

-- ==================================================
-- CONFIG PATH
-- ==================================================
local CONFIG_PATH = "YOKUDOHUB/sea3_config.json"

-- ==================================================
-- DEFAULT CONFIG (SEA3)
-- ==================================================
local DEFAULT_CONFIG = {
    -- Auto Hop
    AutoClickAttack = false,
    
    -- Auto Dough King
    AutoDoughKing = false,
    AutoHopDoughKing = false,
    
    -- Auto Rip Indra
    AutoRipIndra = false,
    AutoHopRipIndra = false,
    
    -- Auto Cake Prince
    AutoCakePrince = false,
    AutoHopCakePrince = false,
    
    -- Auto Soul Reaper
    AutoSoulReaper = false,
    AutoHopSoulReaper = false,
    
    -- Auto Elite Hunter
    AutoEliteHunter = false,
    AutoHopEliteHunter = false,
    
    -- Shop
    AutoUnlockHaki = false,
    
    -- Setting
    AutoBuso = false,
    AutoKen = false,
    WalkOnWater = false,
    NoClip = false,
    
    -- Values
    SpeedHack = 16,
    JumpHack = 50,
    SelectedWeapon = "Melee",
}

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
    local success, err = pcall(function()
        local json = HttpService:JSONEncode(data)
        writefile(CONFIG_PATH, json)
    end)
    
    if not success then
        warn("⚠️ Failed to save config: " .. tostring(err))
    end
end

-- ==================================================
-- GET CONFIG
-- ==================================================
function _G.YOKUDO_GetConfig()
    local config = loadConfig()
    if config then
        return config
    end
    
    saveConfig(DEFAULT_CONFIG)
    return DEFAULT_CONFIG
end

-- ==================================================
-- UPDATE CONFIG
-- ==================================================
function _G.YOKUDO_UpdateConfig(key, value)
    local config = _G.YOKUDO_GetConfig()
    config[key] = value
    saveConfig(config)
end

-- ==================================================
-- RESET CONFIG
-- ==================================================
function _G.YOKUDO_ResetConfig()
    saveConfig(DEFAULT_CONFIG)
    print("✅ Config Reset to Default")
end

-- ==================================================
-- PRINT CONFIG
-- ==================================================
function _G.YOKUDO_PrintConfig()
    local config = _G.YOKUDO_GetConfig()
    print("📋 Current Config:")
    for key, value in pairs(config) do
        print("   " .. key .. ": " .. tostring(value))
    end
end

print("✅ ConfigManager Loaded")
