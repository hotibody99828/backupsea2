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
-- LOAD CONFIG & APPLY (ក្រោយ UI, Tabs, Features Load រួច)
-- ==================================================
task.spawn(function()
    -- រង់ចាំ Features Load រួច
    while not featuresLoaded do
        task.wait(0.1)
    end
    
    -- រង់ចាំ UI និង Tabs ត្រៀមខ្លួន
    task.wait(0.5)
    
    print("📋 Auto Loading Config...")
    local config = _G.YOKUDO_GetConfig()
    
    if config then
        print("📋 Config Loaded:")
        print("   AutoEliteHunter: " .. tostring(config.AutoEliteHunter))
        print("   AutoBuso: " .. tostring(config.AutoBuso))
        
        -- ==================================================
        -- AUTO ELITE HUNTER
        -- ==================================================
        if config.AutoEliteHunter then
            print("▶️ Starting Auto Elite Hunter from Config...")
            if _G.YOKUDO_ToggleAutoEliteHunter then
                _G.YOKUDO_ToggleAutoEliteHunter()
                print("✅ Auto Elite Hunter Started")
            end
            -- Update Checkbox UI
            if _G.YOKUDO_UpdateEliteHunterCheckbox then
                _G.YOKUDO_UpdateEliteHunterCheckbox(true)
            end
        else
            if _G.YOKUDO_UpdateEliteHunterCheckbox then
                _G.YOKUDO_UpdateEliteHunterCheckbox(false)
            end
        end
        
        -- ==================================================
        -- AUTO BUSO
        -- ==================================================
        if config.AutoBuso then
            print("▶️ Starting Auto Buso from Config...")
            if _G.YOKUDO_ToggleAutoBuso then
                _G.YOKUDO_ToggleAutoBuso()
                print("✅ Auto Buso Started")
            end
            if _G.YOKUDO_UpdateBusoCheckbox then
                _G.YOKUDO_UpdateBusoCheckbox(true)
            end
        else
            if _G.YOKUDO_UpdateBusoCheckbox then
                _G.YOKUDO_UpdateBusoCheckbox(false)
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
