-- ==================================================
-- AUTO CAKE PRINCE (FIXED)
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
local POSITION_2 = Vector3.new(-2157, 320, -12400)  -- Y 320

-- ==================================================
-- TWEEN SPEED
-- ==================================================
local TWEEN_SPEED = 200

-- ==================================================
-- STATE
-- ==================================================
local hasRespawned = false
local hasBypassTeleported = false
local isFeatureRunning = false
local isToggling = false
local toggleLock = false
local respawnDone = false
local isBossDead = false
local bossTarget = nil
local currentBossPos = nil
local followConnection = nil

-- ==================================================
-- TWEEN TELEPORT VARIABLES
-- ==================================================
local currentTween = nil
local bodyVelocity = nil
local bodyGyro = nil
local isTweening = false
local lockConnection = nil
local isLocked = false

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
    
    if lockConnection then
        lockConnection:Disconnect()
        lockConnection = nil
    end
    isLocked = false
    
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
-- CHECK LAST SPAWN POINT
-- ==================================================
local function checkLastSpawnPoint()
    local Data = Player:FindFirstChild("Data")
    if Data then
        local LastSpawnPoint = Data:FindFirstChild("LastSpawnPoint")
        if LastSpawnPoint then
            local value = LastSpawnPoint.Value
            if value == "Loaf" then
                return true
            end
        end
    end
    return false
end

-- ==================================================
-- RESPAWN FUNCTION
-- ==================================================
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
    
    local stored = ReplicatedStorage:FindFirstChild("Cake Prince")
    if stored then
        return stored, "replicatedstorage"
    end
    
    return nil, nil
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
        
        local boss, location = findCakePrince()
        
        -- ==================================================
        -- CASE 1: Boss នៅឆ្ងាយ (ReplicatedStorage)
        -- ==================================================
        if location == "replicatedstorage" then
            local distance = (POSITION_2 - root.Position).Magnitude
            
            if distance > 3000 and not hasBypassTeleported then
                -- Bypass Teleport ទៅ Position 1
                bypassTeleport(POSITION_1)
                
                -- wait 2s
                task.wait(2)
                
                -- Tween Teleport ទៅ Position 2 (Y 320)
                tweenToPosition(POSITION_2, TWEEN_SPEED)
                
                -- Start Invoke Loop (SetLastSpawnPoint "Loaf") រាល់ 0.05s
                task.spawn(function()
                    while _G.YOKUDO_AutoCakePrinceEnabled do
                        pcall(function()
                            local args = {
                                "SetLastSpawnPoint",
                                "Loaf"
                            }
                            local Event = ReplicatedStorage:FindFirstChild("Remotes")
                            if Event then
                                local CommF = Event:FindFirstChild("CommF_")
                                if CommF then
                                    CommF:InvokeServer(unpack(args))
                                end
                            end
                        end)
                        task.wait(0.05)
                    end
                end)
                
                -- ពិនិត្យ LastSpawnPoint
                task.spawn(function()
                    while _G.YOKUDO_AutoCakePrinceEnabled do
                        if checkLastSpawnPoint() and not respawnDone then
                            -- Respawn
                            respawnPlayer()
                            respawnDone = true
                            hasBypassTeleported = false
                            break
                        end
                        task.wait(0.05)
                    end
                end)
            end
            
            task.wait(0.01)
            continue
        end
        
        -- ==================================================
        -- CASE 2: Boss នៅជិត (workspace)
        -- ==================================================
        if location == "workspace" then
            -- Auto Equip
            if _G.YOKUDO_EquipWeaponFromBackpack then
                local weaponType = "Melee"
                if _G.YOKUDO_AutoEquip then
                    weaponType = _G.YOKUDO_AutoEquip.SelectedType
                end
                _G.YOKUDO_EquipWeaponFromBackpack(weaponType)
            end
            
            if isTweening then
                stopTweenToPosition()
            end
            
            local bossRoot = boss:FindFirstChild("HumanoidRootPart") or boss:FindFirstChild("Torso")
            if not bossRoot then
                task.wait(0.01)
                continue
            end
            
            local bossPos = bossRoot.Position
            bossTarget = boss
            currentBossPos = bossPos
            
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
        -- CASE 3: Boss Dead
        -- ==================================================
        if location == "dead" then
            if not isBossDead then
                isBossDead = true
                cleanupBody()
                if followConnection then
                    followConnection:Disconnect()
                    followConnection = nil
                end
                respawnDone = false
                hasBypassTeleported = false
            end
            task.wait(5)
            isBossDead = false
            continue
        end
        
        task.wait(0.01)
    end
    
    isFeatureRunning = false
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
-- CHARACTER RESPAWN HANDLER
-- ==================================================
Player.CharacterAdded:Connect(function()
    task.wait(0.5)
    
    if _G.YOKUDO_AutoCakePrinceEnabled then
        -- Bypass Teleport ទៅ Position 2
        bypassTeleport(POSITION_2)
        stopTweenTeleport()
    end
end)

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
        isBossDead = false
        respawnDone = false
        
        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end
        
        if _G.YOKUDO_AutoCakePrinceLoop then
            _G.YOKUDO_AutoCakePrinceLoop:Disconnect()
            _G.YOKUDO_AutoCakePrinceLoop = nil
        end
        
        _G.YOKUDO_AutoCakePrinceLoop = task.spawn(cakePrinceLoop)
        print("🎂 Auto Cake Prince Started")
    else
        if _G.YOKUDO_AutoCakePrinceLoop then
            task.cancel(_G.YOKUDO_AutoCakePrinceLoop)
            _G.YOKUDO_AutoCakePrinceLoop = nil
        end
        
        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end
        
        stopTweenTeleport()
        
        isBossDead = false
        isFeatureRunning = false
        respawnDone = false
        hasBypassTeleported = false
        
        print("🎂 Auto Cake Prince Stopped")
    end
    
    task.wait(0.3)
    isToggling = false
    toggleLock = false
end

print("✅ AutoCakePrince Loaded")
