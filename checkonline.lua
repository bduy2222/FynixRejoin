--====================================================
--  FYNIX ONLINE CHECK SYSTEM (CLIENT SAFE VERSION)
--====================================================

-- CONFIG
getgenv().delay = getgenv().delay or 9 -- 8-10 seconds

-- SERVICES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- SIMPLE NOTIFY
local function notify(title, text, time)
pcall(function()
StarterGui:SetCore("SendNotification", {
Title = title,
Text = text,
Duration = time or 3
})
end)
end

-- PATH ( FIX USERID ONLY)
local folderPath = "CheckOnlineFynix"
local filePath = folderPath .. "/" .. tostring(LocalPlayer.UserId) .. "_online.txt"

-- ENSURE FOLDER
if not isfolder(folderPath) then
    makefolder(folderPath)
end

-- BUILD JSON
local function buildData(status)
return {
placeId = game.PlaceId,
date = os.date("%Y-%m-%d %H:%M:%S"),
timestamp = os.time(),
status = status,
jobId = game.JobId
}
end

-- SAFE WRITE (JSON)
local function writeState(status)
pcall(function()
local data = buildData(status or "Online")
local encoded = HttpService:JSONEncode(data)
writefile(filePath, encoded)
end)
end

-- ENSURE FILE EXISTS
pcall(function()
if not isfile(filePath) then
task.wait(1)
writeState("Offline")
end
end)

-- STATE CONTROL
local onlineActive = false
local shuttingDown = false

local function setOnline()
if shuttingDown then return end
if onlineActive then return end
onlineActive = true
writeState("Online")

notify("Fynix", "Status: ONLINE", 3)

end

local function setOffline()
if shuttingDown then return end
shuttingDown = true
onlineActive = false

writeState("Offline")

notify("Fynix", "Status: OFFLINE", 3)

end

--====================================================
-- LOAD COMPLETE
--====================================================

task.spawn(function()
notify("Fynix", "Script Loaded", 3)

if not game:IsLoaded() then  
	game.Loaded:Wait()  
end  

if LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() then  
	task.wait(2)  
	setOnline()  
end

end)

--====================================================
-- HEARTBEAT (ALWAYS WRITE)
--====================================================

task.spawn(function()
while true do
task.wait(getgenv().delay)

if onlineActive and not shuttingDown then  
		local ok, err = pcall(function()  
			writeState("Online")  
		end)  

		if not ok then  
			warn("[FYNIX] writeState failed:", err)  
		end  
	end  
end

end)

--====================================================
-- SMART OFFLINE / REJOIN SYSTEM
--====================================================

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer

local lastHeartbeat = tick()
local isRejoining = false

-- ===== SAFE REJOIN =====
local function safeRejoin(reason)
    if isRejoining then return end
    isRejoining = true

    warn("[FYNIX] Rejoining due to:", reason)

    task.wait(1)

    pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end

--====================================================
-- CHARACTER REMOVED (CHỈ REJOIN KHI KHÔNG PHẢI RESET)
--====================================================
LocalPlayer.CharacterRemoving:Connect(function()
    task.wait(1)

    if not LocalPlayer.Character then
        safeRejoin("Character lost")
    end
end)

--====================================================
-- PLAYER REMOVING (DISCONNECT)
--====================================================
Players.PlayerRemoving:Connect(function(plr)
    if plr == LocalPlayer then
        safeRejoin("PlayerRemoving")
    end
end)

--====================================================
-- TELEPORT START (IGNORE)
--====================================================
pcall(function()
    LocalPlayer.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Failed then
            safeRejoin("Teleport failed")
        end
    end)
end)

--====================================================
-- ERROR PROMPT (CHỈ CHECK TEXT)
--====================================================
pcall(function()
    local CoreGui = game:GetService("CoreGui")

    CoreGui.ChildAdded:Connect(function(child)
        if child.Name == "ErrorPrompt" then

            local text = ""

            pcall(function()
                text = child:FindFirstChildWhichIsA("TextLabel").Text
            end)

            if text ~= "" then
                safeRejoin("ErrorPrompt: " .. text)
            end
        end
    end)
end)

--====================================================
-- ERROR MESSAGE (FILTER)
--====================================================
pcall(function()
    GuiService.ErrorMessageChanged:Connect(function(msg)
        if msg and msg ~= "" then
            safeRejoin("ErrorMessage: " .. msg)
        end
    end)
end)

--====================================================
-- HEARTBEAT CHECK (ANTI FREEZE)
--====================================================
RunService.Heartbeat:Connect(function()
    lastHeartbeat = tick()
end)

task.spawn(function()
    while task.wait(5) do
        if tick() - lastHeartbeat > 20 then
            safeRejoin("Heartbeat freeze")
        end
    end
end)

--====================================================
-- END
--====================================================