-- ==================================================
-- JOIN SERVER BY JOBID (SEA3)
-- ==================================================

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- ==================================================
-- JOIN SERVER FUNCTION
-- ==================================================
function _G.YOKUDO_JoinServerByJobId(jobId)
    if not jobId or jobId == "" then
        print("⚠️ Invalid JobId!")
        return
    end
    
    print("🔵 Attempting to join server with JobId: " .. jobId)
    
    -- Teleport to server by JobId
    pcall(function()
        TeleportService:TeleportToPrivateServer(6290868407, jobId)
    end)
end

print("✅ JoinServer Loaded")
