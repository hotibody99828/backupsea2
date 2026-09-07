-- ==================================================
-- YOKUDO HUB | SEA3 | [Premium] | Loader
-- ==================================================
-- URL តែមួយគត់៖
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/your-username/YOKUDO-HUB-SEA3/main/Loader.lua"))()
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
-- ⭐ CREATE LOADING SCREEN
-- ==================================================
local function CreateLoadingScreen()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LoadingScreen"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(16, 17, 23)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 400, 0, 50)
    Title.Position = UDim2.new(0.5, -200, 0.4, -25)
    Title.BackgroundTransparency = 1
    Title.Text = "YOKUDO HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 36
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Center
    Title.Parent = MainFrame

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(0, 400, 0, 30)
    Subtitle.Position = UDim2.new(0.5, -200, 0.45, 0)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "SEA3 | [Premium]"
    Subtitle.TextColor3 = Color3.fromRGB(145, 145, 165)
    Subtitle.TextSize = 16
    Subtitle.Font = Enum.Font.GothamMedium
    Subtitle.TextXAlignment = Enum.TextXAlignment.Center
    Subtitle.Parent = MainFrame

    local BarBg = Instance.new("Frame")
    BarBg.Size = UDim2.new(0, 300, 0, 8)
    BarBg.Position = UDim2.new(0.5, -150, 0.55, 0)
    BarBg.BackgroundColor3 = Color3.fromRGB(30, 31, 42)
    BarBg.BorderSizePixel = 0
    BarBg.Parent = MainFrame

    local BarBgCorner = Instance.new("UICorner")
    BarBgCorner.CornerRadius = UDim.new(0, 4)
    BarBgCorner.Parent = BarBg

    local BarFill = Instance.new("Frame")
    BarFill.Name = "BarFill"
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = Color3.fromRGB(105, 90, 190)
    BarFill.BorderSizePixel = 0
    BarFill.Parent = BarBg

    local BarFillCorner = Instance.new("UICorner")
    BarFillCorner.CornerRadius = UDim.new(0, 4)
    BarFillCorner.Parent = BarFill

    local LoadingText = Instance.new("TextLabel")
    LoadingText.Name = "LoadingText"
    LoadingText.Size = UDim2.new(0, 300, 0, 20)
    LoadingText.Position = UDim2.new(0.5, -150, 0.58, 0)
    LoadingText.BackgroundTransparency = 1
    LoadingText.Text = "Loading..."
    LoadingText.TextColor3 = Color3.fromRGB(200, 200, 220)
    LoadingText.TextSize = 12
    LoadingText.Font = Enum.Font.GothamMedium
    LoadingText.TextXAlignment = Enum.TextXAlignment.Center
    LoadingText.Parent = MainFrame

    local StatusText = Instance.new("TextLabel")
    StatusText.Name = "StatusText"
    StatusText.Size = UDim2.new(0, 400, 0, 20)
    StatusText.Position = UDim2.new(0.5, -200, 0.62, 0)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "Initializing..."
    StatusText.TextColor3 = Color3.fromRGB(145, 145, 165)
    StatusText.TextSize = 11
    StatusText.Font = Enum.Font.GothamMedium
    StatusText.TextXAlignment = Enum.TextXAlignment.Center
    StatusText.Parent = MainFrame

    return ScreenGui, BarFill, LoadingText, StatusText
end

local LoadingScreen, BarFill, LoadingText, StatusText = CreateLoadingScreen()

-- ==================================================
-- ⭐ UPDATE LOADING PROGRESS
-- ==================================================
local function UpdateLoading(progress, text, status)
    BarFill.Size = UDim2.new(progress, 0, 1, 0)
    LoadingText.Text = text or "Loading..."
    StatusText.Text = status or "Initializing..."
end

UpdateLoading(0.05, "Loading...", "Starting up...")

-- ==================================================
-- AUTO JOIN MARINES (តែម្ដង)
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
UpdateLoading(0.10, "Loading Config & Core...", "Loading core modules...")

loadstring(game:HttpGet(BASE_URL .. "Config/Settings.lua"))()
loadstring(game:HttpGet(BASE_URL .. "Core/Services.lua"))()
loadstring(game:HttpGet(BASE_URL .. "Core/Player.lua"))()
loadstring(game:HttpGet(BASE_URL .. "Core/Utils.lua"))()

