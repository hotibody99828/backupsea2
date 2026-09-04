-- ==================================================
-- AUTO SOUL REAPER (Template)
-- ==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

_G.YOKUDO_AutoSoulReaperEnabled = false
_G.YOKUDO_AutoSoulReaperLoop = nil

local function soulReaperLoop()
    while _G.YOKUDO_AutoSoulReaperEnabled do
        print("💀 Auto Soul Reaper Running... (Features coming soon)")
        task.wait(1)
    end
end

function _G.YOKUDO_ToggleAutoSoulReaper()
    _G.YOKUDO_AutoSoulReaperEnabled = not _G.YOKUDO_AutoSoulReaperEnabled
    
    if _G.YOKUDO_AutoSoulReaperEnabled then
        if _G.YOKUDO_AutoSoulReaperLoop then
            _G.YOKUDO_AutoSoulReaperLoop:Disconnect()
            _G.YOKUDO_AutoSoulReaperLoop = nil
        end
        _G.YOKUDO_AutoSoulReaperLoop = task.spawn(soulReaperLoop)
        print("✅ Auto Soul Reaper Started")
    else
        if _G.YOKUDO_AutoSoulReaperLoop then
            task.cancel(_G.YOKUDO_AutoSoulReaperLoop)
            _G.YOKUDO_AutoSoulReaperLoop = nil
        end
        print("❌ Auto Soul Reaper Stopped")
    end
end

print("✅ AutoSoulReaper Loaded")
