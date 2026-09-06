-- ==================================================
-- CONFIG MANAGER (SEA3 - Save/Load)
-- ==================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- ==================================================
-- CONFIG PATH
-- ==================================================
local CONFIG_FOLDER = "YOKUDOSEA3/"
local CONFIG_FILE = CONFIG_FOLDER .. Player.Name .. ".json"

pcall(function()
    if makefolder then
        makefolder(CONFIG_FOLDER)
    end
end)

-- ==================================================
-- DEFAULT CONFIG
-- ==================================================
local DEFAULT = {
    WalkOnWater = false,
    AutoBuso = false,
    AutoUnlockHaki = false,
    WeaponType = "Melee",
}

-- ==================================================
-- INIT
-- ==================================================
_G.YOKUDO_Config = _G.YOKUDO_Config or {}

-- ==================================================
-- LOAD
-- ==================================================
function _G.YOKUDO_LoadConfig()
    local json = nil
    
    if readfile then
        local ok, data = pcall(readfile, CONFIG_FILE)
        if ok then json = data end
    elseif syn and syn.crypt then
        local ok, data = pcall(syn.crypt.custom_readfile, CONFIG_FILE)
        if ok then json = data end
    end
    
    if json and json ~= "" then
        local config = HttpService:JSONDecode(json)
        if config then
            for k, v in pairs(DEFAULT) do
                _G.YOKUDO_Config[k] = config[k] ~= nil and config[k] or v
            end
            print("✅ Config Loaded for: " .. Player.Name)
            print("   WalkOnWater: " .. tostring(_G.YOKUDO_Config.WalkOnWater))
            print("   AutoBuso: " .. tostring(_G.YOKUDO_Config.AutoBuso))
            print("   AutoUnlockHaki: " .. tostring(_G.YOKUDO_Config.AutoUnlockHaki))
            print("   WeaponType: " .. tostring(_G.YOKUDO_Config.WeaponType))
            return
        end
    end
    
    for k, v in pairs(DEFAULT) do
        _G.YOKUDO_Config[k] = v
    end
    _G.YOKUDO_SaveConfig()
end

-- ==================================================
-- SAVE
-- ==================================================
function _G.YOKUDO_SaveConfig()
    local json = HttpService:JSONEncode(_G.YOKUDO_Config)
    
    if writefile then
        writefile(CONFIG_FILE, json)
    elseif syn and syn.crypt then
        syn.crypt.custom_writefile(CONFIG_FILE, json)
    end
    
    print("✅ Config Saved for: " .. Player.Name)
end

-- ==================================================
-- UPDATE
-- ==================================================
function _G.YOKUDO_UpdateConfig(key, value)
    _G.YOKUDO_Config[key] = value
    _G.YOKUDO_SaveConfig()
end

-- ==================================================
-- APPLY CONFIG
-- ==================================================
function _G.YOKUDO_ApplyConfig()
    print("🔄 Applying config for: " .. Player.Name)
    
    local c = _G.YOKUDO_Config
    
    -- Walk on Water
    if c.WalkOnWater and _G.YOKUDO_SetWalk then
        _G.YOKUDO_SetWalk(true)
        print("✅ Walk on Water applied from config")
    elseif _G.YOKUDO_SetWalk then
        _G.YOKUDO_SetWalk(false)
    end
    if _G.YOKUDO_UpdateUI_Walk then
        _G.YOKUDO_UpdateUI_Walk(c.WalkOnWater)
    end
    
    -- Auto Buso
    if c.AutoBuso and _G.YOKUDO_SetBuso then
        _G.YOKUDO_SetBuso(true)
        print("✅ Auto Buso applied from config")
    elseif _G.YOKUDO_SetBuso then
        _G.YOKUDO_SetBuso(false)
    end
    if _G.YOKUDO_UpdateUI_Buso then
        _G.YOKUDO_UpdateUI_Buso(c.AutoBuso)
    end
    
    -- Auto Unlock Haki
    if c.AutoUnlockHaki and _G.YOKUDO_ToggleAutoUnlockHaki then
        if not _G.YOKUDO_AutoUnlockHakiEnabled then
            _G.YOKUDO_ToggleAutoUnlockHaki()
            print("✅ Auto Unlock Haki applied from config")
        end
    else
        if _G.YOKUDO_AutoUnlockHakiEnabled and _G.YOKUDO_ToggleAutoUnlockHaki then
            _G.YOKUDO_ToggleAutoUnlockHaki()
            print("❌ Auto Unlock Haki stopped from config")
        end
    end
    if _G.YOKUDO_UpdateUI_UnlockHaki then
        _G.YOKUDO_UpdateUI_UnlockHaki(c.AutoUnlockHaki)
    end
    
    -- ⭐ Weapon Type
    local weaponType = c.WeaponType or "Melee"
    if _G.YOKUDO_SetWeaponType then
        _G.YOKUDO_SetWeaponType(weaponType)
        print("✅ Weapon Type applied from config: " .. weaponType)
    end
    
    print("✅ Config applied for: " .. Player.Name)
end

_G.YOKUDO_LoadConfig()
print("✅ ConfigManager Loaded")
print("📁 Config file: " .. CONFIG_FILE)
