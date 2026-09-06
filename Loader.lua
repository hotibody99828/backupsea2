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
-- AUTO JOIN MARINES
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
-- LOAD CONFIG MANAGER
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
        "AutoEquip",
        "AutoAttack",
        "AutoEliteHunter",
        "AutoBuso",
        "CharacterHandler",
        "WeaponWatcher"
    }
    
    for _, Feature in ipairs(Features) do
        pcall(function()
            loadstring(game:HttpGet(BASE_URL .. "Features/" .. Feature .. ".lua"))()
        end)
    end
    print("✅ Features Loaded")
end)

-- ==================================================
-- AUTO LOAD CONFIG
-- ==================================================
task.spawn(function()
    task.wait(1.5)
    
    local config = _G.YOKUDO_GetConfig()
    print("📋 Auto Loading Config...")
    
    if config.AutoEliteHunter and _G.YOKUDO_ToggleAutoEliteHunter then
        _G.YOKUDO_ToggleAutoEliteHunter()
        print("✅ Auto Elite Hunter Loaded from Config")
    end
    
    if config.AutoBuso and _G.YOKUDO_ToggleAutoBuso then
        _G.YOKUDO_ToggleAutoBuso()
        print("✅ Auto Buso Loaded from Config")
    end
end)

print("🚀 YOKUDO HUB | SEA3 | [Premium] Ready!")
