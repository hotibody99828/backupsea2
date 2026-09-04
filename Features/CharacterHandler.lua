-- ==================================================
-- CHARACTER RESPAWN HANDLER (SEA3)
-- ==================================================

local Player = _G.YOKUDO.Player

Player.OnCharacterAdded(function()
    task.wait(0.5)
    
    -- Speed Hack
    if _G.YOKUDO_SpeedEnabled then
        if _G.YOKUDO_StartSpeedLoop then
            _G.YOKUDO_StartSpeedLoop()
        end
    end
    
    -- Jump Hack
    if _G.YOKUDO_JumpEnabled then
        if _G.YOKUDO_EnableJumpPower then
            _G.YOKUDO_EnableJumpPower()
        end
    end
    
    -- Auto Buso
    if _G.YOKUDO_BusoEnabled then
        if _G.YOKUDO_ToggleAutoBuso then
            _G.YOKUDO_BusoEnabled = false
            _G.YOKUDO_ToggleAutoBuso()
        end
    end
    
    -- Walk on Water
    if _G.YOKUDO_WalkEnabled then
        if _G.YOKUDO_ToggleWalkOnWater then
            _G.YOKUDO_WalkEnabled = false
            _G.YOKUDO_ToggleWalkOnWater()
        end
    end
end)

print("✅ CharacterHandler Loaded")
