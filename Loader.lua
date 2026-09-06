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
-- LOAD CONFIG & CORE
-- ==================================================
loadstring(game:HttpGet(BASE_URL .. "Config/Settings.lua"))()
loadstring(game:HttpGet(BASE_URL .. "Config/ConfigManager.lua"))()

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
local featuresLoaded = false

task.spawn(function()
    task.wait(0.5)
    
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
            print("✅ " .. Feature .. " Loaded")
        end)
    end
    
    featuresLoaded = true
    print("✅ All Features Loaded")
end)

-- ==================================================
-- LOAD CONFIG (កុំហៅ Toggle)
-- ==================================================
task.spawn(function()
    while not featuresLoaded do
        task.wait(0.1)
    end
    
    task.wait(1)
    
    print("📋 Auto Loading Config...")
    local config = _G.YOKUDO_GetConfig()
    
    if config then
        print("📋 Config Loaded:")
        print("   AutoEliteHunter: " .. tostring(config.AutoEliteHunter))
        print("   AutoBuso: " .. tostring(config.AutoBuso))
        
        -- Update State & UI for Elite Hunter
        if config.AutoEliteHunter then
            print("▶️ Auto Elite Hunter is ENABLED in config")
            _G.YOKUDO_AutoEliteHunterEnabled = true
            if _G.YOKUDO_UpdateEliteHunterUI then
                _G.YOKUDO_UpdateEliteHunterUI(true)
            end
            -- Start the feature without toggling
            if _G.YOKUDO_StartAutoEliteHunter then
                _G.YOKUDO_StartAutoEliteHunter()
            end
        else
            _G.YOKUDO_AutoEliteHunterEnabled = false
            if _G.YOKUDO_UpdateEliteHunterUI then
                _G.YOKUDO_UpdateEliteHunterUI(false)
            end
        end
        
        -- Update State & UI for Buso
        if config.AutoBuso then
            print("▶️ Auto Buso is ENABLED in config")
            _G.YOKUDO_BusoEnabled = true
            if _G.YOKUDO_UpdateBusoUI then
                _G.YOKUDO_UpdateBusoUI(true)
            end
            if _G.YOKUDO_StartAutoBuso then
                _G.YOKUDO_StartAutoBuso()
            end
        else
            _G.YOKUDO_BusoEnabled = false
            if _G.YOKUDO_UpdateBusoUI then
                _G.YOKUDO_UpdateBusoUI(false)
            end
        end
        
        if not config.AutoEliteHunter and not config.AutoBuso then
            print("ℹ️ No features enabled in config")
        end
    else
        print("⚠️ Failed to load config!")
    end
end)

print("🚀 YOKUDO HUB | SEA3 | [Premium] Ready!")
