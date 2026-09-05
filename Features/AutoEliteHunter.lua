-- ==================================================
-- AUTO ELITE HUNTER (Portal + Tween)
-- ==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

-- ==================================================
-- ELITE BOSS CONFIG
-- ==================================================
local ELITE_BOSSES = {
    {Name = "Urban", Path = "Urban"},
    {Name = "Deandre", Path = "Deandre"},
    {Name = "Diablo", Path = "Diablo"},
}

-- ==================================================
-- MAP POSITIONS
-- ==================================================
local MAP_POSITIONS = {
    Port = Vector3.new(-531, 85, 6278),
    Waterfall = Vector3.new(4961, 1070, 102),
    GreatTree = Vector3.new(2546, 567, -8267),
    Turtle = Vector3.new(-12614, 427, -9520),
}

-- ==================================================
-- PORTAL POSITIONS (សម្រាប់ Bypass Teleport)
-- ==================================================
local PORTAL_POSITIONS = {
    Waterfall = Vector3.new(-5027, 316, -3202),
    Turtle = Vector3.new(-5061, 316, -3192),
    GreatTree = Vector3.new(-12468, 376, -7560),
    Port = Vector3.new(-12469, 376, -7560),
}

-- ==================================================
-- TWEEN SPEED
-- ==================================================
local TWEEN_SPEED = 200

-- ==================================================
-- STATE
-- ==================================================
local hasBypassTeleported = false
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
-- RESET BYPASS STATE
-- ==================================================
local function resetBypassState()
    hasBypassTeleported = false
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
-- FIND CLOSEST MAP
-- ==================================================
local function findClosestMap(bossPos)
    local closestMap = nil
    local closestDist = math.huge
    
    for mapName, mapPos in pairs(MAP_POSITIONS) do
        local dist = (bossPos - mapPos).Magnitude
        if dist < closestDist then
            closestDist = dist
            closestMap = mapName
        end
    end
    
    return closestMap
end

-- ==================================================
-- FIND ELITE BOSS
-- ==================================================
local function findEliteBoss()
    -- 1. ពិនិត្យ workspace.Enemies (Boss នៅជិត)
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        for _, boss in ipairs(ELITE_BOSSES) do
            local bossObj = enemies:FindFirstChild(boss.Path)
            if bossObj and bossObj:FindFirstChild("Humanoid") then
                local humanoid = bossObj.Humanoid
                if humanoid.Health > 0 then
                    return bossObj, "workspace", boss.Name
                end
            end
        end
    end
    
    -- 2. ពិនិត្យ ReplicatedStorage (Boss នៅឆ្ងាយ)
    for _, boss in ipairs(ELITE_BOSSES) do
        local stored = ReplicatedStorage:FindFirstChild(boss.Path)
        if stored then
            return stored, "replicatedstorage", boss.Name
        end
    end
    
    return nil, nil, nil
end

-- ==================================================
-- GET BOSS POSITION
-- ==================================================
local function getBossPosition(boss)
    if boss:IsA("Model") then
        local root = boss:FindFirstChild("HumanoidRootPart") or boss:FindFirstChild("Torso")
        if root then
            return root.Position
        end
    else
        -- ReplicatedStorage Boss
        local pos = boss:FindFirstChild("Position")
        if pos then
            return pos.Value
        end
        local cframe = boss:FindFirstChild("CFrame")
        if cframe then
            return cframe.Value.Position
        end
    end
    return nil
end

-- ==================================================
-- AUTO ELITE HUNTER LOOP
-- ==================================================
local function eliteHunterLoop()
    isFeatureRunning = true
    
    while _G.YOKUDO_AutoEliteHunterEnabled do
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
        
        local boss, location, bossName = findEliteBoss()
        
        if not boss then
            bossFound = false
            isAtPosition = false
            isFollowingBoss = false
            task.wait(0.01)
            continue
        end
        
        -- Auto Equip
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
                    if not _G.YOKUDO_AutoEliteHunterEnabled then
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
        -- CASE 2: Boss នៅឆ្ងាយ (ReplicatedStorage) → Portal + Tween
        -- ==================================================
        if location == "replicatedstorage" then
            bossFound = false
            isAtPosition = false
            isFollowingBoss = false
            
            -- យក Position របស់ Boss
            local bossPos = getBossPosition(boss)
            if not bossPos then
                task.wait(0.01)
                continue
            end
            
            -- គណនា Map ដែលនៅជិតជាងគេ
            local closestMap = findClosestMap(bossPos)
            if not closestMap then
                task.wait(0.01)
                continue
            end
            
            -- យក Portal Position នៃ Map នោះ
            local portalPos = PORTAL_POSITIONS[closestMap]
            if not portalPos then
                task.wait(0.01)
                continue
            end
            
            -- Bypass Teleport ទៅ Portal
            if not hasBypassTeleported then
                bypassTeleport(portalPos)
                print("⚡ Bypass Teleport to Portal: " .. closestMap)
            end
            
            -- រង់ចាំ 2s រួច Tween ទៅ Boss
            if hasBypassTeleported then
                task.wait(2)
                
                -- Tween ទៅ Boss
                tweenToBoss(bossPos, TWEEN_SPEED)
                
                if followConnection then
                    followConnection:Disconnect()
                    followConnection = nil
                end
                
                followConnection = RunService.Heartbeat:Connect(function()
                    if not _G.YOKUDO_AutoEliteHunterEnabled then
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
            
            task.wait(0.01)
            continue
        end
    end
    
    isFeatureRunning = false
end

-- ==================================================
-- STATE
-- ==================================================
_G.YOKUDO_AutoEliteHunterEnabled = false
_G.YOKUDO_AutoEliteHunterLoop = nil

-- ==================================================
-- TOGGLE AUTO ELITE HUNTER
-- ==================================================
function _G.YOKUDO_ToggleAutoEliteHunter()
    if toggleLock then
        return
    end
    
    if isToggling then
        return
    end
    
    isToggling = true
    toggleLock = true
    
    _G.YOKUDO_AutoEliteHunterEnabled = not _G.YOKUDO_AutoEliteHunterEnabled
    
    if _G.YOKUDO_AutoEliteHunterEnabled then
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
        
        if _G.YOKUDO_AutoEliteHunterLoop then
            _G.YOKUDO_AutoEliteHunterLoop:Disconnect()
            _G.YOKUDO_AutoEliteHunterLoop = nil
        end
        
        _G.YOKUDO_AutoEliteHunterLoop = task.spawn(eliteHunterLoop)
    else
        if _G.YOKUDO_AutoEliteHunterLoop then
            task.cancel(_G.YOKUDO_AutoEliteHunterLoop)
            _G.YOKUDO_AutoEliteHunterLoop = nil
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
    resetBypassState()
    
    if _G.YOKUDO_AutoEliteHunterEnabled then
        stopTweenTeleport()
    end
end)

print("✅ AutoEliteHunter Loaded")
