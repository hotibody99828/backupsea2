-- ==================================================
-- AUTO BUSO HAKI (FULL - with Global State)
-- ==================================================

local Y = _G.Y
local Player = _G.YOKUDO.Player

-- ==================================================
-- STATE (GLOBAL - for Config)
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

function _G.YOKUDO_ToggleAutoBuso()
    _G.YOKUDO_BusoEnabled = not _G.YOKUDO_BusoEnabled
    
    if _G.YOKUDO_BusoEnabled then
        startAutoBuso()
        print("✅ Auto Buso Started")
    else
        stopAutoBuso()
        print("❌ Auto Buso Stopped")
    end
end

print("✅ AutoBuso Loaded")
