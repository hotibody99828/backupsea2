-- ==================================================
-- AUTO RIP INDRA (ប្រើ Global Variable - FIXED)
-- ==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

-- ==================================================
-- GLOBAL VARIABLE សម្រាប់ isRunning
-- ==================================================
_G.RipIndraRunning = false

-- ==================================================
-- RIP INDRA POSITION
-- ==================================================
local RIP_INDRA_POSITION = Vector3.new(-12465, 376, -7563)

-- ==================================================
-- PORTAL REMOTE ARGS
-- ==================================================
local PORTAL_ARGS = {"requestEntrance", Vector3.new(-4936.41162109375, 314.50201416015625, -3103.224853515625)}

-- ==================================================
-- TWEEN SPEED
-- ==================================================
local TWEEN_SPEED = 200

-- ==================================================
-- STATE (Local Variables - មិនចាំបាច់ Global)
-- ==================================================
local loopConnection = nil
local noCollideConnection = nil
local noCollideActive = false
local hasUsedPortal = false
local currentTween = nil
local bodyVelocity = nil
local bodyGyro = nil
local isTweening = false
local lockConnection = nil
local isLocked = false
local currentBossPos = nil
local followConnection = nil
local bossTarget = nil
local isBossDead = false
local isTweeningToPosition = false
local bossFound = false
local isAtPosition = false
local isFollowingBoss = false

-- ==================================================
-- NO COLLIDE FUNCTIONS
-- ==================================================
local function applyNoCollide()
    local character = Player.Character
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function startNoCollide()
    if noCollideConnection then return end
    if noCollideActive then return end
    noCollideActive = true
    applyNoCollide()
    noCollideConnection = RunService.Heartbeat:Connect(function()
        if not noCollideActive then return end
        applyNoCollide()
    end)
end

local function stopNoCollide()
    noCollideActive = false
    if noCollideConnection then
        noCollideConnection:Disconnect()
        noCollideConnection = nil
    end
    local character = Player.Character
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- ==================================================
-- STOP TWEEN
-- ==================================================
function _G.YOKUDO_StopTweenTeleport()
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
    if lockConnection then
        lockConnection:Disconnect()
        lockConnection = nil
    end
    isTweening = false
    isLocked = false
    isTweeningToPosition = false
    isFollowingBoss = false
    stopNoCollide()
    print("🛑 Tween stopped for Rip Indra")
end

-- ==================================================
-- REMOTE PORTAL
-- ==================================================
local function usePortal()
    pcall(function()
        local Remote = ReplicatedStorage:FindFirstChild("Remotes")
        if Remote then
            local CommF = Remote:FindFirstChild("CommF_")
            if CommF then
                CommF:InvokeServer(unpack(PORTAL_ARGS))
                hasUsedPortal = true
            end
        end
    end)
end

-- ==================================================
-- BYPASS TELEPORT
-- ==================================================
local function bypassTeleport(targetPos)
    local character = Player.Character
    if not character then return false end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid and humanoid.Health <= 0 then return false end
    root.CFrame = CFrame.new(targetPos)
    return true
end

local function resetState()
    hasUsedPortal = false
end

-- ==================================================
-- TWEEN TO BOSS
-- ==================================================
local function tweenToBoss(bossPos, speed)
    local character = Player.Character
    if not character then return false end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid and humanoid.Health <= 0 then return false end
    
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
    isTweening = false
    isTweeningToPosition = false
    
    if lockConnection then
        lockConnection:Disconnect()
        lockConnection = nil
    end
    isLocked = false
    
    startNoCollide()
    
    local targetPos = Vector3.new(bossPos.X, bossPos.Y + 30, bossPos.Z)
    local distance = (targetPos - root.Position).Magnitude
    if distance < 3 then 
        if bodyVelocity then
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        stopNoCollide()
        return true 
    end
    
    local duration = math.max(0.5, distance / speed)
    local direction = (targetPos - root.Position).Unit
    
    if not bodyVelocity then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 10000
        bodyVelocity.Parent = root
    end
    bodyVelocity.Velocity = direction * speed
    
    if not bodyGyro then
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 10000
        bodyGyro.Parent = root
    end
    bodyGyro.CFrame = CFrame.lookAt(root.Position, targetPos)
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    currentTween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(targetPos)})
    isTweening = true
    currentTween:Play()
    currentTween.Completed:Wait()
    
    if bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
    
    if not isTweening then
        stopNoCollide()
        return false
    end
    
    stopNoCollide()
    return true
end

