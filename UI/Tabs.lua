-- ==================================================
-- TABS (SEA3)
-- ==================================================

local Y = _G.Y
local Services = _G.YOKUDO.Services
local Settings = _G.YOKUDO

-- Create Pages
local InfoPage = CreatePage("INFO")
local ShopPage = CreatePage("SHOP")
local AutoHopPage = CreatePage("AUTO_HOP")
local NearMoonPage = CreatePage("NEAR_MOON")
local FullMoonPage = CreatePage("FULL_MOON")
local DoughKingPage = CreatePage("DOUGH_KING")
local RipIndraPage = CreatePage("RIP_INDRA")
local CakePrincePage = CreatePage("CAKE_PRINCE")
local CakeQueenPage = CreatePage("CAKE_QUEEN")
local EliteHunterPage = CreatePage("ELITE_HUNTER")
local SoulReaperPage = CreatePage("SOUL_REAPER")
local PirateRaidPage = CreatePage("PIRATE_RAID")
local TyrantSkiesPage = CreatePage("TYRANT_SKIES")
local MirageIslandPage = CreatePage("MIRAGE_ISLAND")
local PrehistoricIslandPage = CreatePage("PREHISTORIC_ISLAND")
local KitsuneIslandPage = CreatePage("KITSUNE_ISLAND")
local HakiLegendaryPage = CreatePage("HAKI_LEGENDARY")
local FruitPage = CreatePage("FRUIT")
local BerryPage = CreatePage("BERRY")
local SettingPage = CreatePage("SETTING")

-- Create Tabs
local InfoTab = CreateTab("Info", 1)
local ShopTab = CreateTab("Shop", 2)
local AutoHopTab = CreateTab("Auto Hop", 3)
local NearMoonTab = CreateTab("Near Moon", 4)
local FullMoonTab = CreateTab("Full Moon", 5)
local DoughKingTab = CreateTab("Dough King", 6)
local RipIndraTab = CreateTab("Rip indra", 7)
local CakePrinceTab = CreateTab("Cake Prince", 8)
local CakeQueenTab = CreateTab("Cake Queen", 9)
local EliteHunterTab = CreateTab("Elite Hunter", 10)
local SoulReaperTab = CreateTab("Soul Reaper", 11)
local PirateRaidTab = CreateTab("Pirate Raid", 12)
local TyrantSkiesTab = CreateTab("tyrant of the skies", 13)
local MirageIslandTab = CreateTab("Mirage Island", 14)
local PrehistoricIslandTab = CreateTab("Prehistoric Island", 15)
local KitsuneIslandTab = CreateTab("Kitsune Island", 16)
local HakiLegendaryTab = CreateTab("Haki Legendary", 17)
local FruitTab = CreateTab("Fruit", 18)
local BerryTab = CreateTab("Berry", 19)
local SettingTab = CreateTab("Setting", 20)

-- Tab Map
local Tabs = {
    [InfoTab] = InfoPage,
    [ShopTab] = ShopPage,
    [AutoHopTab] = AutoHopPage,
    [NearMoonTab] = NearMoonPage,
    [FullMoonTab] = FullMoonPage,
    [DoughKingTab] = DoughKingPage,
    [RipIndraTab] = RipIndraPage,
    [CakePrinceTab] = CakePrincePage,
    [CakeQueenTab] = CakeQueenPage,
    [EliteHunterTab] = EliteHunterPage,
    [SoulReaperTab] = SoulReaperPage,
    [PirateRaidTab] = PirateRaidPage,
    [TyrantSkiesTab] = TyrantSkiesPage,
    [MirageIslandTab] = MirageIslandPage,
    [PrehistoricIslandTab] = PrehistoricIslandPage,
    [KitsuneIslandTab] = KitsuneIslandPage,
    [HakiLegendaryTab] = HakiLegendaryPage,
    [FruitTab] = FruitPage,
    [BerryTab] = BerryPage,
    [SettingTab] = SettingPage
}

