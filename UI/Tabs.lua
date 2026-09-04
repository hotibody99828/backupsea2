-- ==================================================
-- TABS (SEA3)
-- ==================================================

local Y = _G.Y
local Services = _G.YOKUDO.Services
local Settings = _G.YOKUDO

-- Create Pages
local InfoPage = CreatePage("INFO")
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
local AutoHopTab = CreateTab("Auto Hop", 2)
local NearMoonTab = CreateTab("Near Moon", 3)
local FullMoonTab = CreateTab("Full Moon", 4)
local DoughKingTab = CreateTab("Dough King", 5)
local RipIndraTab = CreateTab("Rip indra", 6)
local CakePrinceTab = CreateTab("Cake Prince", 7)
local CakeQueenTab = CreateTab("Cake Queen", 8)
local EliteHunterTab = CreateTab("Elite Hunter", 9)
local SoulReaperTab = CreateTab("Soul Reaper", 10)
local PirateRaidTab = CreateTab("Pirate Raid", 11)
local TyrantSkiesTab = CreateTab("tyrant of the skies", 12)
local MirageIslandTab = CreateTab("Mirage Island", 13)
local PrehistoricIslandTab = CreateTab("Prehistoric Island", 14)
local KitsuneIslandTab = CreateTab("Kitsune Island", 15)
local HakiLegendaryTab = CreateTab("Haki Legendary", 16)
local FruitTab = CreateTab("Fruit", 17)
local BerryTab = CreateTab("Berry", 18)
local SettingTab = CreateTab("Setting", 19)

-- Tab Map
local Tabs = {
    [InfoTab] = InfoPage,
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
-- INFO TAB (គ្មាន Refresh Button)
-- ==================================================
AddFeaturesSoon(InfoPage)

-- ==================================================
-- AUTO HOP TAB (គ្មាន Refresh Button)
-- ==================================================
CreateSectionTitle(AutoHopPage, "Select Weapon for attack", 1)
CreateWeaponDropdown(AutoHopPage, 2)

local clickAttackFrame, clickAttackCheckbox, getClickAttackState = CreateCheckbox(AutoHopPage, "Auto Click Attack", 3)

clickAttackCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoClickAttack then
        _G.YOKUDO_ToggleAutoClickAttack()
    end
end)

-- ==================================================
-- NEAR MOON TAB
-- ==================================================
AddFeaturesSoon(NearMoonPage)

-- ==================================================
-- FULL MOON TAB
-- ==================================================
AddFeaturesSoon(FullMoonPage)

-- ==================================================
-- DOUGH KING TAB
-- ==================================================
AddFeaturesSoon(DoughKingPage)

-- ==================================================
-- RIP INDRA TAB
-- ==================================================
AddFeaturesSoon(RipIndraPage)

-- ==================================================
-- CAKE PRINCE TAB
-- ==================================================
AddFeaturesSoon(CakePrincePage)

-- ==================================================
-- CAKE QUEEN TAB
-- ==================================================
AddFeaturesSoon(CakeQueenPage)

-- ==================================================
-- ELITE HUNTER TAB
-- ==================================================
AddFeaturesSoon(EliteHunterPage)

-- ==================================================
-- SOUL REAPER TAB
-- ==================================================
AddFeaturesSoon(SoulReaperPage)

-- ==================================================
-- PIRATE RAID TAB
-- ==================================================
AddFeaturesSoon(PirateRaidPage)

-- ==================================================
-- TYRANT OF THE SKIES TAB
-- ==================================================
AddFeaturesSoon(TyrantSkiesPage)

-- ==================================================
-- MIRAGE ISLAND TAB
-- ==================================================
AddFeaturesSoon(MirageIslandPage)

-- ==================================================
-- PREHISTORIC ISLAND TAB
-- ==================================================
AddFeaturesSoon(PrehistoricIslandPage)

-- ==================================================
-- KITSUNE ISLAND TAB
-- ==================================================
AddFeaturesSoon(KitsuneIslandPage)

-- ==================================================
-- HAKI LEGENDARY TAB
-- ==================================================
AddFeaturesSoon(HakiLegendaryPage)

-- ==================================================
-- FRUIT TAB
-- ==================================================
AddFeaturesSoon(FruitPage)

-- ==================================================
-- BERRY TAB
-- ==================================================
AddFeaturesSoon(BerryPage)

-- ==================================================
-- SETTING TAB (គ្មាន Refresh Button)
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
