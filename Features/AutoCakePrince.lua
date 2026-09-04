-- ==================================================
-- AUTO CAKE PRINCE (Template)
-- ==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

_G.YOKUDO_AutoCakePrinceEnabled = false
_G.YOKUDO_AutoCakePrinceLoop = nil

local function cakePrinceLoop()
    while _G.YOKUDO_AutoCakePrinceEnabled do
        print("🎂 Auto Cake Prince Running... (Features coming soon)")
        task.wait(1)
    end
end

function _G.YOKUDO_ToggleAutoCakePrince()
    _G.YOKUDO_AutoCakePrinceEnabled = not _G.YOKUDO_AutoCakePrinceEnabled
    
    if _G.YOKUDO_AutoCakePrinceEnabled then
        if _G.YOKUDO_AutoCakePrinceLoop then
            _G.YOKUDO_AutoCakePrinceLoop:Disconnect()
            _G.YOKUDO_AutoCakePrinceLoop = nil
        end
        _G.YOKUDO_AutoCakePrinceLoop = task.spawn(cakePrinceLoop)
        print("✅ Auto Cake Prince Started")
    else
        if _G.YOKUDO_AutoCakePrinceLoop then
            task.cancel(_G.YOKUDO_AutoCakePrinceLoop)
            _G.YOKUDO_AutoCakePrinceLoop = nil
        end
        print("❌ Auto Cake Prince Stopped")
    end
end

print("✅ AutoCakePrince Loaded")
