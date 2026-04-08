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
-- OFFLINE TRIGGERS
--====================================================

LocalPlayer.CharacterRemoving:Connect(function()
setOffline()
end)

Players.PlayerRemoving:Connect(function(plr)
if plr == LocalPlayer then
setOffline()
end
end)

pcall(function()
LocalPlayer.OnTeleport:Connect(function(state)
if state == Enum.TeleportState.Started then
setOffline()
end
end)
end)

pcall(function()
local CoreGui = game:GetService("CoreGui")
CoreGui.ChildAdded:Connect(function(child)
if child.Name == "ErrorPrompt" then
setOffline()
end
end)
end)

pcall(function()
GuiService.ErrorMessageChanged:Connect(function()
setOffline()
end)
end)

local lastHeartbeat = tick()
RunService.Heartbeat:Connect(function()
lastHeartbeat = tick()
end)

task.spawn(function()
while task.wait(5) do
if tick() - lastHeartbeat > 15 then
setOffline()
end
end
end)

--====================================================
-- END
--====================================================