local function SelectTab(SelectedTab, SelectedPage)
    for Tab, Page in pairs(Tabs) do
        Page.Visible = false
        local Indicator = Tab:FindFirstChild("Indicator")
        local TabText = Tab:FindFirstChild("TabText")
        Y.TS:Create(Tab, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        if Indicator then
            Y.TS:Create(Indicator, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        end
        if TabText then
            Y.TS:Create(TabText, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(155, 155, 175)}):Play()
        end
    end

    SelectedPage.Visible = true
    task.wait(0.05)
    pcall(function()
        SelectedPage.CanvasPosition = Vector2.new(0, 0)
    end)

    Y.TS:Create(SelectedTab, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
    local Indicator = SelectedTab:FindFirstChild("Indicator")
    local TabText = SelectedTab:FindFirstChild("TabText")
    if Indicator then
        Y.TS:Create(Indicator, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
    end
    if TabText then
        Y.TS:Create(TabText, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end
end

for Tab, Page in pairs(Tabs) do
    Tab.MouseButton1Click:Connect(function()
        SelectTab(Tab, Page)
    end)
end

SelectTab(InfoTab, InfoPage)

-- ==================================================
-- REFRESH BUTTONS
-- ==================================================
CreateRefreshButton(NearMoonPage, 1)
CreateRefreshButton(FullMoonPage, 1)
CreateRefreshButton(DoughKingPage, 1)
CreateRefreshButton(RipIndraPage, 1)
CreateRefreshButton(CakePrincePage, 1)
CreateRefreshButton(CakeQueenPage, 1)
CreateRefreshButton(EliteHunterPage, 1)
CreateRefreshButton(SoulReaperPage, 1)
CreateRefreshButton(PirateRaidPage, 1)
CreateRefreshButton(TyrantSkiesPage, 1)
CreateRefreshButton(MirageIslandPage, 1)
CreateRefreshButton(PrehistoricIslandPage, 1)
CreateRefreshButton(KitsuneIslandPage, 1)
CreateRefreshButton(HakiLegendaryPage, 1)
CreateRefreshButton(FruitPage, 1)
CreateRefreshButton(BerryPage, 1)

-- ==================================================
-- INFO TAB
-- ==================================================

-- ==================================================
-- SHOP TAB
-- ==================================================
CreateSectionTitle(ShopPage, "Shop", 1)

local unlockHakiFrame, unlockHakiCheckbox, getUnlockHakiState = CreateCheckbox(ShopPage, "Auto Unlock Haki Legendary", 2)

unlockHakiCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoUnlockHaki then
        _G.YOKUDO_ToggleAutoUnlockHaki()
    end
end)

CreateSectionTitle(ShopPage, "Join Server With Jobid", 3)

local jobIdHolder = Instance.new("Frame")
jobIdHolder.Name = "JobIdHolder"
jobIdHolder.Size = UDim2.new(1, 0, 0, 32)
jobIdHolder.BackgroundTransparency = 1
jobIdHolder.BorderSizePixel = 0
jobIdHolder.LayoutOrder = 4
jobIdHolder.ZIndex = 9
jobIdHolder.Parent = ShopPage

local jobIdLabel = Instance.new("TextLabel")
jobIdLabel.Name = "JobIdLabel"
jobIdLabel.Size = UDim2.new(0, 80, 1, 0)
jobIdLabel.Position = UDim2.new(0, 0, 0, 0)
jobIdLabel.BackgroundTransparency = 1
jobIdLabel.Text = "JobId:"
jobIdLabel.TextColor3 = Color3.fromRGB(205, 205, 220)
jobIdLabel.TextSize = 12
jobIdLabel.TextXAlignment = Enum.TextXAlignment.Left
jobIdLabel.TextYAlignment = Enum.TextYAlignment.Center
jobIdLabel.Font = Enum.Font.GothamMedium
jobIdLabel.ZIndex = 10
jobIdLabel.Parent = jobIdHolder

local jobIdTextBox = Instance.new("TextBox")
jobIdTextBox.Name = "JobIdTextBox"
jobIdTextBox.Size = UDim2.new(0, 200, 1, -6)
jobIdTextBox.Position = UDim2.new(0, 85, 0, 3)
jobIdTextBox.BackgroundColor3 = Color3.fromRGB(30, 31, 45)
jobIdTextBox.BorderSizePixel = 0
jobIdTextBox.Text = ""
jobIdTextBox.PlaceholderText = "Enter JobId here..."
jobIdTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
jobIdTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
jobIdTextBox.TextSize = 12
jobIdTextBox.TextXAlignment = Enum.TextXAlignment.Left
jobIdTextBox.TextYAlignment = Enum.TextYAlignment.Center
jobIdTextBox.Font = Enum.Font.GothamMedium
jobIdTextBox.ZIndex = 11
jobIdTextBox.Parent = jobIdHolder

local TBoxCorner = Instance.new("UICorner")
TBoxCorner.CornerRadius = UDim.new(0, 4)
TBoxCorner.Parent = jobIdTextBox

local TBoxStroke = Instance.new("UIStroke")
TBoxStroke.Color = Color3.fromRGB(200, 200, 220)
TBoxStroke.Thickness = 0.5
TBoxStroke.Transparency = 0.2
TBoxStroke.Parent = jobIdTextBox

local joinButton = Instance.new("TextButton")
joinButton.Name = "JoinButton"
joinButton.Size = UDim2.new(0, 80, 1, -6)
joinButton.Position = UDim2.new(1, -85, 0, 3)
joinButton.BackgroundColor3 = Color3.fromRGB(105, 90, 190)
joinButton.BorderSizePixel = 0
joinButton.Text = "Join"
joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
joinButton.TextSize = 12
joinButton.TextXAlignment = Enum.TextXAlignment.Center
joinButton.TextYAlignment = Enum.TextYAlignment.Center
joinButton.Font = Enum.Font.GothamBold
joinButton.ZIndex = 11
joinButton.Parent = jobIdHolder

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 4)
BtnCorner.Parent = joinButton

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Color = Color3.fromRGB(200, 200, 220)
BtnStroke.Thickness = 0.5
BtnStroke.Transparency = 0.2
BtnStroke.Parent = joinButton

joinButton.MouseEnter:Connect(function()
    joinButton.BackgroundColor3 = Color3.fromRGB(135, 120, 225)
end)

joinButton.MouseLeave:Connect(function()
    joinButton.BackgroundColor3 = Color3.fromRGB(105, 90, 190)
end)

joinButton.MouseButton1Click:Connect(function()
    local jobId = jobIdTextBox.Text
    if jobId and jobId ~= "" then
        if _G.YOKUDO_JoinServerByJobId then
            _G.YOKUDO_JoinServerByJobId(jobId)
        else
            warn("⚠️ _G.YOKUDO_JoinServerByJobId not found!")
        end
    else
        print("⚠️ Please enter a JobId!")
    end
end)

-- ==================================================
-- AUTO HOP TAB
-- ==================================================
CreateSectionTitle(AutoHopPage, "Select Weapon for attack", 1)
CreateWeaponDropdown(AutoHopPage, 2)

local clickAttackFrame, clickAttackCheckbox, getClickAttackState = CreateCheckbox(AutoHopPage, "Auto Click Attack", 3)

clickAttackCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoClickAttack then
        _G.YOKUDO_ToggleAutoClickAttack()
    end
end)

-- Farm Boss: Dough King
CreateSectionTitle(AutoHopPage, "Farm Boss", 4)

local doughKingFrame, doughKingCheckbox, getDoughKingState = CreateCheckbox(AutoHopPage, "Auto Dough King", 5)

local hopDoughKingFrame, hopDoughKingCheckbox, getHopDoughKingState = CreateCheckbox(AutoHopPage, "Auto Hop Dough King", 6)

-- Farm Boss: Rip Indra
CreateSectionTitle(AutoHopPage, "Farm Boss", 7)

local ripIndraFrame, ripIndraCheckbox, getRipIndraState = CreateCheckbox(AutoHopPage, "Auto Rip indra", 8)

local hopRipIndraFrame, hopRipIndraCheckbox, getHopRipIndraState = CreateCheckbox(AutoHopPage, "Auto Hop Rip indra", 9)

-- Farm Boss: Cake Prince
CreateSectionTitle(AutoHopPage, "Farm Boss", 10)

local cakePrinceFrame, cakePrinceCheckbox, getCakePrinceState = CreateCheckbox(AutoHopPage, "Auto Cake Prince", 11)

local hopCakePrinceFrame, hopCakePrinceCheckbox, getHopCakePrinceState = CreateCheckbox(AutoHopPage, "Auto Hop Cake Prince", 12)

-- Farm Boss: Soul Reaper
CreateSectionTitle(AutoHopPage, "Farm Boss", 13)

local soulReaperFrame, soulReaperCheckbox, getSoulReaperState = CreateCheckbox(AutoHopPage, "Auto Soul Reaper", 14)

local hopSoulReaperFrame, hopSoulReaperCheckbox, getHopSoulReaperState = CreateCheckbox(AutoHopPage, "Auto Hop Soul Reaper", 15)

-- Farm Boss: Elite Hunter
CreateSectionTitle(AutoHopPage, "Farm Boss", 16)

local eliteHunterFrame, eliteHunterCheckbox, getEliteHunterState = CreateCheckbox(AutoHopPage, "Auto Elite Hunter", 17)

local hopEliteHunterFrame, hopEliteHunterCheckbox, getHopEliteHunterState = CreateCheckbox(AutoHopPage, "Auto Hop Elite Hunter", 18)

-- ==================================================
-- AUTO HOP CHECKBOX EVENTS
-- ==================================================
clickAttackCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoClickAttack then
        _G.YOKUDO_ToggleAutoClickAttack()
    end
end)

doughKingCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoDoughKing then
        _G.YOKUDO_ToggleAutoDoughKing()
    end
end)

hopDoughKingCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoHopDoughKing then
        _G.YOKUDO_ToggleAutoHopDoughKing()
    end
end)

ripIndraCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoRipIndra then
        _G.YOKUDO_ToggleAutoRipIndra()
    end
end)

hopRipIndraCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoHopRipIndra then
        _G.YOKUDO_ToggleAutoHopRipIndra()
    end
end)

cakePrinceCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoCakePrince then
        _G.YOKUDO_ToggleAutoCakePrince()
    end
end)

hopCakePrinceCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoHopCakePrince then
        _G.YOKUDO_ToggleAutoHopCakePrince()
    end
end)

soulReaperCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoSoulReaper then
        _G.YOKUDO_ToggleAutoSoulReaper()
    end
end)

hopSoulReaperCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoHopSoulReaper then
        _G.YOKUDO_ToggleAutoHopSoulReaper()
    end
end)

eliteHunterCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoEliteHunter then
        _G.YOKUDO_ToggleAutoEliteHunter()
    end
end)

hopEliteHunterCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoHopEliteHunter then
        _G.YOKUDO_ToggleAutoHopEliteHunter()
    end
end)

-- ==================================================
-- SETTING TAB (UPDATED - WITH CONFIG BUTTONS)
-- ==================================================
CreateSectionTitle(SettingPage, "Tween Settings", 1)
CreateStopTweenButton(SettingPage, 2)

