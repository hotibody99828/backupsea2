-- ==================================================
-- YOKUDO HUB | SEA3 | [Premium] | Loader
-- ==================================================

local BASE_URL = "https://raw.githubusercontent.com/hotibody99828/backupsea2/main/"

print("🔵 Loading YOKUDO HUB | SEA3 | [Premium]...")

-- ==================================================
-- WAIT UNTIL GAME IS LOADED
-- ==================================================
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("✅ Game loaded, Player: " .. Player.Name)

-- ==================================================
-- ⭐ DISABLE UI UNTIL FULLY LOADED
-- ==================================================
local CoreGui = game:GetService("CoreGui")

-- លុប UI ចាស់បើមាន
pcall(function()
    local oldHub = CoreGui:FindFirstChild("YOKUDO_HUB")
    if oldHub then oldHub:Destroy() end
    local oldToggle = CoreGui:FindFirstChild("ToggleGUI")
    if oldToggle then oldToggle:Destroy() end
end)

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
-- ⭐ LOAD EVERYTHING IN PARALLEL (UI + Tabs + Features + Config)
-- ==================================================

-- Flag to track loading status
local loadStatus = {
    Core = false,
    UI = false,
    Tabs = false,
    Features = false,
    ConfigManager = false,
    ConfigApplied = false,
}

-- ==================================================
-- 1. LOAD CONFIG & CORE
-- ==================================================
task.spawn(function()
    loadstring(game:HttpGet(BASE_URL .. "Config/Settings.lua"))()
    loadstring(game:HttpGet(BASE_URL .. "Core/Services.lua"))()
    loadstring(game:HttpGet(BASE_URL .. "Core/Player.lua"))()
    loadstring(game:HttpGet(BASE_URL .. "Core/Utils.lua"))()
    loadStatus.Core = true
    print("✅ Core Loaded")
end)

-- ==================================================
-- 2. LOAD UI (Toggle + Main + Components + Drag)
-- ==================================================
task.spawn(function()
    loadstring(game:HttpGet(BASE_URL .. "UI/Toggle.lua"))()
    loadstring(game:HttpGet(BASE_URL .. "UI/Main.lua"))()
    loadstring(game:HttpGet(BASE_URL .. "UI/Components.lua"))()
    loadstring(game:HttpGet(BASE_URL .. "UI/Drag.lua"))()
    loadStatus.UI = true
    print("✅ UI Loaded")
end)

-- ==================================================
-- 3. LOAD TABS
-- ==================================================
task.spawn(function()
    loadstring(game:HttpGet(BASE_URL .. "UI/Tabs.lua"))()
    loadStatus.Tabs = true
    print("✅ Tabs Loaded")
end)

-- ==================================================
-- 4. LOAD FEATURES
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
            loadstring(game:HttpGet(BASE_URL .. "Features/" .. Feature .. ".lua"))()
        end)
    end
    
    loadStatus.Features = true
    print("✅ All Features Loaded")
end)

-- ==================================================
-- 5. LOAD CONFIG MANAGER
-- ==================================================
task.spawn(function()
    loadstring(game:HttpGet(BASE_URL .. "Config/ConfigManager.lua"))()
    
    while not _G.YOKUDO_ApplyConfig do
        task.wait(0.1)
    end
    
    loadStatus.ConfigManager = true
    print("✅ ConfigManager Loaded")
end)

-- ==================================================
-- 6. ⭐ WAIT FOR EVERYTHING & APPLY CONFIG
-- ==================================================
task.spawn(function()
    print("⏳ Waiting for all modules to load...")
    
    -- រង់ចាំទាំងអស់
    while not loadStatus.Core or 
          not loadStatus.UI or 
          not loadStatus.Tabs or 
          not loadStatus.Features or 
          not loadStatus.ConfigManager do
        task.wait(0.1)
    end
    
    print("✅ All modules loaded! Applying config...")
    
    -- Apply Config
    if _G.YOKUDO_ApplyConfig then
        _G.YOKUDO_ApplyConfig()
        loadStatus.ConfigApplied = true
        print("✅ Config applied successfully!")
    end
    
    -- ==============================================
    -- ⭐ SHOW UI
    -- ==============================================
    task.wait(0.3)
    
    -- Show Main UI
    local MainUI = CoreGui:FindFirstChild("YOKUDO_HUB")
    if MainUI then
        MainUI.Enabled = true
        print("✅ Main UI shown!")
    end
    
    -- Show Toggle Button
    local ToggleGUI = CoreGui:FindFirstChild("ToggleGUI")
    if ToggleGUI then
        ToggleGUI.Enabled = true
        print("✅ Toggle button shown!")
    end
    
    print("🚀 YOKUDO HUB | SEA3 | [Premium] Ready!")
end)

print("🚀 YOKUDO HUB | SEA3 | [Premium] Loading...")
