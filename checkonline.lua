--====================================================
--  FYNIX ONLINE CHECK SYSTEM (FINAL FIX)
--====================================================

-- CONFIG
getgenv().delay = getgenv().delay or 9

-- SERVICES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

--====================================================
-- PATH (FIX CHUẨN ANDROID)
--====================================================
local folderPath = "CheckOnlineFynix"
local filePath = folderPath .. "/" .. tostring(LocalPlayer.UserId) .. "_online.txt"

-- ENSURE FOLDER
pcall(function()
    if not isfolder(folderPath) then
        makefolder(folderPath)
    end
end)

--====================================================
-- NOTIFY
--====================================================
local function notify(title, text, duration)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game:GetService("CoreGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 60)
    frame.Position = UDim2.new(1, -260, 1, -80)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    frame.Parent = screenGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = title .. "\n" .. text
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.Parent = frame

    task.delay(duration or 3, function()
        screenGui:Destroy()
    end)
end

--====================================================
-- BUILD DATA
--====================================================
local function buildData(status)
    return {
        placeId = game.PlaceId,
        timestamp = os.time(),
        status = status,
        jobId = game.JobId
    }
end

--====================================================
-- WRITE FILE (ANTI FAIL)
--====================================================
local function writeState(status)
    local ok, err = pcall(function()
        local encoded = HttpService:JSONEncode(buildData(status))
        writefile(filePath, encoded)
    end)

    if not ok then
        warn("[FYNIX] Write failed:", err)
    end
end

--====================================================
-- STATE
--====================================================
local onlineActive = false
local shuttingDown = false

--====================================================
-- ONLINE (FIX NGAY LẬP TỨC)
--====================================================
local function setOnline()
    if shuttingDown then return end
    if onlineActive then return end

    onlineActive = true

    -- 🔥 GHI NGAY LẬP TỨC (QUAN TRỌNG NHẤT)
    writeState("Online")

    notify("Fynix", "ONLINE", 2)
end

--====================================================
-- OFFLINE
--====================================================
local function setOffline()
    if shuttingDown then return end

    shuttingDown = true
    onlineActive = false

    writeState("Offline")

    notify("Fynix", "OFFLINE", 2)
end

--====================================================
-- LOAD
--====================================================
task.spawn(function()

    if not game:IsLoaded() then
        game.Loaded:Wait()
    end

    -- 🔥 KHÔNG delay 2s nữa (fix lỗi chính)
    

end)
-- ONLINE NGAY KHI GAME LOAD (KH�NG CH CHARACTER)
task.spawn(function()

    if not game:IsLoaded() then
        game.Loaded:Wait()
    end

    --  SET ONLINE NGAY
    setOnline()

    --  OPTIONAL: m bo character vn sync
    task.spawn(function()
        if not LocalPlayer.Character then
            LocalPlayer.CharacterAdded:Wait()
        end
    end)

end)
--====================================================
-- HEARTBEAT (GIỮ ONLINE)
--====================================================
task.spawn(function()
    while true do
        task.wait(getgenv().delay)

        if onlineActive and not shuttingDown then
            writeState("Online")
        end
    end
end)

--====================================================
-- ANTI FREEZE + REJOIN
--====================================================
local lastHeartbeat = tick()
local isRejoining = false

local function safeRejoin(reason)
    if isRejoining then return end
    isRejoining = true

    warn("[FYNIX] Rejoin:", reason)

    task.wait(1)

    pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end

-- CHARACTER LOST
LocalPlayer.CharacterRemoving:Connect(function()
    task.wait(1)

    if not LocalPlayer.Character then
        safeRejoin("Character lost")
    end
end)

-- DISCONNECT
Players.PlayerRemoving:Connect(function(plr)
    if plr == LocalPlayer then
        safeRejoin("Disconnect")
    end
end)

-- TELEPORT FAIL
pcall(function()
    LocalPlayer.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Failed then
            safeRejoin("Teleport failed")
        end
    end)
end)

-- ERROR PROMPT
pcall(function()
    local CoreGui = game:GetService("CoreGui")

    CoreGui.ChildAdded:Connect(function(child)
        if child.Name == "ErrorPrompt" then
            local text = ""

            pcall(function()
                text = child:FindFirstChildWhichIsA("TextLabel").Text
            end)

            if text ~= "" then
                safeRejoin(text)
            end
        end
    end)
end)

-- ERROR MESSAGE
pcall(function()
    GuiService.ErrorMessageChanged:Connect(function(msg)
        if msg and msg ~= "" then
            safeRejoin(msg)
        end
    end)
end)

-- HEARTBEAT TRACK
RunService.Heartbeat:Connect(function()
    lastHeartbeat = tick()
end)

task.spawn(function()
    while task.wait(5) do
        if tick() - lastHeartbeat > 20 then
            safeRejoin("Freeze")
        end
    end
end)

--====================================================
-- END
--====================================================