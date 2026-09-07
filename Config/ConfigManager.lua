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
    -- Movement Hacks
    WalkOnWater = false,
    
    -- Auto Abilities
    AutoBuso = false,
    
    -- Shop
    AutoUnlockHaki = false,
    
    -- Combat
    AutoClickAttack = false,
    
    -- Farm Bosses
    AutoDoughKing = false,
    AutoRipIndra = false,
    AutoCakePrince = false,
    AutoSoulReaper = false,
    AutoEliteHunter = false,
    
    -- Auto Hop
    AutoHopDoughKing = false,
    AutoHopRipIndra = false,
    AutoHopCakePrince = false,
    AutoHopSoulReaper = false,
    AutoHopEliteHunter = false,
    
    -- Weapon
    WeaponType = "Melee",
}

-- ==================================================
-- INIT
-- ==================================================
_G.YOKUDO_Config = _G.YOKUDO_Config or {}

-- ==================================================
-- SAVE CONFIG (រក្សាទុក Config)
-- ==================================================
function _G.YOKUDO_SaveConfig()
    local json = HttpService:JSONEncode(_G.YOKUDO_Config)
    
    local success = pcall(function()
        if writefile then
            writefile(CONFIG_FILE, json)
        elseif syn and syn.crypt then
            syn.crypt.custom_writefile(CONFIG_FILE, json)
        end
    end)
    
    if success then
        print("✅ Config Saved for: " .. Player.Name)
    else
        print("⚠️ Failed to save config!")
    end
end

-- ==================================================
-- UPDATE SINGLE CONFIG (កែប្រែតម្លៃមួយ ហើយ Save ភ្លាម)
-- ==================================================
function _G.YOKUDO_UpdateConfig(key, value)
    if not _G.YOKUDO_Config then
        _G.YOKUDO_Config = {}
    end
    _G.YOKUDO_Config[key] = value
    _G.YOKUDO_SaveConfig()
    print("📝 Config Updated: " .. key .. " = " .. tostring(value))
end

-- ==================================================
-- LOAD CONFIG (ផ្ទុក Config ពី File)
-- ==================================================
function _G.YOKUDO_LoadConfig()
    local json = nil
    
    -- ព្យាយាមអានពី writefile
    if writefile then
        local ok, data = pcall(writefile, CONFIG_FILE)  -- ប្រើ readfile មិនមែន writefile
        if ok then json = data end
    end
    
    -- ព្យាយាមអានពី syn
    if not json and syn and syn.crypt then
        local ok, data = pcall(syn.crypt.custom_readfile, CONFIG_FILE)
        if ok then json = data end
    end
    
    -- បើមាន Config រួច ផ្ទុកមក
    if json and json ~= "" then
        local success, config = pcall(HttpService.JSONDecode, HttpService, json)
        if success and config then
            for k, v in pairs(DEFAULT) do
                _G.YOKUDO_Config[k] = config[k] ~= nil and config[k] or v
            end
            print("✅ Config Loaded for: " .. Player.Name)
            print("   WalkOnWater: " .. tostring(_G.YOKUDO_Config.WalkOnWater))
            print("   AutoBuso: " .. tostring(_G.YOKUDO_Config.AutoBuso))
            print("   AutoUnlockHaki: " .. tostring(_G.YOKUDO_Config.AutoUnlockHaki))
            print("   AutoClickAttack: " .. tostring(_G.YOKUDO_Config.AutoClickAttack))
            print("   AutoDoughKing: " .. tostring(_G.YOKUDO_Config.AutoDoughKing))
            print("   AutoRipIndra: " .. tostring(_G.YOKUDO_Config.AutoRipIndra))
            print("   AutoCakePrince: " .. tostring(_G.YOKUDO_Config.AutoCakePrince))
            print("   AutoSoulReaper: " .. tostring(_G.YOKUDO_Config.AutoSoulReaper))
            print("   AutoEliteHunter: " .. tostring(_G.YOKUDO_Config.AutoEliteHunter))
            print("   WeaponType: " .. tostring(_G.YOKUDO_Config.WeaponType))
            return
        end
    end
    
    -- បើគ្មាន Config ឬអានមិនបាន ប្រើ DEFAULT
    for k, v in pairs(DEFAULT) do
        _G.YOKUDO_Config[k] = v
    end
    _G.YOKUDO_SaveConfig()
    print("📁 New config created for: " .. Player.Name)
end

-- ==================================================
-- SET FUNCTIONS FOR FEATURES (ឲ្យ Features អាចប្រើបាន)
-- ==================================================
-- មុខងារទាំងនេះនឹងត្រូវបានកំណត់ដោយ Features
_G.YOKUDO_SetWalk = _G.YOKUDO_SetWalk or function(state) end
_G.YOKUDO_SetBuso = _G.YOKUDO_SetBuso or function(state) end
_G.YOKUDO_SetWeaponType = _G.YOKUDO_SetWeaponType or function(type) end

