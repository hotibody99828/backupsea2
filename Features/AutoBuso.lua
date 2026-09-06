-- ==================================================
-- AUTO BUSO HAKI (FIXED - Separate Start & Toggle)
-- ==================================================

local Y = _G.Y
local Player = _G.YOKUDO.Player

-- ==================================================
-- STATE (GLOBAL)
-- ==================================================
_G.YOKUDO_BusoEnabled = false
_G.YOKUDO_BusoLoopConnection = nil
_G.YOKUDO_BusoCharConnection = nil

local function IsBusoOn()
    local username = Player.Local.Name
    local character = Y.WS:FindFirstChild("Characters") and Y.WS.Characters:FindFirstChild(username)
    if character then
        return character:FindFirstChild("HasBuso") ~= nil
    end
    return false
end

local function TurnOnBuso()
    local Remote = Y.Replicated:FindFirstChild("Remotes")
    if Remote then
        local CommF = Remote:FindFirstChild("CommF_")
        if CommF then
            pcall(function()
                CommF:InvokeServer("Buso")
            end)
        end
    end
end

local function startAutoBuso()
    if _G.YOKUDO_BusoLoopConnection then return end
    TurnOnBuso()
    _G.YOKUDO_BusoLoopConnection = Y.RS.Stepped:Connect(function()
        if not _G.YOKUDO_BusoEnabled then return end
        if not IsBusoOn() then
            TurnOnBuso()
        end
    end)
    _G.YOKUDO_BusoCharConnection = Player.OnCharacterAdded(function()
        task.wait(0.5)
        if _G.YOKUDO_BusoEnabled then TurnOnBuso() end
    end)
end

local function stopAutoBuso()
    if _G.YOKUDO_BusoLoopConnection then 
        _G.YOKUDO_BusoLoopConnection:Disconnect() 
        _G.YOKUDO_BusoLoopConnection = nil 
    end
    if _G.YOKUDO_BusoCharConnection then 
        _G.YOKUDO_BusoCharConnection:Disconnect() 
        _G.YOKUDO_BusoCharConnection = nil 
    end
end

-- ==================================================
-- START FEATURE (ហៅពី Loader)
-- ==================================================
function _G.YOKUDO_StartAutoBuso()
    if _G.YOKUDO_BusoEnabled then return end
    
    _G.YOKUDO_BusoEnabled = true
    startAutoBuso()
    print("✅ Auto Buso Started (from Config)")
end

-- ==================================================
-- STOP FEATURE
-- ==================================================
function _G.YOKUDO_StopAutoBuso()
    if not _G.YOKUDO_BusoEnabled then return end
    
    _G.YOKUDO_BusoEnabled = false
    stopAutoBuso()
    print("❌ Auto Buso Stopped")
end

-- ==================================================
-- TOGGLE FUNCTION (សម្រាប់ UI Checkbox)
-- ==================================================
function _G.YOKUDO_ToggleAutoBuso()
    if _G.YOKUDO_BusoEnabled then
        _G.YOKUDO_StopAutoBuso()
    else
        _G.YOKUDO_StartAutoBuso()
    end
    
    -- Save Config
    task.spawn(function()
        task.wait(0.1)
        if _G.YOKUDO_SaveCurrentState then
            _G.YOKUDO_SaveCurrentState()
        end
    end)
end

-- ==================================================
-- UPDATE UI (ហៅពី Loader)
-- ==================================================
function _G.YOKUDO_UpdateBusoUI(enabled)
    if _G.YOKUDO_UpdateBusoCheckbox then
        _G.YOKUDO_UpdateBusoCheckbox(enabled)
    end
end

print("✅ AutoBuso Loaded")
