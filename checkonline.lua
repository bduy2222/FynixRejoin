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

-- PATH ( FIX HERE)
local folderPath = "CheckOnlineFynix"
local filePath = folderPath .. "/" .. LocalPlayer.Name .. "_online.txt"

-- ENSURE FOLDER ( FIX HERE)
if not isfolder(folderPath) then
	makefolder(folderPath)
end

-- SAFE WRITE (ONLINE = 1)
local function writeState()
	pcall(function()
		writefile(filePath, "1")
	end)
end

-- ENSURE FILE EXISTS
pcall(function()
	if not isfile(filePath) then
		writefile(filePath, "2")
	end
end)

-- STATE CONTROL
local onlineActive = false
local shuttingDown = false

local function setOnline()
	if shuttingDown then return end
	if onlineActive then return end
	onlineActive = true
	writeState()

	notify("Fynix", "Status: ONLINE", 3)
end

local function setOffline()
	if shuttingDown then return end
	shuttingDown = true
	onlineActive = false

	pcall(function()
		writefile(filePath, "2")
	end)

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
-- HEARTBEAT ( ALWAYS WRITE)
--====================================================

task.spawn(function()
	while task.wait(getgenv().delay) do
		if onlineActive and not shuttingDown then
			writeState()
		end
	end
end)

--====================================================
-- OFFLINE TRIGGERS (CLIENT SAFE)
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