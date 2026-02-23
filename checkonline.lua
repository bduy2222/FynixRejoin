repeat task.wait() until game.Players.LocalPlayer
task.wait(1)

-- CONFIG
getgenv().delay = getgenv().delay or 3   -- ↓ giảm delay xuống 3s
local Delay = getgenv().delay

local Players         = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local VirtualUser     = game:GetService("VirtualUser")
local CoreGui         = game:GetService("CoreGui")
local StarterGui      = game:GetService("StarterGui")

local plr = Players.LocalPlayer

if not writefile or not makefolder or not isfolder then
    warn("Executor không hỗ trợ file system")
    return
end

local folderName = "CheckOnlineFynix"
local fileName   = folderName .. "\\" .. plr.Name .. "_online.txt"

if not isfolder(folderName) then
    makefolder(folderName)
end

----------------------------------------------------------
-- NOTIFICATION
----------------------------------------------------------
local function Notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 5
        })
    end)
end

Notify("CheckOnlineFynix", "Script đã chạy | Delay: "..Delay.."s")

----------------------------------------------------------
-- FILE FUNCTIONS
----------------------------------------------------------
local function writeOnline()
    writefile(fileName, "1")
end

local function writeOffline()
    writefile(fileName, "2")
end

writeOnline()

-- update online định kỳ theo delay
task.spawn(function()
    while task.wait(Delay) do
        writeOnline()
    end
end)

----------------------------------------------------------
-- OFFLINE EVENTS (SAFE MODE)
----------------------------------------------------------

-- chỉ ghi offline khi PlayerRemoving thật sự
Players.PlayerRemoving:Connect(function(p)
    if p == plr then
        writeOffline()
    end
end)

-- CHỈ ghi offline nếu teleport FAIL
plr.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Failed then
        task.wait(2)
        writeOffline()
    end
end)

----------------------------------------------------------
-- ANTI AFK
----------------------------------------------------------
plr.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
    task.wait(0.1)
    VirtualUser:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
end)

----------------------------------------------------------
-- AUTO REJOIN (CONFIRM BEFORE OFFLINE)
----------------------------------------------------------
local PromptOverlay =
    CoreGui:WaitForChild("RobloxPromptGui")
    :WaitForChild("promptOverlay")

PromptOverlay.ChildAdded:Connect(function(child)
    if child.Name == "ErrorPrompt" then
        task.spawn(function()
            task.wait(3) -- confirm thật sự mất kết nối
            writeOffline()
            Notify("CheckOnlineFynix", "Mất kết nối - Đang Rejoin...")
            task.wait(1)
            TeleportService:Teleport(game.PlaceId, plr)
        end)
    end
end)
