-- ==================================================
-- CONFIG MANAGER (SEA3 - Save/Load)
-- ==================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- ==================================================
-- CONFIG PATH (ប្រើ Username)
-- ==================================================
local CONFIG_FOLDER = "YOKUDOSEA3/"
local CONFIG_FILE = CONFIG_FOLDER .. Player.Name .. ".json"

-- ==================================================
-- CREATE FOLDER IF NOT EXISTS
-- ==================================================
pcall(function()
    if makefolder then
        makefolder(CONFIG_FOLDER)
    end
end)

-- ==================================================
-- DEFAULT CONFIG
-- ==================================================
local DEFAULT = {
    -- Movement
    WalkOnWater = false,
    
    -- Auto Abilities
    AutoBuso = false,
    AutoKen = false,
    
    -- Combat
    AutoClickAttack = false,
    
    -- Shop
    AutoUnlockHaki = false,
    
    -- Farm Bosses
    AutoDoughKing = false,
    AutoRipIndra = false,
    AutoCakePrince = false,
    AutoSoulReaper = false,
    AutoEliteHunter = false,
    
    -- Weapon
    WeaponType = "Melee",
}

-- ==================================================
-- INIT
-- ==================================================
_G.YOKUDO_Config = _G.YOKUDO_Config or {}

-- ==================================================
-- LOAD CONFIG
-- ==================================================
function _G.YOKUDO_LoadConfig()
    print("📁 Loading config for: " .. Player.Name)
    print("📁 Config file: " .. CONFIG_FILE)
    
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
            return
        end
    end
    
    print("📁 No config found, creating default...")
    for k, v in pairs(DEFAULT) do
        _G.YOKUDO_Config[k] = v
    end
    _G.YOKUDO_SaveConfig()
end

-- ==================================================
-- SAVE CONFIG
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
-- UPDATE SINGLE CONFIG
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
    if c.WalkOnWater and _G.YOKUDO_ToggleWalkOnWater then
        _G.YOKUDO_WalkEnabled = true
        enableWalkOnWater()
        print("✅ Walk on Water: ON")
    end
    if _G.YOKUDO_UpdateUI_Walk then
        _G.YOKUDO_UpdateUI_Walk(c.WalkOnWater)
    end
    
    -- Auto Buso
    if c.AutoBuso and _G.YOKUDO_ToggleAutoBuso then
        _G.YOKUDO_BusoEnabled = true
        startAutoBuso()
        print("✅ Auto Buso: ON")
    end
    if _G.YOKUDO_UpdateUI_Buso then
        _G.YOKUDO_UpdateUI_Buso(c.AutoBuso)
    end
    
    -- Auto Ken
    if c.AutoKen and _G.YOKUDO_ToggleAutoKen then
        _G.YOKUDO_ObservationEnabled = true
        startAutoObservation()
        print("✅ Auto Ken: ON")
    end
    if _G.YOKUDO_UpdateUI_Ken then
        _G.YOKUDO_UpdateUI_Ken(c.AutoKen)
    end
    
    -- Auto Click Attack
    if c.AutoClickAttack and _G.YOKUDO_ToggleAutoClickAttack then
        _G.YOKUDO_AutoClickAttackEnabled = true
        _G.YOKUDO_ClickAttackLoopConnection = task.spawn(clickAttackLoop)
        print("✅ Auto Click Attack: ON")
    end
    if _G.YOKUDO_UpdateUI_ClickAttack then
        _G.YOKUDO_UpdateUI_ClickAttack(c.AutoClickAttack)
    end
    
    -- Auto Unlock Haki
    if c.AutoUnlockHaki and _G.YOKUDO_ToggleAutoUnlockHaki then
        _G.YOKUDO_AutoUnlockHakiEnabled = true
        _G.YOKUDO_AutoUnlockHakiLoop = task.spawn(unlockHakiLoop)
        print("✅ Auto Unlock Haki: ON")
    end
    if _G.YOKUDO_UpdateUI_UnlockHaki then
        _G.YOKUDO_UpdateUI_UnlockHaki(c.AutoUnlockHaki)
    end
    
    -- Auto Dough King
    if c.AutoDoughKing and _G.YOKUDO_ToggleAutoDoughKing then
        _G.YOKUDO_ToggleAutoDoughKing()
        print("✅ Auto Dough King: ON")
    end
    if _G.YOKUDO_UpdateUI_DoughKing then
        _G.YOKUDO_UpdateUI_DoughKing(c.AutoDoughKing)
    end
    
    -- Auto Rip Indra
    if c.AutoRipIndra and _G.YOKUDO_ToggleAutoRipIndra then
        _G.YOKUDO_ToggleAutoRipIndra()
        print("✅ Auto Rip Indra: ON")
    end
    if _G.YOKUDO_UpdateUI_RipIndra then
        _G.YOKUDO_UpdateUI_RipIndra(c.AutoRipIndra)
    end
    
    -- Auto Cake Prince
    if c.AutoCakePrince and _G.YOKUDO_ToggleAutoCakePrince then
        _G.YOKUDO_ToggleAutoCakePrince()
        print("✅ Auto Cake Prince: ON")
    end
    if _G.YOKUDO_UpdateUI_CakePrince then
        _G.YOKUDO_UpdateUI_CakePrince(c.AutoCakePrince)
    end
    
    -- Auto Soul Reaper
    if c.AutoSoulReaper and _G.YOKUDO_ToggleAutoSoulReaper then
        _G.YOKUDO_ToggleAutoSoulReaper()
        print("✅ Auto Soul Reaper: ON")
    end
    if _G.YOKUDO_UpdateUI_SoulReaper then
        _G.YOKUDO_UpdateUI_SoulReaper(c.AutoSoulReaper)
    end
    
    -- Auto Elite Hunter
    if c.AutoEliteHunter and _G.YOKUDO_ToggleAutoEliteHunter then
        _G.YOKUDO_ToggleAutoEliteHunter()
        print("✅ Auto Elite Hunter: ON")
    end
    if _G.YOKUDO_UpdateUI_EliteHunter then
        _G.YOKUDO_UpdateUI_EliteHunter(c.AutoEliteHunter)
    end
    
    -- Weapon Type
    local weaponType = c.WeaponType or "Melee"
    if _G.YOKUDO_AutoEquip then
        _G.YOKUDO_AutoEquip.SelectedType = weaponType
    end
    if _G.YOKUDO_UpdateWeaponButton then
        _G.YOKUDO_UpdateWeaponButton(weaponType)
    end
    
    print("✅ Config applied for: " .. Player.Name)
end

-- ==================================================
-- LOAD CONFIG ON START
-- ==================================================
_G.YOKUDO_LoadConfig()

print("✅ ConfigManager Loaded")
print("📁 Config file: " .. CONFIG_FILE)
