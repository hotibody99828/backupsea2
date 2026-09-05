-- ==================================================
-- AUTO SOUL REAPER (FINAL)
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
local SOUL_REAPER_BYPASS = Vector3.new(-12465, 376, -7563)   -- Bypass Teleport Position
local SOUL_REAPER_TWEEN = Vector3.new(-9524, 327, 6660)      -- Tween Teleport Position

-- ==================================================
-- TWEEN SPEED
-- ==================================================
local TWEEN_SPEED = 200
local DISTANCE_THRESHOLD = 3000

-- ==================================================
-- STATE
-- ==================================================
local hasBypassTeleported = false
local hasTweenedToPosition = false
local isInvoking = false
local invokeLoopConnection = nil
local spawnPointCheckConnection = nil
local isFeatureRunning = false
local isToggling = false
local toggleLock = false

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
-- GET SPAWN POINT
-- ==================================================
local function getSpawnPoint()
    local success, result = pcall(function()
        local data = Player:FindFirstChild("Data")
        if data then
            local lastSpawnPoint = data:FindFirstChild("LastSpawnPoint")
            if lastSpawnPoint then
                return lastSpawnPoint.Value
            end
        end
        return ""
    end)
    
    if success then
        return result
    else
        return ""
    end
end

-- ==================================================
-- SET SPAWN POINT
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

-- ==================================================
-- GET DISTANCE TO TWEEN POSITION
-- ==================================================
local function getDistanceToTweenPosition()
    local character = Player.Character
    if not character then return 99999
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return 99999
    
    return (SOUL_REAPER_TWEEN - root.Position).Magnitude
end

-- ==================================================
-- INVOKE LOOP (រាល់ 0.05s)
-- ==================================================
local function startInvokeLoop()
    if isInvoking then return end
    isInvoking = true
    
    invokeLoopConnection = RunService.Heartbeat:Connect(function()
        if not _G.YOKUDO_AutoSoulReaperEnabled then
            stopInvokeLoop()
            return
        end
        
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            local boss = enemies:FindFirstChild("Soul Reaper")
            if boss and boss:FindFirstChild("Humanoid") then
                local humanoid = boss.Humanoid
                if humanoid.Health > 0 then
                    stopInvokeLoop()
                    return
                end
            end
        end
        
        setSpawnPoint("HauntedCastle")
    end)
end

local function stopInvokeLoop()
    isInvoking = false
    if invokeLoopConnection then
        invokeLoopConnection:Disconnect()
        invokeLoopConnection = nil
    end
end

-- ==================================================
-- CHECK SPAWN POINT
-- ==================================================
local function startSpawnPointCheck()
    if spawnPointCheckConnection then return end
    
    spawnPointCheckConnection = RunService.Heartbeat:Connect(function()
        if not _G.YOKUDO_AutoSoulReaperEnabled then
            stopSpawnPointCheck()
            return
        end
        
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            local boss = enemies:FindFirstChild("Soul Reaper")
            if boss and boss:FindFirstChild("Humanoid") then
                local humanoid = boss.Humanoid
                if humanoid.Health > 0 then
                    stopSpawnPointCheck()
                    return
                end
            end
        end
        
        local spawnPoint = getSpawnPoint()
        if spawnPoint == "HauntedCastle" then
            local character = Player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                    task.wait(0.01)
                    setSpawnPoint("HauntedCastle")
                    startInvokeLoop()
                end
            end
        end
    end)
end

local function stopSpawnPointCheck()
    if spawnPointCheckConnection then
        spawnPointCheckConnection:Disconnect()
        spawnPointCheckConnection = nil
    end
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
    hasBypassTeleported = true
    
    return true
end

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
-- FIND SOUL REAPER BOSS
-- ==================================================
local function findSoulReaper()
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        local boss = enemies:FindFirstChild("Soul Reaper")
        if boss and boss:FindFirstChild("Humanoid") then
            local humanoid = boss.Humanoid
            if humanoid.Health > 0 then
                return boss, "workspace"
            else
                return nil, "dead"
            end
        end
    end
    
    local stored = ReplicatedStorage:FindFirstChild("Soul Reaper")
    if stored then
        return stored, "replicatedstorage"
    end
    
    return nil, nil
end

