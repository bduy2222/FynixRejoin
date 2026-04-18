--====================================================
-- FYNIX ONLINE CHECK (SAFE + NOTIFY)
--====================================================

getgenv().delay = getgenv().delay or 10

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

--====================================================
-- NOTIFY (SMOOTH + NO SPAM)
--====================================================
local currentNotify

local function notify(title, text, duration)
    duration = duration or 3

    if currentNotify then
        currentNotify:Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "FynixNotify"
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 260, 0, 65)
    frame.Position = UDim2.new(1, 300, 1, -90)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0.45, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(0,170,255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 15
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 0.55, 0)
    textLabel.Position = UDim2.new(0, 10, 0.45, 0)
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(220,220,220)
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 13
    textLabel.BackgroundTransparency = 1
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = frame

    -- slide in
    TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -280, 1, -90)
    }):Play()

    -- fade in
    frame.BackgroundTransparency = 1
    TweenService:Create(frame, TweenInfo.new(0.25), {
        BackgroundTransparency = 0
    }):Play()

    currentNotify = gui

    task.delay(duration, function()
        if gui then
            TweenService:Create(frame, TweenInfo.new(0.3), {
                Position = UDim2.new(1, 300, 1, -90)
            }):Play()

            task.wait(0.3)
            gui:Destroy()
        end
    end)
end

--====================================================
-- PATH
--====================================================
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

-- WRITE SAFE
local lastWrite = 0
local function writeState(status)
    if tick() - lastWrite < 2 then return end
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
    notify("Fynix", "Online", 3)
end

-- OFFLINE
local function setOffline()
    if shuttingDown then return end
    shuttingDown = true
    onlineActive = false
    writeState("Offline")
    notify("Fynix", "Offline", 2)
end

-- LOAD
task.spawn(function()
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    setOnline()
end)

-- HEARTBEAT LOOP
task.spawn(function()
    while task.wait(getgenv().delay) do
        if onlineActive and not shuttingDown then
            writeState("Online")
        end
    end
end)

-- SAFE REJOIN
local lastRejoin = 0
local function safeRejoin(reason)
    if rejoining then return end
    if tick() - lastRejoin < 15 then return end

    rejoining = true
    lastRejoin = tick()

    notify("Fynix", "Rejoining...", 2)

    task.delay(2, function()
        pcall(function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
    end)
end

-- CHARACTER CHECK
LocalPlayer.CharacterRemoving:Connect(function()
    task.delay(3, function()
        if not LocalPlayer.Character then
            safeRejoin("Character lost")
        end
    end)
end)

-- TELEPORT FAIL
pcall(function()
    LocalPlayer.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Failed then
            safeRejoin("Teleport failed")
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

-- FREEZE CHECK
local lastHeartbeat = tick()

RunService.Heartbeat:Connect(function()
    lastHeartbeat = tick()
end)

task.spawn(function()
    while task.wait(8) do
        if tick() - lastHeartbeat > 25 then
            safeRejoin("Freeze detected")
        end
    end
end)

-- EXIT
game:BindToClose(function()
    setOffline()
end)

--====================================================
-- EXEC NOTIFY
--====================================================
notify("Fynix", "Script Loaded", 3)

--====================================================
-- END
--====================================================