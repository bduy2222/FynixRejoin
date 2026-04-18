--====================================================
-- FYNIX ONLINE CHECK (NO CONFLICT MODE)
--====================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- PATH
local folderPath = "CheckOnlineFynix"
local filePath = folderPath .. "/" .. LocalPlayer.UserId .. "_online.txt"

pcall(function()
    if not isfolder(folderPath) then
        makefolder(folderPath)
    end
end)

-- BUILD DATA
local function buildData(status)
    return {
        placeId = game.PlaceId,
        timestamp = os.time(),
        status = status,
        jobId = game.JobId
    }
end

-- WRITE (KHÔNG SPAM)
local function writeState(status)
    pcall(function()
        writefile(filePath, HttpService:JSONEncode(buildData(status)))
    end)
end

-- ONLINE NGAY
if not game:IsLoaded() then
    game.Loaded:Wait()
end

writeState("Online")

-- UPDATE KHI RESPAWN (NHẸ)
LocalPlayer.CharacterAdded:Connect(function()
    task.delay(2, function()
        writeState("Online")
    end)
end)

-- EXIT
-- OFFLINE HANDLER (CLIENT ONLY FIX)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local called = false

local function setOfflineSafe()
    if called then return end
    called = true

    pcall(function()
        writeState("Offline")
    end)
end

-- trigger chính (ổn định nhất client có)
Players.PlayerRemoving:Connect(function(plr)
    if plr == LocalPlayer then
        setOfflineSafe()
    end
end)

-- NOTIFY NHẸ (KHÔNG TWEEN)
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Fynix",
        Text = "Loaded (Safe Mode)",
        Duration = 3
    })
end)