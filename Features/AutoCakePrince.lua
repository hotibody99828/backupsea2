-- ==================================================
-- AUTO CAKE PRINCE (FIXED - សាមញ្ញ)
-- ==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

-- ==================================================
-- POSITIONS
-- ==================================================
local POSITION_1 = Vector3.new(-12464, 376, -7562)
local POSITION_2 = Vector3.new(-4542, 708, -4214)
local POSITION_3 = Vector3.new(-2157, 160, -12400)

-- ==================================================
-- TWEEN SPEED
-- ==================================================
local TWEEN_SPEED = 200

-- ==================================================
-- STATE
-- ==================================================
local hasRespawned = false
local characterAddedConnection = nil
local hasBypassTeleported = false
local hasBypassTeleported2 = false

-- ==================================================
-- TOGGLE DEBOUNCE
-- ==================================================
local isToggling = false
local toggleLock = false
local isFeatureRunning = false

-- ==================================================
-- TWEEN TELEPORT VARIABLES
-- ==================================================
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
-- TWEEN TELEPORT FUNCTIONS
-- ==================================================

local function cleanupBody()
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
end

local function stopTweenTeleport()
    cleanupBody()
    if lockConnection then
        lockConnection:Disconnect()
        lockConnection = nil
    end
    isLocked = false
    currentBossPos = nil
    bossTarget = nil
    isTweeningToPosition = false
end

local function stopTweenToPosition()
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

local function tweenToPosition(targetPos, speed)
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
    isTweeningToPosition = true
    
    if lockConnection then
        lockConnection:Disconnect()
        lockConnection = nil
    end
    isLocked = false
    
    local distance = (targetPos - root.Position).Magnitude
    if distance < 3 then 
        isTweeningToPosition = false
        if bodyVelocity then
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        return true 
    end
    
    local duration = math.max(0.10, distance / speed)
    
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
    
    local tweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    
    currentTween = TweenService:Create(root, tweenInfo, {
        CFrame = CFrame.new(targetPos)
    })
    
    isTweening = true
    
    currentTween:Play()
    currentTween.Completed:Wait()
    
    if bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
    
    if not isTweening then
        isTweeningToPosition = false
        return false
    end
    
    isTweeningToPosition = false
    return true
end

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
    
    local targetPos = Vector3.new(bossPos.X, bossPos.Y + 30, bossPos.Z)
    local distance = (targetPos - root.Position).Magnitude
    if distance < 3 then 
        if bodyVelocity then
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        return true 
    end
    
    local duration = math.max(0.10, distance / speed)
    
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
    
    local tweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    
    currentTween = TweenService:Create(root, tweenInfo, {
        CFrame = CFrame.new(targetPos)
    })
    
    isTweening = true
    
    currentTween:Play()
    currentTween.Completed:Wait()
    
    if bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
    
    if not isTweening then
        return false
    end
    
    return true
end

-- ==================================================
-- RESPAWN FUNCTIONS
-- ==================================================

local function setSpawnPoint(location)
    local Event = ReplicatedStorage:FindFirstChild("Remotes")
    if Event then
        local CommF = Event:FindFirstChild("CommF_")
        if CommF then
            pcall(function()
                CommF:InvokeServer("SetLastSpawnPoint", location)
            end)
        end
    end
end

local function respawnPlayer()
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Health = 0
            task.wait(0.01)
            setSpawnPoint("Loaf")
            return true
        end
    end
    return false
end

-- ==================================================
-- FIND CAKE PRINCE BOSS
-- ==================================================
local function findCakePrince()
    -- ពិនិត្យ ReplicatedStorage (Boss មិនទាន់ Spawn)
    local stored = ReplicatedStorage:FindFirstChild("Cake Prince")
    if stored then
        return stored, "replicatedstorage"
    end
    
    -- ពិនិត្យ workspace (Boss បាន Spawn)
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        local boss = enemies:FindFirstChild("Cake Prince")
        if boss and boss:FindFirstChild("Humanoid") then
            local humanoid = boss.Humanoid
            if humanoid.Health > 0 then
                return boss, "workspace"
            else
                return nil, "dead"
            end
        end
    end
    
    return nil, nil
end

-- ==================================================
-- AUTO EQUIP WRAPPER
-- ==================================================
local function autoEquipWeapon()
    if _G.YOKUDO_EquipWeaponFromBackpack then
        local weaponType = "Melee"
        if _G.YOKUDO_AutoEquip then
            weaponType = _G.YOKUDO_AutoEquip.SelectedType
        end
        _G.YOKUDO_EquipWeaponFromBackpack(weaponType)
    end
end

-- ==================================================
-- AUTO ATTACK WRAPPER
-- ==================================================
local function attackTarget(target)
    if _G.YOKUDO_AttackTarget then
        _G.YOKUDO_AttackTarget(target)
    end
end