-- ==================================================
-- FIND RIP INDRA
-- ==================================================
local function findRipIndra()
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        local boss = enemies:FindFirstChild("rip_indra True Form")
        if boss and boss:FindFirstChild("Humanoid") then
            local humanoid = boss.Humanoid
            if humanoid.Health > 0 then
                return boss, "workspace"
            else
                return nil, "dead"
            end
        end
    end
    
    local stored = ReplicatedStorage:FindFirstChild("rip_indra True Form")
    if stored then
        return stored, "replicatedstorage"
    end
    
    return nil, nil
end

-- ==================================================
-- MAIN LOOP
-- ==================================================
local function ripIndraLoop()
    while _G.RipIndraRunning do
        local character = Player.Character
        if not character then
            task.wait(0.01)
            continue
        end
        
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then
            task.wait(0.01)
            continue
        end
        
        local boss, location = findRipIndra()
        
        if not boss then
            if location == "dead" then
                if not isBossDead then
                    isBossDead = true
                    if bodyVelocity then
                        bodyVelocity:Destroy()
                        bodyVelocity = nil
                    end
                    if bodyGyro then
                        bodyGyro:Destroy()
                        bodyGyro = nil
                    end
                    if currentTween then
                        currentTween:Cancel()
                        currentTween = nil
                    end
                    if followConnection then
                        followConnection:Disconnect()
                        followConnection = nil
                    end
                    isTweening = false
                    isLocked = false
                    isTweeningToPosition = false
                    isFollowingBoss = false
                    resetState()
                end
                task.wait(5)
                isBossDead = false
                continue
            end
            bossFound = false
            isAtPosition = false
            isFollowingBoss = false
            task.wait(0.01)
            continue
        end
        
        isBossDead = false
        
        -- Equip Weapon
        if _G.YOKUDO_EquipWeaponFromBackpack then
            local weaponType = "Melee"
            if _G.YOKUDO_AutoEquip then
                weaponType = _G.YOKUDO_AutoEquip.SelectedType
            end
            _G.YOKUDO_EquipWeaponFromBackpack(weaponType)
        end
        
        if location == "workspace" then
            if isTweeningToPosition then
                if currentTween then
                    currentTween:Cancel()
                    currentTween = nil
                end
                if followConnection then
                    followConnection:Disconnect()
                    followConnection = nil
                end
                isTweening = false
                isTweeningToPosition = false
                if bodyVelocity then
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
            end
            
            local bossRoot = boss:FindFirstChild("HumanoidRootPart") or boss:FindFirstChild("Torso")
            if not bossRoot then
                task.wait(0.01)
                continue
            end
            
            local bossPos = bossRoot.Position
            bossTarget = boss
            currentBossPos = bossPos
            bossFound = true
            isFollowingBoss = true
            
            local dist = (bossPos - root.Position).Magnitude
            
            if dist > 60 then
                tweenToBoss(bossPos, TWEEN_SPEED)
                
                if followConnection then
                    followConnection:Disconnect()
                    followConnection = nil
                end
                
                followConnection = RunService.Heartbeat:Connect(function()
                    if not _G.RipIndraRunning then
                        if followConnection then
                            followConnection:Disconnect()
                            followConnection = nil
                        end
                        return
                    end
                    
                    if not bossTarget or not bossTarget.Parent then
                        return
                    end
                    
                    local bossRoot = bossTarget:FindFirstChild("HumanoidRootPart") or bossTarget:FindFirstChild("Torso")
                    if not bossRoot then return end
                    
                    local currentBossPos = bossRoot.Position
                    local char = Player.Character
                    if not char then return end
                    
                    local rootPart = char:FindFirstChild("HumanoidRootPart")
                    if not rootPart then return end
                    
                    local lockPos = Vector3.new(currentBossPos.X, currentBossPos.Y + 30, currentBossPos.Z)
                    
                    local distToLock = (lockPos - rootPart.Position).Magnitude
                    if distToLock > 5 then
                        rootPart.CFrame = CFrame.new(lockPos)
                    end
                    
                    local distToBoss = (currentBossPos - rootPart.Position).Magnitude
                    if distToBoss <= 60 then
                        if _G.YOKUDO_AttackTarget then
                            _G.YOKUDO_AttackTarget(bossTarget)
                        end
                    end
                end)
                isLocked = true
            else
                if _G.YOKUDO_AttackTarget then
                    _G.YOKUDO_AttackTarget(boss)
                end
            end
            task.wait(0.01)
            continue
        end
        
        if location == "replicatedstorage" then
            bossFound = false
            isAtPosition = false
            isFollowingBoss = false
            
            if not hasUsedPortal then
                usePortal()
            end
            
            bypassTeleport(RIP_INDRA_POSITION)
            task.wait(0.10)
            
            local newBoss, newLocation = findRipIndra()
            
            if newLocation == "workspace" then
                local bossRoot = newBoss:FindFirstChild("HumanoidRootPart") or newBoss:FindFirstChild("Torso")
                if bossRoot then
                    local bossPos = bossRoot.Position
                    bossTarget = newBoss
                    currentBossPos = bossPos
                    bossFound = true
                    isFollowingBoss = true
                    
                    tweenToBoss(bossPos, TWEEN_SPEED)
                    
                    if followConnection then
                        followConnection:Disconnect()
                        followConnection = nil
                    end
                    
                    followConnection = RunService.Heartbeat:Connect(function()
                        if not _G.RipIndraRunning then
                            if followConnection then
                                followConnection:Disconnect()
                                followConnection = nil
                            end
                            return
                        end
                        
                        if not bossTarget or not bossTarget.Parent then
                            return
                        end
                        
                        local bossRoot = bossTarget:FindFirstChild("HumanoidRootPart") or bossTarget:FindFirstChild("Torso")
                        if not bossRoot then return end
                        
                        local currentBossPos = bossRoot.Position
                        local char = Player.Character
                        if not char then return end
                        
                        local rootPart = char:FindFirstChild("HumanoidRootPart")
                        if not rootPart then return end
                        
                        local lockPos = Vector3.new(currentBossPos.X, currentBossPos.Y + 30, currentBossPos.Z)
                        
                        local distToLock = (lockPos - rootPart.Position).Magnitude
                        if distToLock > 5 then
                            rootPart.CFrame = CFrame.new(lockPos)
                        end
                        
                        local distToBoss = (currentBossPos - rootPart.Position).Magnitude
                        if distToBoss <= 60 then
                            if _G.YOKUDO_AttackTarget then
                                _G.YOKUDO_AttackTarget(bossTarget)
                            end
                        end
                    end)
                    isLocked = true
                end
            end
            task.wait(0.01)
            continue
        end
    end
