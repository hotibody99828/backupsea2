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
    
    -- ==============================================
    -- AUTO RIP INDRA (បន្តដំណើរការឡើងវិញ)
    -- ==============================================
    if _G.YOKUDO_AutoRipIndraEnabled then
        task.spawn(function()
            -- ពិនិត្យ workspace.Enemies["rip_indra True Form"] ភ្លាមៗ
            local enemies = workspace:FindFirstChild("Enemies")
            if enemies then
                local boss = enemies:FindFirstChild("rip_indra True Form")
                if boss and boss:FindFirstChild("Humanoid") then
                    local humanoid = boss.Humanoid
                    if humanoid.Health > 0 then
                        -- ឃើញ Boss ក្នុង workspace → Tween ទៅ Attack ភ្លាមៗ
                        local bossRoot = boss:FindFirstChild("HumanoidRootPart") or boss:FindFirstChild("Torso")
                        if bossRoot then
                            if _G.YOKUDO_TweenToBoss and _G.YOKUDO_AttackTarget then
                                _G.YOKUDO_TweenToBoss(bossRoot.Position, 200)
                                _G.YOKUDO_AttackTarget(boss)
                            end
                        end
                    end
                end
            end
        end)
    end
    
    -- ==============================================
    -- AUTO SOUL REAPER (បន្តដំណើរការឡើងវិញ)
    -- ==============================================
    if _G.YOKUDO_AutoSoulReaperEnabled then
        task.spawn(function()
            -- ពិនិត្យ workspace.Enemies["Soul Reaper"] ភ្លាមៗ
            local enemies = workspace:FindFirstChild("Enemies")
            if enemies then
                local boss = enemies:FindFirstChild("Soul Reaper")
                if boss and boss:FindFirstChild("Humanoid") then
                    local humanoid = boss.Humanoid
                    if humanoid.Health > 0 then
                        -- ឃើញ Boss ក្នុង workspace → Tween ទៅ Attack ភ្លាមៗ
                        local bossRoot = boss:FindFirstChild("HumanoidRootPart") or boss:FindFirstChild("Torso")
                        if bossRoot then
                            if _G.YOKUDO_TweenToBoss and _G.YOKUDO_AttackTarget then
                                _G.YOKUDO_TweenToBoss(bossRoot.Position, 190)
                                _G.YOKUDO_AttackTarget(boss)
                            end
                        end
                    end
                end
            end
        end)
    end
    
    -- ==============================================
    -- AUTO DOUGH KING (បន្តដំណើរការឡើងវិញ)
    -- ==============================================
    if _G.YOKUDO_AutoDoughKingEnabled then
        if _G.YOKUDO_ToggleAutoDoughKing then
            _G.YOKUDO_ToggleAutoDoughKing()
        end
    end
    
    -- ==============================================
    -- AUTO CAKE PRINCE (បន្តដំណើរការឡើងវិញ)
    -- ==============================================
    if _G.YOKUDO_AutoCakePrinceEnabled then
        if _G.YOKUDO_ToggleAutoCakePrince then
            _G.YOKUDO_ToggleAutoCakePrince()
        end
    end
    
    -- ==============================================
    -- AUTO ELITE HUNTER (បន្តដំណើរការឡើងវិញ)
    -- ==============================================
    if _G.YOKUDO_AutoEliteHunterEnabled then
        if _G.YOKUDO_ToggleAutoEliteHunter then
            _G.YOKUDO_ToggleAutoEliteHunter()
        end
    end
    
    -- ==============================================
    -- AUTO CLICK ATTACK (បន្តដំណើរការឡើងវិញ)
    -- ==============================================
    if _G.YOKUDO_AutoClickAttackEnabled then
        if _G.YOKUDO_ToggleAutoClickAttack then
            _G.YOKUDO_ToggleAutoClickAttack()
        end
    end
    
    -- ==============================================
    -- AUTO UNLOCK HAKI (បន្តដំណើរការឡើងវិញ)
    -- ==============================================
    if _G.YOKUDO_AutoUnlockHakiEnabled then
        if _G.YOKUDO_ToggleAutoUnlockHaki then
            _G.YOKUDO_ToggleAutoUnlockHaki()
        end
    end
end)

print("✅ CharacterHandler Loaded (Updated with all features)")
