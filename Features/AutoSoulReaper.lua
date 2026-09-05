-- ==================================================
-- AUTO SOUL REAPER (UPDATED - Check Distance 3000m)
-- ==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

-- ==================================================
-- SOUL REAPER POSITION
-- ==================================================
local SOUL_REAPER_POSITION = Vector3.new(-12465, 376, -7563)

-- ==================================================
-- TWEEN SPEED
-- ==================================================
local TWEEN_SPEED = 200

-- ==================================================
-- DISTANCE CHECK
-- ==================================================
local DISTANCE_THRESHOLD = 3000

-- ==================================================
-- STATE
-- ==================================================
local hasBypassTeleported = false
local isInvoking = false
local invokeLoopConnection = nil
local hasRespawned = false
local spawnPointCheckConnection = nil

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
-- CHECK DISTANCE
-- ==================================================
local function checkDistanceToBoss()
    local character = Player.Character
    if not character then
        return false
    end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then
        return false
    end
    
    local distance = (SOUL_REAPER_POSITION - root.Position).Magnitude
    return distance > DISTANCE_THRESHOLD
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
        
        -- ពិនិត្យថាឃើញ Boss ក្នុង workspace ឬអត់
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            local boss = enemies:FindFirstChild("Soul Reaper")
            if boss and boss:FindFirstChild("Humanoid") then
                local humanoid = boss.Humanoid
                if humanoid.Health > 0 then
                    -- ឃើញ Boss → ឈប់ Invoke
                    stopInvokeLoop()
                    return
                end
            end
        end
        
        -- Invoke SetLastSpawnPoint
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
-- CHECK SPAWN POINT (រាល់ 0.5s)
-- ==================================================
local function startSpawnPointCheck()
    if spawnPointCheckConnection then return end
    
    spawnPointCheckConnection = RunService.Heartbeat:Connect(function()
        if not _G.YOKUDO_AutoSoulReaperEnabled then
            stopSpawnPointCheck()
            return
        end
        
        -- ពិនិត្យថាឃើញ Boss ក្នុង workspace ឬអត់
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            local boss = enemies:FindFirstChild("Soul Reaper")
            if boss and boss:FindFirstChild("Humanoid") then
                local humanoid = boss.Humanoid
                if humanoid.Health > 0 then
                    -- ឃើញ Boss → ឈប់ Check
                    stopSpawnPointCheck()
                    return
                end
            end
        end
        
        local spawnPoint = getSpawnPoint()
        if spawnPoint == "HauntedCastle" then
            -- Respawn
            local character = Player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    -- Respawn មុន
                    humanoid.Health = 0
                    
                    -- wait 0.01s រួច Invoke
                    task.wait(0.01)
                    setSpawnPoint("HauntedCastle")
                    
                    -- ចាប់ផ្ដើម Invoke Loop ម្តងទៀត
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
-- BYPASS TELEPORT FUNCTION
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
        
        local boss, location = findSoulReaper()
        
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
        
        if _G.YOKUDO_EquipWeaponFromBackpack then
            local weaponType = "Melee"
            if _G.YOKUDO_AutoEquip then
                weaponType = _G.YOKUDO_AutoEquip.SelectedType
            end
            _G.YOKUDO_EquipWeaponFromBackpack(weaponType)
        end
        
        -- ==================================================
        -- CASE 1: Boss នៅជិត (workspace) → Tween ទៅ Boss
        -- ==================================================
        if location == "workspace" then
            -- ឈប់ Invoke និង Spawn Point Check
            stopInvokeLoop()
            stopSpawnPointCheck()
            
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
        -- CASE 2: Boss នៅឆ្ងាយ (ReplicatedStorage) → ពិនិត្យចម្ងាយ
        -- ==================================================
        if location == "replicatedstorage" then
            bossFound = false
            isAtPosition = false
            isFollowingBoss = false
            
            -- ==================================================
            -- CHECK DISTANCE
            -- ==================================================
            local isFar = checkDistanceToBoss()
            
            if isFar then
                -- ==================================================
                -- ចម្ងាយ > 3000m → Bypass Teleport
                -- ==================================================
                if not hasBypassTeleported then
                    bypassTeleport(SOUL_REAPER_POSITION)
                    
                    -- ចាប់ផ្ដើម Invoke Loop
                    startInvokeLoop()
                    
                    -- ចាប់ផ្ដើម Spawn Point Check
                    startSpawnPointCheck()
                end
            else
                -- ==================================================
                -- ចម្ងាយ <= 3000m → Tween Teleport ទៅ Boss ធម្មតា
                -- ==================================================
                -- ឈប់ Invoke និង Spawn Point Check
                stopInvokeLoop()
                stopSpawnPointCheck()
                
                -- ប្រសិនបើមាន Boss ក្នុង ReplicatedStorage ប៉ុន្តែនៅជិត
                -- យើងនឹង Tween ទៅទីតាំង Boss
                if isTweeningToPosition then
                    stopTweenToPosition()
                    isTweeningToPosition = false
                end
                
                -- Tween ទៅទីតាំង
                tweenToBoss(SOUL_REAPER_POSITION, TWEEN_SPEED)
            end
            
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
    
    -- Reset bypass state
    hasBypassTeleported = false
    
    if _G.YOKUDO_AutoSoulReaperEnabled then
        -- ពិនិត្យ workspace.Enemies["Soul Reaper"] ភ្លាមៗ
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            local boss = enemies:FindFirstChild("Soul Reaper")
            if boss and boss:FindFirstChild("Humanoid") then
                local humanoid = boss.Humanoid
                if humanoid.Health > 0 then
                    -- ឃើញ Boss → Tween ទៅ Attack ភ្លាមៗ
                    local bossRoot = boss:FindFirstChild("HumanoidRootPart") or boss:FindFirstChild("Torso")
                    if bossRoot then
                        local bossPos = bossRoot.Position
                        bossTarget = boss
                        currentBossPos = bossPos
                        bossFound = true
                        isFollowingBoss = true
                        
                        -- ឈប់ Invoke និង Spawn Point Check
                        stopInvokeLoop()
                        stopSpawnPointCheck()
                        
                        if isTweeningToPosition then
                            stopTweenToPosition()
                            isTweeningToPosition = false
                        end
                        
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
                    end
                end
            end
        end
        
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

print("✅ AutoSoulReaper Loaded (Distance Check 3000m)")
