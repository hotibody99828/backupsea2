-- ==================================================
-- AUTO CLICK ATTACK LOOP (SEA3)
-- ==================================================

local Y = _G.Y
local Player = _G.YOKUDO.Player
local Settings = _G.YOKUDO

_G.YOKUDO_AutoClickAttackEnabled = false
_G.YOKUDO_ClickAttackLoopConnection = nil

local function getNearestTarget(range)
    local character = Player.GetCharacter()
    if not character then return nil end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local targets = {}
    
    local enemies = Y.WS:FindFirstChild("Enemies")
    if enemies then
        for _, mob in ipairs(enemies:GetChildren()) do
            if mob:FindFirstChild("Humanoid") then
                local humanoid = mob.Humanoid
                if humanoid.Health > 0 then
                    local mobRoot = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                    if mobRoot then
                        local dist = (mobRoot.Position - root.Position).Magnitude
                        if dist <= range then
                            table.insert(targets, {Object = mob, Distance = dist})
                        end
                    end
                end
            end
        end
    end
    
    for _, plr in ipairs(Y.P:GetPlayers()) do
        if plr ~= Player.Local then
            local char = plr.Character
            if char and char:FindFirstChild("Humanoid") then
                local humanoid = char.Humanoid
                if humanoid.Health > 0 then
                    local charRoot = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
                    if charRoot then
                        local dist = (charRoot.Position - root.Position).Magnitude
                        if dist <= range then
                            table.insert(targets, {Object = char, Distance = dist})
                        end
                    end
                end
            end
        end
    end
    
    if #targets == 0 then return nil end
    
    table.sort(targets, function(a, b)
        return a.Distance < b.Distance
    end)
    
    return targets[1].Object
end

local function clickAttackLoop()
    while _G.YOKUDO_AutoClickAttackEnabled do
        local target = getNearestTarget(Settings.Defaults.AttackRange)
        if target and _G.YOKUDO_AttackTarget then
            _G.YOKUDO_AttackTarget(target)
        end
        task.wait(0.01)
    end
end

function _G.YOKUDO_ToggleAutoClickAttack()
    _G.YOKUDO_AutoClickAttackEnabled = not _G.YOKUDO_AutoClickAttackEnabled
    
    if _G.YOKUDO_AutoClickAttackEnabled then
        if _G.YOKUDO_ClickAttackLoopConnection then
            _G.YOKUDO_ClickAttackLoopConnection:Disconnect()
            _G.YOKUDO_ClickAttackLoopConnection = nil
        end
        _G.YOKUDO_ClickAttackLoopConnection = task.spawn(clickAttackLoop)
    else
        if _G.YOKUDO_ClickAttackLoopConnection then
            task.cancel(_G.YOKUDO_ClickAttackLoopConnection)
            _G.YOKUDO_ClickAttackLoopConnection = nil
        end
    end
end

print("✅ AutoClickAttack Loaded")