UpdateLoading(0.20, "Core loaded!", "Core modules ready")

-- ==================================================
-- ⭐ FLAG: ConfigManager Loaded
-- ==================================================
local configManagerLoaded = false

-- ==================================================
-- ⭐ LOAD CONFIG MANAGER EARLY
-- ==================================================
task.spawn(function()
    UpdateLoading(0.22, "Loading ConfigManager...", "Loading your settings...")
    
    loadstring(game:HttpGet(BASE_URL .. "Config/ConfigManager.lua"))()
    
    while not _G.YOKUDO_ApplyConfig do
        task.wait(0.1)
    end
    
    configManagerLoaded = true
    print("✅ ConfigManager Loaded (Early)")
end)

-- ==================================================
-- LOAD UI & TABS
-- ==================================================
task.spawn(function()
    UpdateLoading(0.25, "Loading UI...", "Building interface...")
    
    loadstring(game:HttpGet(BASE_URL .. "UI/Toggle.lua"))()
    UpdateLoading(0.35, "Toggle loaded...", "Loading main UI...")
    
    loadstring(game:HttpGet(BASE_URL .. "UI/Main.lua"))()
    UpdateLoading(0.50, "Main UI loaded...", "Loading components...")
    
    loadstring(game:HttpGet(BASE_URL .. "UI/Components.lua"))()
    UpdateLoading(0.60, "Components loaded...", "Loading drag system...")
    
    loadstring(game:HttpGet(BASE_URL .. "UI/Drag.lua"))()
    UpdateLoading(0.70, "Drag system loaded...", "Loading tabs...")
    
    loadstring(game:HttpGet(BASE_URL .. "UI/Tabs.lua"))()
    UpdateLoading(0.80, "Tabs loaded!", "UI ready!")
    
    print("✅ UI & Tabs Loaded")
end)

-- ==================================================
-- LOAD FEATURES & APPLY CONFIG ភ្លាមៗ
-- ==================================================
task.spawn(function()
    UpdateLoading(0.82, "Loading Features...", "Loading features...")
    
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
    
    local totalFeatures = #Features
    local loadedCount = 0
    
    for _, Feature in ipairs(Features) do
        pcall(function()
            loadstring(game:HttpGet(BASE_URL .. "Features/" .. Feature .. ".lua"))()
            loadedCount = loadedCount + 1
            local progress = 0.82 + (loadedCount / totalFeatures) * 0.13
            UpdateLoading(progress, "Loading " .. Feature .. "...", "Loaded " .. loadedCount .. "/" .. totalFeatures .. " features")
        end)
    end
    
    UpdateLoading(0.95, "All features loaded!", "Features ready!")
    print("✅ All Features Loaded")
    _G.YOKUDO_FeaturesReady = true
    
    -- ==============================================
    -- ⭐ APPLY CONFIG ភ្លាមៗ
    -- ==============================================
    UpdateLoading(0.96, "Applying Config...", "Applying your settings...")
    
    while not configManagerLoaded or not _G.YOKUDO_ApplyConfig do
        task.wait(0.1)
    end
    
    print("⏳ Applying config immediately...")
    _G.YOKUDO_ApplyConfig()
    
    UpdateLoading(0.98, "Config applied!", "Settings ready!")
    print("✅ Config applied successfully!")
    
    -- ==============================================
    -- ⭐ FINISH
    -- ==============================================
    UpdateLoading(1.0, "Ready!", "YOKUDO HUB SEA3 Ready!")
    
    task.wait(0.5)
    if LoadingScreen then
        LoadingScreen:Destroy()
        print("✅ Loading screen destroyed!")
    end
    
    local MainUI = game:GetService("CoreGui"):FindFirstChild("YOKUDO_HUB")
    if MainUI then
        MainUI.Enabled = true
        print("✅ Main UI shown!")
    end
    
    local ToggleGUI = game:GetService("CoreGui"):FindFirstChild("ToggleGUI")
    if ToggleGUI then
        ToggleGUI.Enabled = true
        print("✅ Toggle button shown!")
    end
end)

print("🚀 YOKUDO HUB | SEA3 | [Premium] Loading...")