-- ==================================================
-- AUTO CAKE PRINCE LOOP
-- ==================================================
local function cakePrinceLoop()
    isFeatureRunning = true
    
    while _G.YOKUDO_AutoCakePrinceEnabled do
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
        
        -- ==================================================
        -- 1. FIND BOSS
        -- ==================================================
        local boss, location = findCakePrince()
        
        -- ==================================================
        -- 2. CHECK BOSS SPAWN (ReplicatedStorage)
        -- ==================================================
        local bossInStorage = ReplicatedStorage:FindFirstChild("Cake Prince")
        
        -- ប្រសិនបើ Boss មិនទាន់ Spawn → មិនធ្វើអ្វី
        if not bossInStorage then
            task.wait(0.01)
            continue
        end
        
        -- ==================================================
        -- 3. CALCULATE DISTANCE FROM BOSS
        -- ==================================================
        local distance = (POSITION_2 - root.Position).Magnitude
        
        -- ==================================================
        -- 4. BYPASS TO POSITION 1 IF DISTANCE > 2000m
        -- ==================================================
        if distance > 2000 and not hasBypassTeleported then
            bypassTeleport(POSITION_1)
            hasBypassTeleported = true
            task.wait(0.01)
            continue
        end
        
        -- ==================================================
        -- 5. TWEEN TO POSITION 2
        -- ==================================================
        if hasBypassTeleported and not hasBypassTeleported2 then
            local distToPos1 = (POSITION_1 - root.Position).Magnitude
            if distToPos1 < 5 then
                task.wait(1)
                tweenToPosition(POSITION_2, TWEEN_SPEED)
                hasBypassTeleported2 = true
                task.wait(0.01)
                continue
            end
        end
        
        -- ==================================================
        -- 6. RESPAWN AT POSITION 2
        -- ==================================================
        if hasBypassTeleported2 and not hasRespawned then
            local distToPos2 = (POSITION_2 - root.Position).Magnitude
            if distToPos2 < 5 then
                respawnPlayer()
                hasRespawned = true
                
                local function onCharacterAdded()
                    task.wait(0.5)
                    bypassTeleport(POSITION_3)
                    
                    if characterAddedConnection then
                        characterAddedConnection:Disconnect()
                        characterAddedConnection = nil
                    end
                end
                
                if characterAddedConnection then
                    characterAddedConnection:Disconnect()
                    characterAddedConnection = nil
                end
                characterAddedConnection = Player.CharacterAdded:Connect(onCharacterAdded)
                
                task.wait(0.01)
                continue
            end
        end
        
        -- ==================================================
        -- 7. ATTACK BOSS
        -- ==================================================
        if not boss then
            if location == "dead" then
                if not isBossDead then
                    isBossDead = true
                    cleanupBody()
                    if followConnection then
                        followConnection:Disconnect()
                        followConnection = nil
                    end
                    isFollowingBoss = false
                    isTweeningToPosition = false
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
        
        -- Auto Equip
        autoEquipWeapon()
        
        -- CASE: Boss in workspace (Near)
        if location == "workspace" then
            if isTweeningToPosition then
                stopTweenToPosition()
                isTweeningToPosition = false
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
                    if not _G.YOKUDO_AutoCakePrinceEnabled then
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
                        attackTarget(bossTarget)
                    end
                end)
                
                isLocked = true
            else
                attackTarget(boss)
            end
            
            task.wait(0.01)
            continue
        end
        
        task.wait(0.01)
    end
    
    isFeatureRunning = false
end

-- ==================================================
-- STATE
-- ==================================================
_G.YOKUDO_AutoCakePrinceEnabled = false
_G.YOKUDO_AutoCakePrinceLoop = nil

-- ==================================================
-- TOGGLE AUTO CAKE PRINCE
-- ==================================================
function _G.YOKUDO_ToggleAutoCakePrince()
    if toggleLock then
        return
    end
    
    if isToggling then
        return
    end
    
    isToggling = true
    toggleLock = true
    
    _G.YOKUDO_AutoCakePrinceEnabled = not _G.YOKUDO_AutoCakePrinceEnabled
    
    if _G.YOKUDO_AutoCakePrinceEnabled then
        if isFeatureRunning then
            isToggling = false
            toggleLock = false
            return
        end
        
        hasRespawned = false
        hasBypassTeleported = false
        hasBypassTeleported2 = false
        isBossDead = false
        bossFound = false
        isAtPosition = false
        isFollowingBoss = false
        isTweeningToPosition = false
        
        if characterAddedConnection then
            characterAddedConnection:Disconnect()
            characterAddedConnection = nil
        end
        
        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end
        
        if _G.YOKUDO_AutoCakePrinceLoop then
            _G.YOKUDO_AutoCakePrinceLoop:Disconnect()
            _G.YOKUDO_AutoCakePrinceLoop = nil
        end
        
        _G.YOKUDO_AutoCakePrinceLoop = task.spawn(cakePrinceLoop)
    else
        if _G.YOKUDO_AutoCakePrinceLoop then
            task.cancel(_G.YOKUDO_AutoCakePrinceLoop)
            _G.YOKUDO_AutoCakePrinceLoop = nil
        end
        
        if characterAddedConnection then
            characterAddedConnection:Disconnect()
            characterAddedConnection = nil
        end
        
        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end
        
        stopTweenTeleport()
        
        isBossDead = false
        bossFound = false
        isAtPosition = false
        isFollowingBoss = false
        isTweeningToPosition = false
        bossTarget = nil
        currentBossPos = nil
        isLocked = false
        isFeatureRunning = false
    end
    
    task.wait(0.3)
    isToggling = false
    toggleLock = false
end

-- ==================================================
-- CHARACTER RESPAWN HANDLER
-- ==================================================
Player.CharacterAdded:Connect(function()
    task.wait(0.5)
    hasBypassTeleported = false
    hasBypassTeleported2 = false
    
    if _G.YOKUDO_AutoCakePrinceEnabled then
        stopTweenTeleport()
    end
end)

print("✅ AutoCakePrince Loaded")
