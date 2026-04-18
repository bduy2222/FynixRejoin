--====================================================
-- FIX CONFLICT VERSION
--====================================================

getgenv().delay = getgenv().delay or 12

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
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

-- DATA
local function buildData(status)
    return {
        placeId = game.PlaceId,
        timestamp = os.time(),
        status = status,
        jobId = game.JobId
    }
end

-- WRITE SAFE
local lastWrite = 0
local function writeState(status)
    if tick() - lastWrite < 3 then return end
    lastWrite = tick()

    pcall(function()
        writefile(filePath, HttpService:JSONEncode(buildData(status)))
    end)
end

-- STATE
local onlineActive = false
local shuttingDown = false
local rejoining = false

-- ONLINE
local function setOnline()
    if shuttingDown or onlineActive then return end
    onlineActive = true
    writeState("Online")
end

-- OFFLINE
local function setOffline()
    if shuttingDown then return end
    shuttingDown = true
    onlineActive = false
    writeState("Offline")
end

-- LOAD
task.spawn(function()
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    setOnline()
end)

-- HEARTBEAT LOOP (NHẸ)
task.spawn(function()
    while task.wait(getgenv().delay) do
        if onlineActive and not shuttingDown then
            writeState("Online")
        end
    end
end)

-- SAFE REJOIN (ÍT CAN THIỆP)
local lastRejoin = 0
local function safeRejoin(reason)
    if rejoining then return end
    if tick() - lastRejoin < 20 then return end

    rejoining = true
    lastRejoin = tick()

    task.delay(3, function()
        pcall(function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
    end)
end

-- CHỈ GIỮ TELEPORT FAIL (AN TOÀN)
pcall(function()
    LocalPlayer.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Failed then
            safeRejoin("Teleport failed")
        end
    end)
end)

-- EXIT
game:BindToClose(function()
    setOffline()
end)