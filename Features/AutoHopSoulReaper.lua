-- ==================================================
-- AUTO HOP SOUL REAPER (Template)
-- ==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

_G.YOKUDO_AutoHopSoulReaperEnabled = false
_G.YOKUDO_AutoHopSoulReaperLoop = nil

local function hopSoulReaperLoop()
    while _G.YOKUDO_AutoHopSoulReaperEnabled do
        print("💀 Auto Hop Soul Reaper Running... (Features coming soon)")
        task.wait(1)
    end
end

function _G.YOKUDO_ToggleAutoHopSoulReaper()
    _G.YOKUDO_AutoHopSoulReaperEnabled = not _G.YOKUDO_AutoHopSoulReaperEnabled
    
    if _G.YOKUDO_AutoHopSoulReaperEnabled then
        if _G.YOKUDO_AutoHopSoulReaperLoop then
            _G.YOKUDO_AutoHopSoulReaperLoop:Disconnect()
            _G.YOKUDO_AutoHopSoulReaperLoop = nil
        end
        _G.YOKUDO_AutoHopSoulReaperLoop = task.spawn(hopSoulReaperLoop)
        print("✅ Auto Hop Soul Reaper Started")
    else
        if _G.YOKUDO_AutoHopSoulReaperLoop then
            task.cancel(_G.YOKUDO_AutoHopSoulReaperLoop)
            _G.YOKUDO_AutoHopSoulReaperLoop = nil
        end
        print("❌ Auto Hop Soul Reaper Stopped")
    end
end

print("✅ AutoHopSoulReaper Loaded")
