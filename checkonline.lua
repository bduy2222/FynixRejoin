--====================================================
-- FYNIX ONLINE CHECK (NO CONFLICT + AUTO UPDATE)
--====================================================

getgenv().delay = getgenv().delay or 10

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

-- WRITE (ANTI SPAM NHẸ)
local lastWrite = 0
local function writeState(status)
    if tick() - lastWrite < 2 then return end
    lastWrite = tick()

    pcall(function()
        writefile(filePath, HttpService:JSONEncode(buildData(status)))
    end)
end

-- ONLINE NGAY
if not game:IsLoaded() then
    game.Loaded:Wait()
end

writeState("Online")

-- AUTO UPDATE (NHẸ - KHÔNG XUNG ĐỘT)
-- AUTO UPDATE (NO CONFLICT)

local running = true

local function scheduleUpdate()
    if not running then return end

    task.delay(getgenv().delay, function()
        if not running then return end

        writeState("Online")
        scheduleUpdate() -- gọi lại nhưng không loop cứng
    end)
end

-- start
scheduleUpdate()

-- RESPAWN UPDATE
LocalPlayer.CharacterAdded:Connect(function()
    task.delay(2, function()
        writeState("Online")
    end)
end)

-- OFFLINE HANDLER
local called = false

local function setOfflineSafe()
    if called then return end
    called = true

    pcall(function()
        writeState("Offline")
    end)
end

Players.PlayerRemoving:Connect(function(plr)
    if plr == LocalPlayer then
        setOfflineSafe()
    end
end)

-- NOTIFY
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Fynix",
        Text = "Auto Update Enabled",
        Duration = 3
    })
end)

--====================================================
-- END
--====================================================