CreateSectionTitle(SettingPage, "Other", 3)
local noClipFrame, noClipCheckbox, getNoClipState = CreateCheckbox(SettingPage, "No Clip", 4)

CreateSectionTitle(SettingPage, "Auto Abilities", 5)
local busoFrame, busoCheckbox, getBusoState = CreateCheckbox(SettingPage, "Auto Buso", 6)
local obsFrame, obsCheckbox, getObsState = CreateCheckbox(SettingPage, "Auto Ken", 7)

CreateSectionTitle(SettingPage, "Movement Hacks", 8)
local jumpHolder, jumpCheckbox, getJumpState, jumpTextBox, getJumpValue = CreateTextBoxWithCheckbox(SettingPage, "Jump Hack", 9)
local speedHolder, speedCheckbox, getSpeedState, speedTextBox, getSpeedValue = CreateTextBoxWithCheckbox(SettingPage, "Speed Hack", 10)
local walkFrame, walkCheckbox, getWalkState = CreateCheckbox(SettingPage, "Walk on Water", 11)

-- ==================================================
-- CONFIG BUTTONS (NEW)
-- ==================================================
CreateSectionTitle(SettingPage, "Config", 12)

-- Save Config Button
local saveConfigButton = Instance.new("TextButton")
saveConfigButton.Name = "SaveConfigButton"
saveConfigButton.Size = UDim2.new(1, -10, 0, 30)
saveConfigButton.Position = UDim2.new(0, 5, 0, 0)
saveConfigButton.BackgroundColor3 = Color3.fromRGB(105, 90, 190)
saveConfigButton.BorderSizePixel = 0
saveConfigButton.Text = "Save Config"
saveConfigButton.TextColor3 = Color3.fromRGB(255, 255, 255)
saveConfigButton.TextSize = 12
saveConfigButton.Font = Enum.Font.GothamBold
saveConfigButton.Parent = SettingPage

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 4)
saveCorner.Parent = saveConfigButton

