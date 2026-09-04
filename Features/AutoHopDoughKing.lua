-- ==================================================
-- AUTO HOP DOUGH KING (Template)
-- ==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

_G.YOKUDO_AutoHopDoughKingEnabled = false
_G.YOKUDO_AutoHopDoughKingLoop = nil

local function hopDoughKingLoop()
    while _G.YOKUDO_AutoHopDoughKingEnabled do
        -- TODO: បន្ថែមមុខងារ Auto Hop Dough King
        print("🍩 Auto Hop Dough King Running... (Features coming soon)")
        task.wait(1)
    end
end

function _G.YOKUDO_ToggleAutoHopDoughKing()
    _G.YOKUDO_AutoHopDoughKingEnabled = not _G.YOKUDO_AutoHopDoughKingEnabled
    
    if _G.YOKUDO_AutoHopDoughKingEnabled then
        if _G.YOKUDO_AutoHopDoughKingLoop then
            _G.YOKUDO_AutoHopDoughKingLoop:Disconnect()
            _G.YOKUDO_AutoHopDoughKingLoop = nil
        end
        _G.YOKUDO_AutoHopDoughKingLoop = task.spawn(hopDoughKingLoop)
        print("✅ Auto Hop Dough King Started")
    else
        if _G.YOKUDO_AutoHopDoughKingLoop then
            task.cancel(_G.YOKUDO_AutoHopDoughKingLoop)
            _G.YOKUDO_AutoHopDoughKingLoop = nil
        end
        print("❌ Auto Hop Dough King Stopped")
    end
end

print("✅ AutoHopDoughKing Loaded")
