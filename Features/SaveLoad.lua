-- ==================================================
-- SAVE & LOAD SYSTEM (FIXED - គ្មាន BindToClose)
-- ==================================================

local HttpService = game:GetService("HttpService")
local CONFIG_PATH = "YOKUDOHUB/config.json"

-- ==================================================
-- FEATURE LIST
-- ==================================================
local FEATURE_LIST = {
    "SpeedHack",
    "JumpHack",
    "AutoClickAttack",
    "WalkOnWater",
    "AutoBuso",
    "AutoKen",
    "AutoUnlockHaki",
    "AutoDoughKing",
    "AutoHopDoughKing",
    "AutoRipIndra",
    "AutoHopRipIndra",
    "AutoCakePrince",
    "AutoHopCakePrince",
    "AutoSoulReaper",
    "AutoHopSoulReaper",
    "AutoEliteHunter",
    "AutoHopEliteHunter",
    "AutoCore",
}

-- ==================================================
-- GET ALL STATES
-- ==================================================
local function getAllStates()
    local states = {}
    for _, name in ipairs(FEATURE_LIST) do
        local globalName = "YOKUDO_" .. name .. "Enabled"
        states[name] = _G[globalName] or false
    end
    return states
end

-- ==================================================
-- SAVE CONFIG
-- ==================================================
function _G.YOKUDO_SaveConfig()
    local data = { Features = getAllStates() }
    pcall(function()
        local json = HttpService:JSONEncode(data)
        writefile(CONFIG_PATH, json)
        print("💾 Config saved!")
    end)
end

-- ==================================================
-- LOAD CONFIG
-- ==================================================
function _G.YOKUDO_LoadConfig()
    local success, raw = pcall(function()
        if isfile(CONFIG_PATH) then
            return readfile(CONFIG_PATH)
        end
        return nil
    end)
    
    if not success or not raw then
        print("📝 No config found")
        return false
    end
    
    local data = HttpService:JSONDecode(raw)
    if not data or not data.Features then
        return false
    end
    
    for name, enabled in pairs(data.Features) do
        local globalName = "YOKUDO_" .. name .. "Enabled"
        _G[globalName] = enabled
        print("📂 Loaded: " .. name .. " = " .. tostring(enabled))
    end
    
    return true
end

-- ==================================================
-- APPLY STATE
-- ==================================================
function _G.YOKUDO_ApplyState()
    print("🔄 Applying saved states...")
    local count = 0
    
    for _, name in ipairs(FEATURE_LIST) do
        local globalName = "YOKUDO_" .. name .. "Enabled"
        local toggleFuncName = "_G.YOKUDO_Toggle" .. name
        
        if _G[globalName] == true then
            pcall(function()
                local func = loadstring("return " .. toggleFuncName)()
                if func then
                    func()
                    count = count + 1
                    print("✅ " .. name .. " -> Toggled ON")
                end
            end)
        else
            print("⏭️ " .. name .. " -> Skipped (false)")
        end
    end
    
    print("✅ Applied " .. count .. " features!")
end

-- ==================================================
-- MARK DIRTY (Auto Save)
-- ==================================================
local isDirty = false
local saveDebounce = nil

function _G.YOKUDO_MarkDirty()
    isDirty = true
    if saveDebounce then
        task.cancel(saveDebounce)
    end
    saveDebounce = task.spawn(function()
        task.wait(1)
        if isDirty then
            _G.YOKUDO_SaveConfig()
            isDirty = false
        end
        saveDebounce = nil
    end)
end

-- ==================================================
-- ❌ លុប BindToClose ចេញ (មិនអាចប្រើក្នុង Client)
-- ==================================================
-- game:BindToClose(function()
--     if isDirty then
--         _G.YOKUDO_SaveConfig()
--     end
-- end)

print("✅ Save/Load System Loaded")