end

-- ==================================================
-- TOGGLE FUNCTION (FIXED - ប្រើ Global Variable)
-- ==================================================
function _G.YOKUDO_ToggleAutoRipIndra()
    -- ⭐ ប្រើ Global Variable
    _G.RipIndraRunning = not _G.RipIndraRunning
    _G.YOKUDO_AutoRipIndraEnabled = _G.RipIndraRunning
    
    if _G.RipIndraRunning then
        hasUsedPortal = false
        isBossDead = false
        bossFound = false
        isAtPosition = false
        isFollowingBoss = false
        isTweeningToPosition = false
        
        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end
        
        if loopConnection then
            loopConnection:Disconnect()
            loopConnection = nil
        end
        
        loopConnection = task.spawn(ripIndraLoop)
        print("⚡ Auto Rip Indra Started")
    else
        if loopConnection then
            task.cancel(loopConnection)
            loopConnection = nil
        end
        
        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end
        
        _G.YOKUDO_StopTweenTeleport()
        
        isBossDead = false
        bossFound = false
        isAtPosition = false
        isFollowingBoss = false
        isTweeningToPosition = false
        bossTarget = nil
        currentBossPos = nil
        isLocked = false
        print("⚡ Auto Rip Indra Stopped")
    end
    
    -- ⭐ UPDATE UI
    if _G.YOKUDO_UpdateUI_RipIndra then
        _G.YOKUDO_UpdateUI_RipIndra(_G.RipIndraRunning)
    end
    
    -- ⭐⭐⭐ SAVE CONFIG - ហៅគ្រប់ពេល!
    pcall(function()
        if _G.YOKUDO_UpdateConfig then
            _G.YOKUDO_UpdateConfig("AutoRipIndra", _G.RipIndraRunning)
            print("💾 Config Saved: AutoRipIndra = " .. tostring(_G.RipIndraRunning))
        else
            if _G.YOKUDO_Config then
                _G.YOKUDO_Config.AutoRipIndra = _G.RipIndraRunning
                if _G.YOKUDO_SaveConfig then
                    _G.YOKUDO_SaveConfig()
                    print("💾 Config Saved (Fallback): AutoRipIndra = " .. tostring(_G.RipIndraRunning))
                end
            end
        end
    end)
end

-- ==================================================
-- STATE
-- ==================================================
_G.YOKUDO_AutoRipIndraEnabled = false

-- ==================================================
-- CHARACTER RESPAWN
-- ==================================================
Player.CharacterAdded:Connect(function()
    task.wait(0.5)
    resetState()
    stopNoCollide()
    if _G.RipIndraRunning then
        _G.YOKUDO_StopTweenTeleport()
    end
end)

print("✅ AutoRipIndra Loaded (Config Ready - FIXED)")