saveConfigButton.MouseEnter:Connect(function()
    saveConfigButton.BackgroundColor3 = Color3.fromRGB(135, 120, 225)
end)

saveConfigButton.MouseLeave:Connect(function()
    saveConfigButton.BackgroundColor3 = Color3.fromRGB(105, 90, 190)
end)

saveConfigButton.MouseButton1Click:Connect(function()
    local config = {
        -- Auto Hop
        AutoClickAttack = _G.YOKUDO_AutoClickAttackEnabled or false,
        
        -- Auto Dough King
        AutoDoughKing = _G.YOKUDO_AutoDoughKingEnabled or false,
        AutoHopDoughKing = _G.YOKUDO_AutoHopDoughKingEnabled or false,
        
        -- Auto Rip Indra
        AutoRipIndra = _G.YOKUDO_AutoRipIndraEnabled or false,
        AutoHopRipIndra = _G.YOKUDO_AutoHopRipIndraEnabled or false,
        
        -- Auto Cake Prince
        AutoCakePrince = _G.YOKUDO_AutoCakePrinceEnabled or false,
        AutoHopCakePrince = _G.YOKUDO_AutoHopCakePrinceEnabled or false,
        
        -- Auto Soul Reaper
        AutoSoulReaper = _G.YOKUDO_AutoSoulReaperEnabled or false,
        AutoHopSoulReaper = _G.YOKUDO_AutoHopSoulReaperEnabled or false,
        
        -- Auto Elite Hunter
        AutoEliteHunter = _G.YOKUDO_AutoEliteHunterEnabled or false,
        AutoHopEliteHunter = _G.YOKUDO_AutoHopEliteHunterEnabled or false,
        
        -- Shop
        AutoUnlockHaki = _G.YOKUDO_AutoUnlockHakiEnabled or false,
        
        -- Setting
        AutoBuso = _G.YOKUDO_BusoEnabled or false,
        AutoKen = _G.YOKUDO_ObservationEnabled or false,
        WalkOnWater = _G.YOKUDO_WalkEnabled or false,
        NoClip = false,
        
        -- Values
        SpeedHack = _G.YOKUDO_CurrentSpeed or 16,
        JumpHack = _G.YOKUDO_CurrentJump or 50,
        SelectedWeapon = _G.YOKUDO_AutoEquip and _G.YOKUDO_AutoEquip.SelectedType or "Melee",
    }
    
    for key, value in pairs(config) do
        _G.YOKUDO_UpdateConfig(key, value)
    end
    
    print("✅ Config Saved!")
end)

-- Reset Config Button
local resetConfigButton = Instance.new("TextButton")
resetConfigButton.Name = "ResetConfigButton"
resetConfigButton.Size = UDim2.new(1, -10, 0, 30)
resetConfigButton.Position = UDim2.new(0, 5, 0, 35)
resetConfigButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
resetConfigButton.BorderSizePixel = 0
resetConfigButton.Text = "Reset Config"
resetConfigButton.TextColor3 = Color3.fromRGB(255, 255, 255)
resetConfigButton.TextSize = 12
resetConfigButton.Font = Enum.Font.GothamBold
resetConfigButton.Parent = SettingPage

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 4)
resetCorner.Parent = resetConfigButton

resetConfigButton.MouseEnter:Connect(function()
    resetConfigButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
end)

resetConfigButton.MouseLeave:Connect(function()
    resetConfigButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)

resetConfigButton.MouseButton1Click:Connect(function()
    _G.YOKUDO_ResetConfig()
    print("🔄 Config Reset! Restart the script to apply default settings.")
end)

-- ==================================================
-- SETTING CHECKBOX EVENTS
-- ==================================================
busoCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoBuso then
        _G.YOKUDO_ToggleAutoBuso()
    end
end)

obsCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoKen then
        _G.YOKUDO_ToggleAutoKen()
    end
end)

walkCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleWalkOnWater then
        _G.YOKUDO_ToggleWalkOnWater()
    end
end)

noClipCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleNoClip then
        _G.YOKUDO_ToggleNoClip()
    end
end)

-- ==================================================
-- OTHER PAGES
-- ==================================================

_G.YOKUDO_AutoHopPage = AutoHopPage

print("✅ Tabs Loaded")
