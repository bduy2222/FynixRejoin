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
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local NOTIFY_STACK = {}
local SPACING = 70

local function notify(title, text, duration)

    duration = duration or 3

    -- ===== GUI =====
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FynixNotify"
    screenGui.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 70)
    frame.Position = UDim2.new(1, 300, 1, -100) -- start ngo�i m�n
    frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    -- bo g�c
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    -- shadow gi
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
    shadow.BackgroundTransparency = 0.7
    shadow.ZIndex = 0
    shadow.Parent = frame

    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 12)
    shadowCorner.Parent = shadow

    -- TITLE
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0.4, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame

    -- TEXT
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 0.6, 0)
    textLabel.Position = UDim2.new(0, 10, 0.4, 0)
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(220,220,220)
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 14
    textLabel.BackgroundTransparency = 1
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = frame

    -- ===== STACK POSITION =====
    table.insert(NOTIFY_STACK, frame)

    for i, f in ipairs(NOTIFY_STACK) do
        local y = -100 - ((i - 1) * SPACING)
        TweenService:Create(f, TweenInfo.new(0.25), {
            Position = UDim2.new(1, -300, 1, y)
        }):Play()
    end

    -- ===== SLIDE IN =====
    TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -300, 1, frame.Position.Y.Offset)
    }):Play()

    -- ===== FADE IN =====
    frame.BackgroundTransparency = 1
    TweenService:Create(frame, TweenInfo.new(0.3), {
        BackgroundTransparency = 0
    }):Play()

    -- ===== AUTO REMOVE =====
    task.delay(duration, function()

        -- slide out
        local tween = TweenService:Create(frame, TweenInfo.new(0.3), {
            Position = UDim2.new(1, 300, 1, frame.Position.Y.Offset)
        })
        tween:Play()

        tween.Completed:Wait()

        -- remove khi stack
        for i, f in ipairs(NOTIFY_STACK) do
            if f == frame then
                table.remove(NOTIFY_STACK, i)
                break
            end
        end

        screenGui:Destroy()

        -- re-stack li
        for i, f in ipairs(NOTIFY_STACK) do
            local y = -100 - ((i - 1) * SPACING)
            TweenService:Create(f, TweenInfo.new(0.25), {
                Position = UDim2.new(1, -300, 1, y)
            }):Play()
        end

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

    notify("Fynix", "ONLINE", 3)
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