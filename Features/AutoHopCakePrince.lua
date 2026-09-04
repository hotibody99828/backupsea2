-- ==================================================
-- AUTO HOP CAKE PRINCE (Template)
-- ==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

_G.YOKUDO_AutoHopCakePrinceEnabled = false
_G.YOKUDO_AutoHopCakePrinceLoop = nil

local function hopCakePrinceLoop()
    while _G.YOKUDO_AutoHopCakePrinceEnabled do
        print("🎂 Auto Hop Cake Prince Running... (Features coming soon)")
        task.wait(1)
    end
end

function _G.YOKUDO_ToggleAutoHopCakePrince()
    _G.YOKUDO_AutoHopCakePrinceEnabled = not _G.YOKUDO_AutoHopCakePrinceEnabled
    
    if _G.YOKUDO_AutoHopCakePrinceEnabled then
        if _G.YOKUDO_AutoHopCakePrinceLoop then
            _G.YOKUDO_AutoHopCakePrinceLoop:Disconnect()
            _G.YOKUDO_AutoHopCakePrinceLoop = nil
        end
        _G.YOKUDO_AutoHopCakePrinceLoop = task.spawn(hopCakePrinceLoop)
        print("✅ Auto Hop Cake Prince Started")
    else
        if _G.YOKUDO_AutoHopCakePrinceLoop then
            task.cancel(_G.YOKUDO_AutoHopCakePrinceLoop)
            _G.YOKUDO_AutoHopCakePrinceLoop = nil
        end
        print("❌ Auto Hop Cake Prince Stopped")
    end
end

print("✅ AutoHopCakePrince Loaded")