-- ==================================================
-- UPDATE UI FUNCTIONS (ឲ្យ Tabs.lua អាច Update UI បាន)
-- ==================================================
_G.YOKUDO_UpdateUI_Walk = _G.YOKUDO_UpdateUI_Walk or function(state) end
_G.YOKUDO_UpdateUI_Buso = _G.YOKUDO_UpdateUI_Buso or function(state) end
_G.YOKUDO_UpdateUI_UnlockHaki = _G.YOKUDO_UpdateUI_UnlockHaki or function(state) end
_G.YOKUDO_UpdateUI_ClickAttack = _G.YOKUDO_UpdateUI_ClickAttack or function(state) end
_G.YOKUDO_UpdateUI_DoughKing = _G.YOKUDO_UpdateUI_DoughKing or function(state) end
_G.YOKUDO_UpdateUI_RipIndra = _G.YOKUDO_UpdateUI_RipIndra or function(state) end
_G.YOKUDO_UpdateUI_CakePrince = _G.YOKUDO_UpdateUI_CakePrince or function(state) end
_G.YOKUDO_UpdateUI_SoulReaper = _G.YOKUDO_UpdateUI_SoulReaper or function(state) end
_G.YOKUDO_UpdateUI_EliteHunter = _G.YOKUDO_UpdateUI_EliteHunter or function(state) end

