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
local LocalPlayer = Players.LocalPlayer

-- PATH (🔥 FIX HERE)
local folderPath = "CheckOnlineFynix"
local filePath = folderPath .. "/" .. LocalPlayer.Name .. "_online.txt"

-- ENSURE FOLDER (🔥 FIX HERE)
if not isfolder(folderPath) then
	makefolder(folderPath)
end

-- SAFE WRITE (TIMESTAMP)
local function writeState()
	local now = os.time()

	pcall(function()
		writefile(filePath, tostring(now))
	end)
end

-- ENSURE FILE EXISTS
pcall(function()
	if not isfile(filePath) then
		writefile(filePath, "0")
	end
end)

-- STATE CONTROL
local onlineActive = false
local shuttingDown = false

local function setOnline()
	if shuttingDown then return end
	if onlineActive then return end
	onlineActive = true
	writeState() -- 🔥 vẫn giữ lần đầu
end

local function setOffline()
	if shuttingDown then return end
	shuttingDown = true
	onlineActive = false

	pcall(function()
		writefile(filePath, "0")
	end)
end

--====================================================
-- LOAD COMPLETE
--====================================================

task.spawn(function()
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end

	if LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() then
		task.wait(2)
		setOnline()
	end
end)

--====================================================
-- HEARTBEAT (🔥 ALWAYS WRITE)
--====================================================

task.spawn(function()
	while task.wait(getgenv().delay) do
		if onlineActive and not shuttingDown then
			writeState() -- 🔥 luôn write mỗi delay
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