-- ==================================================
-- AUTO SOUL REAPER LOOP
-- ==================================================
local function soulReaperLoop()
    isFeatureRunning = true
    
    while _G.YOKUDO_AutoSoulReaperEnabled do
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
        -- 1. CHECK ReplicatedStorage["Soul Reaper"]
        -- ==================================================
        local boss, location = findSoulReaper()
        
        if location == "replicatedstorage" then
            local distance = getDistanceToTweenPosition()
            
            if distance > DISTANCE_THRESHOLD then
                -- Bypass Teleport
                if not hasBypassTeleported then
                    bypassTeleport(SOUL_REAPER_BYPASS)
                    print("⚡ Bypass Teleport to Soul Reaper Position!")
                end
                
                -- រង់ចាំ 3s រួច Tween ទៅ TWEEN Position
                if hasBypassTeleported and not hasTweenedToPosition then
                    task.wait(3)
                    tweenToPosition(SOUL_REAPER_TWEEN, TWEEN_SPEED)
                    hasTweenedToPosition = true
                    print("🚀 Tween to Tween Position!")
                    
                    -- ចាប់ផ្ដើម Invoke + Spawn Point Check
                    startInvokeLoop()
                    startSpawnPointCheck()
                end
            else
                -- Tween Teleport ទៅ TWEEN Position ភ្លាមៗ
                if not hasTweenedToPosition then
                    tweenToPosition(SOUL_REAPER_TWEEN, TWEEN_SPEED)
                    hasTweenedToPosition = true
                    print("🚀 Tween to Tween Position!")
                    
                    startInvokeLoop()
                    startSpawnPointCheck()
                end
            end
            
            task.wait(0.01)
            continue
        end
        
        -- ==================================================
        -- 2. CHECK workspace.Enemies["Soul Reaper"]
        -- ==================================================
        if location == "workspace" then
            -- ឈប់ Invoke + Spawn Point Check
            stopInvokeLoop()
            stopSpawnPointCheck()
            
            if isTweeningToPosition then
                stopTweenToPosition()
                isTweeningToPosition = false
            end
            
            if _G.YOKUDO_EquipWeaponFromBackpack then
                local weaponType = "Melee"
                if _G.YOKUDO_AutoEquip then
                    weaponType = _G.YOKUDO_AutoEquip.SelectedType
                end
                _G.YOKUDO_EquipWeaponFromBackpack(weaponType)
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
                    if not _G.YOKUDO_AutoSoulReaperEnabled then
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
        
        -- ==================================================
        -- 3. Boss Dead
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
    end
    
    isFeatureRunning = false
end

-- ==================================================
-- CHARACTER RESPAWN HANDLER
-- ==================================================
Player.CharacterAdded:Connect(function()
    task.wait(0.5)
    
    hasBypassTeleported = false
    hasTweenedToPosition = false
    
    if _G.YOKUDO_AutoSoulReaperEnabled then
        -- Tween ទៅ TWEEN Position ភ្លាមៗ
        tweenToPosition(SOUL_REAPER_TWEEN, TWEEN_SPEED)
        hasTweenedToPosition = true
        
        startInvokeLoop()
        startSpawnPointCheck()
        
        stopTweenTeleport()
    end
end)

-- ==================================================
-- STATE
-- ==================================================
_G.YOKUDO_AutoSoulReaperEnabled = false
_G.YOKUDO_AutoSoulReaperLoop = nil

-- ==================================================
-- TOGGLE AUTO SOUL REAPER
-- ==================================================
function _G.YOKUDO_ToggleAutoSoulReaper()
    if toggleLock then
        return
    end
    
    if isToggling then
        return
    end
    
    isToggling = true
    toggleLock = true
    
    _G.YOKUDO_AutoSoulReaperEnabled = not _G.YOKUDO_AutoSoulReaperEnabled
    
    if _G.YOKUDO_AutoSoulReaperEnabled then
        if isFeatureRunning then
            isToggling = false
            toggleLock = false
            return
        end
        
        hasBypassTeleported = false
        hasTweenedToPosition = false
        isBossDead = false
        bossFound = false
        isAtPosition = false
        isFollowingBoss = false
        isTweeningToPosition = false
        
        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end
        
        if _G.YOKUDO_AutoSoulReaperLoop then
            _G.YOKUDO_AutoSoulReaperLoop:Disconnect()
            _G.YOKUDO_AutoSoulReaperLoop = nil
        end
        
        _G.YOKUDO_AutoSoulReaperLoop = task.spawn(soulReaperLoop)
    else
        if _G.YOKUDO_AutoSoulReaperLoop then
            task.cancel(_G.YOKUDO_AutoSoulReaperLoop)
            _G.YOKUDO_AutoSoulReaperLoop = nil
        end
        
        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end
        
        stopTweenTeleport()
        stopInvokeLoop()
        stopSpawnPointCheck()
        
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

print("✅ AutoSoulReaper Loaded (Final)")
