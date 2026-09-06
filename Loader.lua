-- ==================================================
-- YOKUDO HUB | SEA3 | [Premium] | Loader
-- ==================================================
-- URL តែមួយគត់៖
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/hotibody99828/backupsea2/main/Loader.lua"))()
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
-- AUTO JOIN MARINES (តែម្ដង)
-- ==================================================
if _G.YOKUDO_HasJoinedMarines == nil then
    _G.YOKUDO_HasJoinedMarines = false
end

task.spawn(function()
    local success, err = pcall(function()
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
    if _G.YOKUDO_HasJoinedMarines then
        return
    end
    
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
-- LOAD CONFIG MANAGER (មុនគេ)
-- ==================================================
loadstring(game:HttpGet(BASE_URL .. "Config/Settings.lua"))()
loadstring(game:HttpGet(BASE_URL .. "Config/ConfigManager.lua"))()

-- ==================================================
-- LOAD CORE
-- ==================================================
loadstring(game:HttpGet(BASE_URL .. "Core/Services.lua"))()
loadstring(game:HttpGet(BASE_URL .. "Core/Player.lua"))()
loadstring(game:HttpGet(BASE_URL .. "Core/Utils.lua"))()

-- ==================================================
-- LOAD UI & TABS
-- ==================================================
task.spawn(function()
    loadstring(game:HttpGet(BASE_URL .. "UI/Toggle.lua"))()
    loadstring(game:HttpGet(BASE_URL .. "UI/Main.lua"))()
    loadstring(game:HttpGet(BASE_URL .. "UI/Components.lua"))()
    loadstring(game:HttpGet(BASE_URL .. "UI/Drag.lua"))()
    loadstring(game:HttpGet(BASE_URL .. "UI/Tabs.lua"))()
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
            loadstring(game:HttpGet(BASE_URL .. "Features/" .. Feature .. ".lua"))()
        end)
    end
    print("✅ All Features Loaded")
end)

-- ==================================================
-- LOAD CONFIG AFTER FEATURES (អនុវត្ត Config)
-- ==================================================
task.spawn(function()
    task.wait(2) -- រង់ចាំ Features Load រួច
    
    local config = _G.YOKUDO_GetConfig()
    print("📋 Loading Config...")
    
    -- Auto Click Attack
    if config.AutoClickAttack and _G.YOKUDO_ToggleAutoClickAttack then
        _G.YOKUDO_ToggleAutoClickAttack()
    end
    
    -- Auto Dough King
    if config.AutoDoughKing and _G.YOKUDO_ToggleAutoDoughKing then
        _G.YOKUDO_ToggleAutoDoughKing()
    end
    if config.AutoHopDoughKing and _G.YOKUDO_ToggleAutoHopDoughKing then
        _G.YOKUDO_ToggleAutoHopDoughKing()
    end
    
    -- Auto Rip Indra
    if config.AutoRipIndra and _G.YOKUDO_ToggleAutoRipIndra then
        _G.YOKUDO_ToggleAutoRipIndra()
    end
    if config.AutoHopRipIndra and _G.YOKUDO_ToggleAutoHopRipIndra then
        _G.YOKUDO_ToggleAutoHopRipIndra()
    end
    
    -- Auto Cake Prince
    if config.AutoCakePrince and _G.YOKUDO_ToggleAutoCakePrince then
        _G.YOKUDO_ToggleAutoCakePrince()
    end
    if config.AutoHopCakePrince and _G.YOKUDO_ToggleAutoHopCakePrince then
        _G.YOKUDO_ToggleAutoHopCakePrince()
    end
    
    -- Auto Soul Reaper
    if config.AutoSoulReaper and _G.YOKUDO_ToggleAutoSoulReaper then
        _G.YOKUDO_ToggleAutoSoulReaper()
    end
    if config.AutoHopSoulReaper and _G.YOKUDO_ToggleAutoHopSoulReaper then
        _G.YOKUDO_ToggleAutoHopSoulReaper()
    end
    
    -- Auto Elite Hunter
    if config.AutoEliteHunter and _G.YOKUDO_ToggleAutoEliteHunter then
        _G.YOKUDO_ToggleAutoEliteHunter()
    end
    if config.AutoHopEliteHunter and _G.YOKUDO_ToggleAutoHopEliteHunter then
        _G.YOKUDO_ToggleAutoHopEliteHunter()
    end
    
    -- Auto Unlock Haki
    if config.AutoUnlockHaki and _G.YOKUDO_ToggleAutoUnlockHaki then
        _G.YOKUDO_ToggleAutoUnlockHaki()
    end
    
    -- Auto Buso
    if config.AutoBuso and _G.YOKUDO_ToggleAutoBuso then
        _G.YOKUDO_ToggleAutoBuso()
    end
    
    -- Auto Ken
    if config.AutoKen and _G.YOKUDO_ToggleAutoKen then
        _G.YOKUDO_ToggleAutoKen()
    end
    
    -- Walk on Water
    if config.WalkOnWater and _G.YOKUDO_ToggleWalkOnWater then
        _G.YOKUDO_ToggleWalkOnWater()
    end
    
    -- Values
    if config.SpeedHack then
        _G.YOKUDO_CurrentSpeed = config.SpeedHack
        if _G.YOKUDO_SpeedEnabled then
            _G.YOKUDO_StartSpeedLoop()
        end
    end
    
    if config.JumpHack then
        _G.YOKUDO_CurrentJump = config.JumpHack
        if _G.YOKUDO_JumpEnabled then
            _G.YOKUDO_EnableJumpPower()
        end
    end
    
    if config.SelectedWeapon and _G.YOKUDO_AutoEquip then
        _G.YOKUDO_AutoEquip.SelectedType = config.SelectedWeapon
    end
    
    print("✅ Config Applied!")
end)

print("🚀 YOKUDO HUB | SEA3 | [Premium] Ready!")