-- ==================================================
-- APPLY CONFIG (អនុវត្ត Config ទាំងអស់)
-- ==================================================
function _G.YOKUDO_ApplyConfig()
    print("🔄 Applying config for: " .. Player.Name)
    
    local c = _G.YOKUDO_Config
    
    -- ==============================================
    -- WALK ON WATER
    -- ==============================================
    if c.WalkOnWater and _G.YOKUDO_SetWalk then
        _G.YOKUDO_SetWalk(true)
        print("✅ Walk on Water applied from config")
    elseif _G.YOKUDO_SetWalk then
        _G.YOKUDO_SetWalk(false)
    end
    if _G.YOKUDO_UpdateUI_Walk then
        _G.YOKUDO_UpdateUI_Walk(c.WalkOnWater)
    end
    
    -- ==============================================
    -- AUTO BUSO
    -- ==============================================
    if c.AutoBuso and _G.YOKUDO_SetBuso then
        _G.YOKUDO_SetBuso(true)
        print("✅ Auto Buso applied from config")
    elseif _G.YOKUDO_SetBuso then
        _G.YOKUDO_SetBuso(false)
    end
    if _G.YOKUDO_UpdateUI_Buso then
        _G.YOKUDO_UpdateUI_Buso(c.AutoBuso)
    end
    
    -- ==============================================
    -- AUTO UNLOCK HAKI
    -- ==============================================
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
    
    -- ==============================================
    -- AUTO CLICK ATTACK
    -- ==============================================
    if c.AutoClickAttack and _G.YOKUDO_ToggleAutoClickAttack then
        if not _G.YOKUDO_AutoClickAttackEnabled then
            _G.YOKUDO_ToggleAutoClickAttack()
            print("✅ Auto Click Attack applied from config")
        end
    else
        if _G.YOKUDO_AutoClickAttackEnabled and _G.YOKUDO_ToggleAutoClickAttack then
            _G.YOKUDO_ToggleAutoClickAttack()
            print("❌ Auto Click Attack stopped from config")
        end
    end
    if _G.YOKUDO_UpdateUI_ClickAttack then
        _G.YOKUDO_UpdateUI_ClickAttack(c.AutoClickAttack)
    end
    
    -- ==============================================
    -- AUTO DOUGH KING
    -- ==============================================
    if c.AutoDoughKing and _G.YOKUDO_ToggleAutoDoughKing then
        if not _G.YOKUDO_AutoDoughKingEnabled then
            _G.YOKUDO_ToggleAutoDoughKing()
            print("✅ Auto Dough King applied from config")
        end
    else
        if _G.YOKUDO_AutoDoughKingEnabled and _G.YOKUDO_ToggleAutoDoughKing then
            _G.YOKUDO_ToggleAutoDoughKing()
            print("❌ Auto Dough King stopped from config")
        end
    end
    if _G.YOKUDO_UpdateUI_DoughKing then
        _G.YOKUDO_UpdateUI_DoughKing(c.AutoDoughKing)
    end
    
    -- ==============================================
    -- AUTO RIP INDRA
    -- ==============================================
    if c.AutoRipIndra and _G.YOKUDO_ToggleAutoRipIndra then
        if not _G.YOKUDO_AutoRipIndraEnabled then
            _G.YOKUDO_ToggleAutoRipIndra()
            print("✅ Auto Rip Indra applied from config")
        end
    else
        if _G.YOKUDO_AutoRipIndraEnabled and _G.YOKUDO_ToggleAutoRipIndra then
            _G.YOKUDO_ToggleAutoRipIndra()
            print("❌ Auto Rip Indra stopped from config")
        end
    end
    if _G.YOKUDO_UpdateUI_RipIndra then
        _G.YOKUDO_UpdateUI_RipIndra(c.AutoRipIndra)
    end
    
    -- ==============================================
    -- AUTO CAKE PRINCE
    -- ==============================================
    if c.AutoCakePrince and _G.YOKUDO_ToggleAutoCakePrince then
        if not _G.YOKUDO_AutoCakePrinceEnabled then
            _G.YOKUDO_ToggleAutoCakePrince()
            print("✅ Auto Cake Prince applied from config")
        end
    else
        if _G.YOKUDO_AutoCakePrinceEnabled and _G.YOKUDO_ToggleAutoCakePrince then
            _G.YOKUDO_ToggleAutoCakePrince()
            print("❌ Auto Cake Prince stopped from config")
        end
    end
    if _G.YOKUDO_UpdateUI_CakePrince then
        _G.YOKUDO_UpdateUI_CakePrince(c.AutoCakePrince)
    end
    
    -- ==============================================
    -- AUTO SOUL REAPER
    -- ==============================================
    if c.AutoSoulReaper and _G.YOKUDO_ToggleAutoSoulReaper then
        if not _G.YOKUDO_AutoSoulReaperEnabled then
            _G.YOKUDO_ToggleAutoSoulReaper()
            print("✅ Auto Soul Reaper applied from config")
        end
    else
        if _G.YOKUDO_AutoSoulReaperEnabled and _G.YOKUDO_ToggleAutoSoulReaper then
            _G.YOKUDO_ToggleAutoSoulReaper()
            print("❌ Auto Soul Reaper stopped from config")
        end
    end
    if _G.YOKUDO_UpdateUI_SoulReaper then
        _G.YOKUDO_UpdateUI_SoulReaper(c.AutoSoulReaper)
    end
    
    -- ==============================================
    -- AUTO ELITE HUNTER
    -- ==============================================
    if c.AutoEliteHunter and _G.YOKUDO_ToggleAutoEliteHunter then
        if not _G.YOKUDO_AutoEliteHunterEnabled then
            _G.YOKUDO_ToggleAutoEliteHunter()
            print("✅ Auto Elite Hunter applied from config")
        end
    else
        if _G.YOKUDO_AutoEliteHunterEnabled and _G.YOKUDO_ToggleAutoEliteHunter then
            _G.YOKUDO_ToggleAutoEliteHunter()
            print("❌ Auto Elite Hunter stopped from config")
        end
    end
    if _G.YOKUDO_UpdateUI_EliteHunter then
        _G.YOKUDO_UpdateUI_EliteHunter(c.AutoEliteHunter)
    end
    
    -- ==============================================
    -- AUTO HOP (ផ្ទៀងផ្ទាត់ UI Checkbox)
    -- ==============================================
    -- Auto Hop Dough King
    if c.AutoHopDoughKing and _G.YOKUDO_ToggleAutoHopDoughKing then
        _G.YOKUDO_ToggleAutoHopDoughKing()
        print("✅ Auto Hop Dough King applied from config")
    end
    
    -- Auto Hop Rip Indra
    if c.AutoHopRipIndra and _G.YOKUDO_ToggleAutoHopRipIndra then
        _G.YOKUDO_ToggleAutoHopRipIndra()
        print("✅ Auto Hop Rip Indra applied from config")
    end
    
    -- Auto Hop Cake Prince
    if c.AutoHopCakePrince and _G.YOKUDO_ToggleAutoHopCakePrince then
        _G.YOKUDO_ToggleAutoHopCakePrince()
        print("✅ Auto Hop Cake Prince applied from config")
    end
    
    -- Auto Hop Soul Reaper
    if c.AutoHopSoulReaper and _G.YOKUDO_ToggleAutoHopSoulReaper then
        _G.YOKUDO_ToggleAutoHopSoulReaper()
        print("✅ Auto Hop Soul Reaper applied from config")
    end
    
    -- Auto Hop Elite Hunter
    if c.AutoHopEliteHunter and _G.YOKUDO_ToggleAutoHopEliteHunter then
        _G.YOKUDO_ToggleAutoHopEliteHunter()
        print("✅ Auto Hop Elite Hunter applied from config")
    end
    
    -- ==============================================
    -- WEAPON TYPE
    -- ==============================================
    local weaponType = c.WeaponType or "Melee"
    if _G.YOKUDO_SetWeaponType then
        _G.YOKUDO_SetWeaponType(weaponType)
        print("✅ Weapon Type applied from config: " .. weaponType)
    end
    
    -- ធ្វើបច្ចុប្បន្នភាព UI Weapon Button
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
