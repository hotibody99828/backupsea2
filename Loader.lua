-- ==================================================
-- YOKUDO HUB | SEA3 | [Premium] | Loader
-- ==================================================
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/hotibody99828/backupsea2/main/Loader.lua"))()
-- ==================================================

local BASE_URL = "https://raw.githubusercontent.com/hotibody99828/backupsea2/main/"

print("🔵 Loading YOKUDO HUB | SEA3 | [Premium]...")

-- ==================================================
-- WAIT UNTIL GAME IS LOADED
-- ==================================================
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

print("✅ Game loaded, Player: " .. Player.Name)

-- ==================================================
-- ⭐ CREATE LOADING SCREEN
-- ==================================================
local function CreateLoadingScreen()
    -- បង្កើត ScreenGui
    local LoadingGui = Instance.new("ScreenGui")
    LoadingGui.Name = "LoadingScreen"
    LoadingGui.ResetOnSpawn = false
    LoadingGui.IgnoreGuiInset = true
    LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    LoadingGui.DisplayOrder = 9999
    LoadingGui.Parent = CoreGui

    -- Background
    local Background = Instance.new("Frame")
    Background.Name = "Background"
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    Background.BackgroundTransparency = 0
    Background.BorderSizePixel = 0
    Background.Parent = LoadingGui

    -- Background Gradient
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 15)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 35))
    })
    Gradient.Parent = Background

    -- Main Container
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(0, 350, 0, 200)
    Container.Position = UDim2.new(0.5, -175, 0.5, -100)
    Container.BackgroundColor3 = Color3.fromRGB(20, 21, 30)
    Container.BackgroundTransparency = 0.1
    Container.BorderSizePixel = 0
    Container.ClipsDescendants = true
    Container.Parent = Background

    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 16)
    ContainerCorner.Parent = Container

    local ContainerBorder = Instance.new("UIStroke")
    ContainerBorder.Color = Color3.fromRGB(105, 90, 190)
    ContainerBorder.Thickness = 2
    ContainerBorder.Transparency = 0.3
    ContainerBorder.Parent = Container

    -- Logo/Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -40, 0, 40)
    Title.Position = UDim2.new(0, 20, 0, 20)
    Title.BackgroundTransparency = 1
    Title.Text = "YOKUDO HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 28
    Title.TextXAlignment = Enum.TextXAlignment.Center
    Title.TextYAlignment = Enum.TextYAlignment.Center
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Container

    -- Subtitle
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.Size = UDim2.new(1, -40, 0, 20)
    Subtitle.Position = UDim2.new(0, 20, 0, 62)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "SEA3 | [Premium]"
    Subtitle.TextColor3 = Color3.fromRGB(145, 145, 175)
    Subtitle.TextSize = 12
    Subtitle.TextXAlignment = Enum.TextXAlignment.Center
    Subtitle.TextYAlignment = Enum.TextYAlignment.Center
    Subtitle.Font = Enum.Font.GothamMedium
    Subtitle.Parent = Container

    -- Loading Bar Background
    local BarBg = Instance.new("Frame")
    BarBg.Name = "BarBg"
    BarBg.Size = UDim2.new(0.8, 0, 0, 6)
    BarBg.Position = UDim2.new(0.1, 0, 0.65, 0)
    BarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    BarBg.BorderSizePixel = 0
    BarBg.Parent = Container

    local BarBgCorner = Instance.new("UICorner")
    BarBgCorner.CornerRadius = UDim.new(1, 0)
    BarBgCorner.Parent = BarBg

    -- Loading Bar (Progress)
    local Bar = Instance.new("Frame")
    Bar.Name = "Bar"
    Bar.Size = UDim2.new(0, 0, 1, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(105, 90, 190)
    Bar.BorderSizePixel = 0
    Bar.Parent = BarBg

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = Bar

    -- Bar Glow
    local BarGlow = Instance.new("Frame")
    BarGlow.Name = "BarGlow"
    BarGlow.Size = UDim2.new(0.3, 0, 1, 0)
    BarGlow.Position = UDim2.new(0, 0, 0, 0)
    BarGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BarGlow.BackgroundTransparency = 0.3
    BarGlow.BorderSizePixel = 0
    BarGlow.Parent = Bar

    local BarGlowCorner = Instance.new("UICorner")
    BarGlowCorner.CornerRadius = UDim.new(1, 0)
    BarGlowCorner.Parent = BarGlow

    -- Status Text
    local Status = Instance.new("TextLabel")
    Status.Name = "Status"
    Status.Size = UDim2.new(1, -40, 0, 20)
    Status.Position = UDim2.new(0, 20, 0.8, 0)
    Status.BackgroundTransparency = 1
    Status.Text = "Initializing..."
    Status.TextColor3 = Color3.fromRGB(180, 180, 200)
    Status.TextSize = 11
    Status.TextXAlignment = Enum.TextXAlignment.Center
    Status.TextYAlignment = Enum.TextYAlignment.Center
    Status.Font = Enum.Font.GothamMedium
    Status.Parent = Container

    -- Progress Percent
    local Percent = Instance.new("TextLabel")
    Percent.Name = "Percent"
    Percent.Size = UDim2.new(1, -40, 0, 20)
    Percent.Position = UDim2.new(0, 20, 0.88, 0)
    Percent.BackgroundTransparency = 1
    Percent.Text = "0%"
    Percent.TextColor3 = Color3.fromRGB(105, 90, 190)
    Percent.TextSize = 14
    Percent.TextXAlignment = Enum.TextXAlignment.Center
    Percent.TextYAlignment = Enum.TextYAlignment.Center
    Percent.Font = Enum.Font.GothamBold
    Percent.Parent = Container

    -- ⭐ Animate Bar Function
    local function UpdateProgress(percent, statusText)
        percent = math.clamp(percent, 0, 100)
        Bar.Size = UDim2.new(percent / 100, 0, 1, 0)
        Percent.Text = math.floor(percent) .. "%"
        if statusText then
            Status.Text = statusText
        end
        task.wait()
    end

    return {
        Gui = LoadingGui,
        Container = Container,
        Bar = Bar,
        Status = Status,
        Percent = Percent,
        Update = UpdateProgress,
        Destroy = function()
            LoadingGui:Destroy()
        end
    }
end

-- ==================================================
-- ⭐ CREATE LOADING SCREEN
-- ==================================================
local Loading = CreateLoadingScreen()
Loading.Update(5, "Loading YOKUDO HUB...")

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
-- ⭐ LOAD CONFIG & CORE (10%)
-- ==================================================
Loading.Update(10, "Loading Core Systems...")

loadstring(game:HttpGet(BASE_URL .. "Config/Settings.lua"))()
Loading.Update(15, "Loading Services...")
loadstring(game:HttpGet(BASE_URL .. "Core/Services.lua"))()
Loading.Update(20, "Loading Player Manager...")
loadstring(game:HttpGet(BASE_URL .. "Core/Player.lua"))()
Loading.Update(25, "Loading Utilities...")
loadstring(game:HttpGet(BASE_URL .. "Core/Utils.lua"))()

-- ==================================================
-- ⭐ LOAD UI & TABS (30% - 50%)
-- ==================================================
task.spawn(function()
    Loading.Update(30, "Loading UI System...")
    loadstring(game:HttpGet(BASE_URL .. "UI/Toggle.lua"))()
    Loading.Update(38, "Loading Main UI...")
    loadstring(game:HttpGet(BASE_URL .. "UI/Main.lua"))()
    Loading.Update(45, "Loading UI Components...")
    loadstring(game:HttpGet(BASE_URL .. "UI/Components.lua"))()
    Loading.Update(50, "Loading Drag System...")
    loadstring(game:HttpGet(BASE_URL .. "UI/Drag.lua"))()
    Loading.Update(55, "Loading Tabs & Pages...")
    loadstring(game:HttpGet(BASE_URL .. "UI/Tabs.lua"))()
    print("✅ UI & Tabs Loaded")
end)

-- ==================================================
-- ⭐ LOAD FEATURES (60% - 85%)
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
    
    local totalFeatures = #Features
    local loaded = 0
    
    for _, Feature in ipairs(Features) do
        pcall(function()
            loadstring(game:HttpGet(BASE_URL .. "Features/" .. Feature .. ".lua"))()
        end)
        loaded = loaded + 1
        local percent = 60 + (loaded / totalFeatures * 25)
        Loading.Update(percent, "Loading " .. Feature .. "...")
    end
    
    print("✅ All Features Loaded")
    _G.YOKUDO_FeaturesReady = true
    Loading.Update(85, "Features Loaded!")
end)

-- ==================================================
-- ⭐ LOAD CONFIG MANAGER (90% - 100%)
-- ==================================================
task.spawn(function()
    Loading.Update(90, "Waiting for UI & Features...")
    
    while not _G.YOKUDO_FeaturesReady or not _G.YOKUDO_AutoHopPage do
        task.wait(0.1)
    end
    
    Loading.Update(93, "Loading Config Manager...")
    loadstring(game:HttpGet(BASE_URL .. "Config/ConfigManager.lua"))()
    
    while not _G.YOKUDO_ApplyConfig do
        task.wait(0.1)
    end
    
    Loading.Update(97, "Applying Config...")
    _G.YOKUDO_ApplyConfig()
    
    Loading.Update(100, "YOKUDO HUB Ready!")
    
    -- ⭐ បិទ Loading Screen ក្រោយផ្ទុករួច
    task.wait(0.5)
    Loading.Destroy()
    print("✅ Loading Screen Closed!")
    print("🚀 YOKUDO HUB | SEA3 | [Premium] Ready!")
end)

print("🚀 YOKUDO HUB | SEA3 | [Premium] Loading...")
