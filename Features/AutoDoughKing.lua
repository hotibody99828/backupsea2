-- ==================================================
-- AUTO DOUGH KING (Template)
-- ==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

_G.YOKUDO_AutoDoughKingEnabled = false
_G.YOKUDO_AutoDoughKingLoop = nil

local function doughKingLoop()
    while _G.YOKUDO_AutoDoughKingEnabled do
        -- TODO: បន្ថែមមុខងារ Auto Dough King
        print("🍩 Auto Dough King Running... (Features coming soon)")
        task.wait(1)
    end
end

function _G.YOKUDO_ToggleAutoDoughKing()
    _G.YOKUDO_AutoDoughKingEnabled = not _G.YOKUDO_AutoDoughKingEnabled
    
    if _G.YOKUDO_AutoDoughKingEnabled then
        if _G.YOKUDO_AutoDoughKingLoop then
            _G.YOKUDO_AutoDoughKingLoop:Disconnect()
            _G.YOKUDO_AutoDoughKingLoop = nil
        end
        _G.YOKUDO_AutoDoughKingLoop = task.spawn(doughKingLoop)
        print("✅ Auto Dough King Started")
    else
        if _G.YOKUDO_AutoDoughKingLoop then
            task.cancel(_G.YOKUDO_AutoDoughKingLoop)
            _G.YOKUDO_AutoDoughKingLoop = nil
        end
        print("❌ Auto Dough King Stopped")
    end
end

print("✅ AutoDoughKing Loaded")
