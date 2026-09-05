-- ==================================================
-- YOKUDO HUB | SEA3 | [Premium] | Loader
-- ==================================================
-- URL តែមួយគត់៖
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/hotibody99828/backupsea2/main/Loader.lua"))()
-- ==================================================

local BASE_URL = "https://raw.githubusercontent.com/hotibody99828/backupsea2/main/"

print("🔵 Loading YOKUDO HUB | SEA3 | [Premium]...")

repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("✅ Game loaded, Player: " .. Player.Name)

-- Auto Join Marines
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

-- Load Config & Core
loadstring(game:HttpGet(BASE_URL .. "Config/Settings.lua"))()
loadstring(game:HttpGet(BASE_URL .. "Core/Services.lua"))()
loadstring(game:HttpGet(BASE_URL .. "Core/Player.lua"))()
loadstring(game:HttpGet(BASE_URL .. "Core/Utils.lua"))()

-- Load Save System
loadstring(game:HttpGet(BASE_URL .. "Features/SaveLoad.lua"))()

-- Load UI & Tabs
task.spawn(function()
    loadstring(game:HttpGet(BASE_URL .. "UI/Toggle.lua"))()
    loadstring(game:HttpGet(BASE_URL .. "UI/Main.lua"))()
    loadstring(game:HttpGet(BASE_URL .. "UI/Components.lua"))()
    loadstring(game:HttpGet(BASE_URL .. "UI/Drag.lua"))()
    loadstring(game:HttpGet(BASE_URL .. "UI/Tabs.lua"))()
    print("✅ UI & Tabs Loaded")
end)

-- Load Features & Apply State
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
            print("✅ " .. Feature .. " Loaded")
        end)
    end
    print("✅ All Features Loaded")
    
    task.wait(0.5)
    local loaded = _G.YOKUDO_LoadConfig()
    if loaded then
        print("📂 Config loaded!")
    else
        print("📝 No config found, using defaults")
    end
    
    task.wait(0.3)
    _G.YOKUDO_ApplyState()
end)

print("🚀 YOKUDO HUB | SEA3 | [Premium] Ready!")
