-- ==================================================
-- AUTO RIP INDRA (Template)
-- ==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

_G.YOKUDO_AutoRipIndraEnabled = false
_G.YOKUDO_AutoRipIndraLoop = nil

local function ripIndraLoop()
    while _G.YOKUDO_AutoRipIndraEnabled do
        print("⚡ Auto Rip indra Running... (Features coming soon)")
        task.wait(1)
    end
end

function _G.YOKUDO_ToggleAutoRipIndra()
    _G.YOKUDO_AutoRipIndraEnabled = not _G.YOKUDO_AutoRipIndraEnabled
    
    if _G.YOKUDO_AutoRipIndraEnabled then
        if _G.YOKUDO_AutoRipIndraLoop then
            _G.YOKUDO_AutoRipIndraLoop:Disconnect()
            _G.YOKUDO_AutoRipIndraLoop = nil
        end
        _G.YOKUDO_AutoRipIndraLoop = task.spawn(ripIndraLoop)
        print("✅ Auto Rip indra Started")
    else
        if _G.YOKUDO_AutoRipIndraLoop then
            task.cancel(_G.YOKUDO_AutoRipIndraLoop)
            _G.YOKUDO_AutoRipIndraLoop = nil
        end
        print("❌ Auto Rip indra Stopped")
    end
end

print("✅ AutoRipIndra Loaded")
