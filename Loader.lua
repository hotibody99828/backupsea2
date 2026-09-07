-- ==================================================
-- YOKUDO HUB | SEA3 | [Premium] | Loader (CHECK ALL CONFIG FEATURES)
-- ==================================================
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/hotibody99828/backupsea2/main/Loader.lua"))()
-- ==================================================

local BASE_URL = "https://raw.githubusercontent.com/hotibody99828/backupsea2/main/"

print("🔵 Loading YOKUDO HUB | SEA3 | [Premium]...")

-- ==================================================
-- ⭐ CACHE SYSTEM
-- ==================================================
_G.YOKUDO_Cache = _G.YOKUDO_Cache or {}

local function GetScript(path)
    local fullPath = BASE_URL .. path
    if _G.YOKUDO_Cache[fullPath] then
        return _G.YOKUDO_Cache[fullPath]
    end
    local script = game:HttpGet(fullPath)
    _G.YOKUDO_Cache[fullPath] = script
    return script
end

-- ==================================================
-- WAIT UNTIL GAME IS LOADED
-- ==================================================
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("✅ Game loaded, Player: " .. Player.Name)

-- ==================================================
-- AUTO JOIN MARINES
-- ==================================================
if _G.YOKUDO_HasJoinedMarines == nil then
    _G.YOKUDO_HasJoinedMarines = false
end

task.spawn(function()
    local success = pcall(function()
        ReplicatedStorage:WaitForChild("Remotes", 5)
    end)
    
    if success and not _G.YOKUDO_HasJoinedMarines then
        pcall(function()
            local args = {"SetTeam2", "Marines"}
            local Remote = ReplicatedStorage:FindFirstChild("Remotes")
            if Remote then
                local CommF = Remote:FindFirstChild("CommF_")
                if CommF then
                    CommF:InvokeServer(unpack(args))
                    _G.YOKUDO_HasJoinedMarines = true
                    print("⚓ Joined Team Marines!")
                end
            end
        end)
    end
end)

Player.CharacterAdded:Connect(function()
    if _G.YOKUDO_HasJoinedMarines then return end
    task.wait(0.5)
    if not _G.YOKUDO_HasJoinedMarines then
        pcall(function()
            local args = {"SetTeam2", "Marines"}
            local Remote = ReplicatedStorage:FindFirstChild("Remotes")
            if Remote then
                local CommF = Remote:FindFirstChild("CommF_")
                if CommF then
                    CommF:InvokeServer(unpack(args))
                    _G.YOKUDO_HasJoinedMarines = true
                    print("⚓ Joined Team Marines! (After Respawn)")
                end
            end
        end)
    end
end)

-- ==================================================
-- LOAD CONFIG & CORE
-- ==================================================
loadstring(GetScript("Config/Settings.lua"))()
loadstring(GetScript("Core/Services.lua"))()
loadstring(GetScript("Core/Player.lua"))()
loadstring(GetScript("Core/Utils.lua"))()

-- ==================================================
-- LOAD UI & TABS
-- ==================================================
task.spawn(function()
    loadstring(GetScript("UI/Toggle.lua"))()
    loadstring(GetScript("UI/Main.lua"))()
    loadstring(GetScript("UI/Components.lua"))()
    loadstring(GetScript("UI/Drag.lua"))()
    loadstring(GetScript("UI/Tabs.lua"))()
    print("✅ UI & Tabs Loaded")
end)

-- ==================================================
-- LOAD FEATURES
-- ==================================================
task.spawn(function()
    local Features = {
        "SpeedHack",
        "JumpHack",
        "AutoEquip",
        "AutoAttack",
        "AutoClickAttack",
        "WalkOnWater",
        "AutoBuso",
        "AutoKen",
        "AutoUnlockHaki",
        "JoinServer",
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
        "CharacterHandler",
        "WeaponWatcher"
    }
    
    for _, Feature in ipairs(Features) do
        pcall(function()
            loadstring(GetScript("Features/" .. Feature .. ".lua"))()
        end)
    end
    print("✅ All Features Loaded")
    _G.YOKUDO_FeaturesReady = true
end)

-- ==================================================
-- ⭐ LOAD CONFIG MANAGER (រង់ចាំ Features ដែលមាន Config ទាំងអស់)
-- ==================================================
task.spawn(function()
    print("⏳ Waiting for UI & Config Features...")

    -- ⭐ រង់ចាំ UI
    while not _G.YOKUDO_AutoHopPage do
        task.wait(0.05)
    end

    -- ⭐ រង់ចាំ Features ដែលមាន Config ទាំងអស់
    local maxWait = 5
    local waited = 0
    local allConfigReady = false

    while waited < maxWait do
        local busoReady = _G.YOKUDO_SetBuso ~= nil
        local walkReady = _G.YOKUDO_SetWalk ~= nil
        local unlockHakiReady = _G.YOKUDO_ToggleAutoUnlockHaki ~= nil
        local clickReady = _G.YOKUDO_ToggleAutoClickAttack ~= nil
        local doughKingReady = _G.YOKUDO_ToggleAutoDoughKing ~= nil
        local ripIndraReady = _G.YOKUDO_ToggleAutoRipIndra ~= nil
        local cakePrinceReady = _G.YOKUDO_ToggleAutoCakePrince ~= nil
        local soulReaperReady = _G.YOKUDO_ToggleAutoSoulReaper ~= nil
        local eliteHunterReady = _G.YOKUDO_ToggleAutoEliteHunter ~= nil
        local weaponReady = _G.YOKUDO_SetWeaponType ~= nil

        -- ⭐ ពិនិត្យ Features ដែលមាន Config ទាំងអស់
        if busoReady and walkReady and unlockHakiReady and clickReady and 
           doughKingReady and ripIndraReady and cakePrinceReady and 
           soulReaperReady and eliteHunterReady and weaponReady then
            allConfigReady = true
            break
        end

        task.wait(0.1)
        waited = waited + 0.1
    end

    if allConfigReady then
        print("✅ All Config Features ready! Loading ConfigManager...")
    else
        print("⚠️ Some Config Features not ready, continuing anyway...")
        print("   Buso: " .. tostring(_G.YOKUDO_SetBuso ~= nil))
        print("   Walk: " .. tostring(_G.YOKUDO_SetWalk ~= nil))
        print("   UnlockHaki: " .. tostring(_G.YOKUDO_ToggleAutoUnlockHaki ~= nil))
        print("   Click: " .. tostring(_G.YOKUDO_ToggleAutoClickAttack ~= nil))
        print("   DoughKing: " .. tostring(_G.YOKUDO_ToggleAutoDoughKing ~= nil))
        print("   RipIndra: " .. tostring(_G.YOKUDO_ToggleAutoRipIndra ~= nil))
        print("   CakePrince: " .. tostring(_G.YOKUDO_ToggleAutoCakePrince ~= nil))
        print("   SoulReaper: " .. tostring(_G.YOKUDO_ToggleAutoSoulReaper ~= nil))
        print("   EliteHunter: " .. tostring(_G.YOKUDO_ToggleAutoEliteHunter ~= nil))
        print("   Weapon: " .. tostring(_G.YOKUDO_SetWeaponType ~= nil))
    end

    -- ⭐ Load ConfigManager
    loadstring(GetScript("Config/ConfigManager.lua"))()

    while not _G.YOKUDO_ApplyConfig do
        task.wait(0.05)
    end

    print("⏳ Applying config...")
    _G.YOKUDO_ApplyConfig()
    print("✅ Config applied successfully!")
end)

print("🚀 YOKUDO HUB | SEA3 | [Premium] Ready!")
