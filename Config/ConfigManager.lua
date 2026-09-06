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
    
    -- Auto Click Attack
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
    
    -- Auto Dough King
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
    
    -- Auto Rip Indra
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
    
    -- Auto Cake Prince
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
    
    -- Auto Soul Reaper
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
    
    -- Auto Elite Hunter
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
    
    -- Weapon Type
    local weaponType = c.WeaponType or "Melee"
    if _G.YOKUDO_SetWeaponType then
        _G.YOKUDO_SetWeaponType(weaponType)
        print("✅ Weapon Type applied from config: " .. weaponType)
    end
    
    print("✅ Config applied for: " .. Player.Name)
end

-- ==================================================
-- LOAD CONFIG ON START
-- ==================================================
_G.YOKUDO_LoadConfig()

print("✅ ConfigManager Loaded")
print("📁 Config file: " .. CONFIG_FILE)
