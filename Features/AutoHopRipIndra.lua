-- ==================================================
-- AUTO HOP RIP INDRA (Template)
-- ==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

_G.YOKUDO_AutoHopRipIndraEnabled = false
_G.YOKUDO_AutoHopRipIndraLoop = nil

local function hopRipIndraLoop()
    while _G.YOKUDO_AutoHopRipIndraEnabled do
        print("⚡ Auto Hop Rip indra Running... (Features coming soon)")
        task.wait(1)
    end
end

function _G.YOKUDO_ToggleAutoHopRipIndra()
    _G.YOKUDO_AutoHopRipIndraEnabled = not _G.YOKUDO_AutoHopRipIndraEnabled
    
    if _G.YOKUDO_AutoHopRipIndraEnabled then
        if _G.YOKUDO_AutoHopRipIndraLoop then
            _G.YOKUDO_AutoHopRipIndraLoop:Disconnect()
            _G.YOKUDO_AutoHopRipIndraLoop = nil
        end
        _G.YOKUDO_AutoHopRipIndraLoop = task.spawn(hopRipIndraLoop)
        print("✅ Auto Hop Rip indra Started")
    else
        if _G.YOKUDO_AutoHopRipIndraLoop then
            task.cancel(_G.YOKUDO_AutoHopRipIndraLoop)
            _G.YOKUDO_AutoHopRipIndraLoop = nil
        end
        print("❌ Auto Hop Rip indra Stopped")
    end
end

print("✅ AutoHopRipIndra Loaded")
