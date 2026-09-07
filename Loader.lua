-- ==================================================
-- YOKUDO HUB | SEA3 | [Premium] | Loader (NO BACKGROUND)
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
local CoreGui = game:GetService("CoreGui")

print("✅ Game loaded, Player: " .. Player.Name)

-- ==================================================
-- ⭐ CREATE LOADING SCREEN (គ្មាន Background)
-- ==================================================
local function CreateLoadingScreen()
    local LoadingGui = Instance.new("ScreenGui")
    LoadingGui.Name = "LoadingScreen"
    LoadingGui.ResetOnSpawn = false
    LoadingGui.IgnoreGuiInset = true
    LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    LoadingGui.DisplayOrder = 9999
    LoadingGui.Parent = CoreGui

    -- ⭐ គ្មាន Background Frame ទាំងស្រុង

    -- Container (តែម្នាក់ឯង)
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(0, 350, 0, 160)
    Container.Position = UDim2.new(0.5, -175, 0.5, -80)
    Container.BackgroundColor3 = Color3.fromRGB(16, 17, 23)
    Container.BackgroundTransparency = 0.1
    Container.BorderSizePixel = 0
    Container.ClipsDescendants = true
    Container.Parent = LoadingGui

    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 16)
    ContainerCorner.Parent = Container

    local ContainerBorder = Instance.new("UIStroke")
    ContainerBorder.Color = Color3.fromRGB(105, 90, 190)
    ContainerBorder.Thickness = 2
    ContainerBorder.Transparency = 0.2
    ContainerBorder.Parent = Container

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -40, 0, 35)
    Title.Position = UDim2.new(0, 20, 0, 12)
    Title.BackgroundTransparency = 1
    Title.Text = "YOKUDO HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 26
    Title.TextXAlignment = Enum.TextXAlignment.Center
    Title.TextYAlignment = Enum.TextYAlignment.Center
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Container

    -- Subtitle
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.Size = UDim2.new(1, -40, 0, 18)
    Subtitle.Position = UDim2.new(0, 20, 0, 47)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "SEA3 | [Premium]"
    Subtitle.TextColor3 = Color3.fromRGB(145, 145, 175)
    Subtitle.TextSize = 11
    Subtitle.TextXAlignment = Enum.TextXAlignment.Center
    Subtitle.TextYAlignment = Enum.TextYAlignment.Center
    Subtitle.Font = Enum.Font.GothamMedium
    Subtitle.Parent = Container

    -- Loading Bar Background
    local BarBg = Instance.new("Frame")
    BarBg.Name = "BarBg"
    BarBg.Size = UDim2.new(0.8, 0, 0, 5)
    BarBg.Position = UDim2.new(0.1, 0, 0.55, 0)
    BarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    BarBg.BorderSizePixel = 0
    BarBg.Parent = Container

    local BarBgCorner = Instance.new("UICorner")
    BarBgCorner.CornerRadius = UDim.new(1, 0)
    BarBgCorner.Parent = BarBg

    -- Loading Bar
    local Bar = Instance.new("Frame")
    Bar.Name = "Bar"
    Bar.Size = UDim2.new(0, 0, 1, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(105, 90, 190)
    Bar.BorderSizePixel = 0
    Bar.Parent = BarBg

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = Bar

    -- Status Text
    local Status = Instance.new("TextLabel")
    Status.Name = "Status"
    Status.Size = UDim2.new(1, -40, 0, 18)
    Status.Position = UDim2.new(0, 20, 0.72, 0)
    Status.BackgroundTransparency = 1
    Status.Text = "Initializing..."
    Status.TextColor3 = Color3.fromRGB(180, 180, 200)
    Status.TextSize = 11
    Status.TextXAlignment = Enum.TextXAlignment.Center
    Status.TextYAlignment = Enum.TextYAlignment.Center
    Status.Font = Enum.Font.GothamMedium
    Status.Parent = Container

    -- Percent
    local Percent = Instance.new("TextLabel")
    Percent.Name = "Percent"
    Percent.Size = UDim2.new(1, -40, 0, 20)
    Percent.Position = UDim2.new(0, 20, 0.85, 0)
    Percent.BackgroundTransparency = 1
    Percent.Text = "0%"
    Percent.TextColor3 = Color3.fromRGB(105, 90, 190)
    Percent.TextSize = 16
    Percent.TextXAlignment = Enum.TextXAlignment.Center
    Percent.TextYAlignment = Enum.TextYAlignment.Center
    Percent.Font = Enum.Font.GothamBold
    Percent.Parent = Container

    local function UpdateProgress(percent, statusText)
        percent = math.clamp(percent, 0, 100)
        Bar.Size = UDim2.new(percent / 100, 0, 1, 0)
        Percent.Text = math.floor(percent) .. "%"
        if statusText then
            Status.Text = statusText
        end
    end

    return {
        Gui = LoadingGui,
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
-- LOAD CONFIG & CORE
-- ==================================================
Loading.Update(10, "Loading Core...")
loadstring(GetScript("Config/Settings.lua"))()
Loading.Update(18, "Loading Services...")
loadstring(GetScript("Core/Services.lua"))()
Loading.Update(25, "Loading Player...")
loadstring(GetScript("Core/Player.lua"))()
Loading.Update(32, "Loading Utils...")
loadstring(GetScript("Core/Utils.lua"))()

-- ==================================================
-- LOAD UI & TABS
-- ==================================================
task.spawn(function()
    Loading.Update(40, "Loading UI...")
    loadstring(GetScript("UI/Toggle.lua"))()
    loadstring(GetScript("UI/Main.lua"))()
    loadstring(GetScript("UI/Components.lua"))()
    loadstring(GetScript("UI/Drag.lua"))()
    loadstring(GetScript("UI/Tabs.lua"))()
    Loading.Update(55, "UI Ready!")
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
    
    local total = #Features
    local loaded = 0
    
    for _, Feature in ipairs(Features) do
        pcall(function()
            loadstring(GetScript("Features/" .. Feature .. ".lua"))()
        end)
        loaded = loaded + 1
        local percent = 60 + (loaded / total * 25)
        Loading.Update(percent, Feature)
    end
    
    print("✅ All Features Loaded")
    _G.YOKUDO_FeaturesReady = true
    Loading.Update(85, "Features Ready!")
end)

-- ==================================================
-- LOAD CONFIG MANAGER
-- ==================================================
task.spawn(function()
    Loading.Update(88, "Waiting...")
    
    while not _G.YOKUDO_FeaturesReady or not _G.YOKUDO_AutoHopPage do
        task.wait(0.05)
    end
    
    Loading.Update(92, "Loading Config...")
    loadstring(GetScript("Config/ConfigManager.lua"))()
    
    while not _G.YOKUDO_ApplyConfig do
        task.wait(0.05)
    end
    
    Loading.Update(97, "Applying Config...")
    _G.YOKUDO_ApplyConfig()
    
    Loading.Update(100, "Ready!")
    
    task.wait(0.3)
    Loading.Destroy()
    print("✅ Loading Screen Closed!")
    print("🚀 YOKUDO HUB | SEA3 | [Premium] Ready!")
end)

print("🚀 YOKUDO HUB | SEA3 | [Premium] Loading...")
