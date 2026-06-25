-- [[ FYNIX GLOBAL CONFIGURATION ]]
getgenv().LogInterval = 30     -- Chu kỳ cập nhật file log (Giây)
getgenv().AutoRejoin = true     -- Bật/Tắt chế độ tự động Rejoin khi dính bảng lỗi

-- [[ CORE SERVICES ]]
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local UserId = tostring(LocalPlayer.UserId)
local PlaceId = game.PlaceId

-- Khử alias hàm ghi file hệ thống bảo vệ tài nguyên
local makeFolder = makefolder or createfolder
local writeFile = writefile
local isFile = isfile

local FOLDER_NAME = "Fynix Checker"
local FILE_PATH = FOLDER_NAME .. "/" .. UserId .. ".txt"

-- 1. KHỞI TẠO CẤU TRÚC THƯ MỤC AN TOÀN
pcall(function()
    if makeFolder then
        makeFolder(FOLDER_NAME)
    end
end)

-- Hàm tối ưu hóa ghi log phẳng (ONLINE / OFFLINE + TIMESTAMP)
local function updateHeartbeatLog(status)
    pcall(function()
        if writeFile then
            local payload = string.upper(status) .. " " .. tostring(os.time())
            writeFile(FILE_PATH, payload)
        end
    end)
end

-- 2. LUỒNG HEARTBEAT ĐỊNH KỲ (SỬ DỤNG TASK.SPAWN + TASK.WAIT KHÔNG TỐN TÀI NGUYÊN)
task.spawn(function()
    while true do
        updateHeartbeatLog("ONLINE")
        task.wait(getgenv().LogInterval or 30)
    end
end)

-- 3. BẮT SỰ KIỆN THOÁT GAME CHỦ ĐỘNG (ALT+F4, CRASH TRONG TẦM KIỂM SOÁT)
pcall(function()
    game:GetService("LogService").MessageResourceLimitChanged:Connect(function() end) -- Giữ thread ổn định
    
    -- Khi người dùng bấm thoát hoặc tiến trình bị hủy chủ động
    game.Close:Connect(function()
        updateHeartbeatLog("OFFLINE")
    end)
end)

-- 4. CORE AUTO REJOIN - EVENT-BASED (BẮT SỰ KIỆN KHÔNG DÙNG LOOP CHỐNG DROP FPS)
if getgenv().AutoRejoin and not getgenv().FynixRejoinConnected then
    getgenv().FynixRejoinConnected = true -- Cờ chặn trùng lặp kết nối (Anti-Leak)

    local promptOverlay = CoreGui:WaitForChild("RobloxPromptGui"):WaitForChild("promptOverlay")
    
    promptOverlay.ChildAdded:Connect(function(child)
        task.defer(function() -- Sử dụng defer để chạy bất đồng bộ nhẹ máy
            pcall(function()
                if child.Name == "ErrorPrompt" then
                    local messageArea = child:FindFirstChild("MessageArea")
                    if messageArea and messageArea:FindFirstChild("ErrorFrame") then
                        
                        -- Chuyển trạng thái file sang OFFLINE trước khi nhảy Server
                        updateHeartbeatLog("OFFLINE")
                        
                        -- Tiến hành dịch chuyển về đúng PlaceID
                        task.wait(1) -- Delay an toàn chống nghẽn luồng kết nối
                        TeleportService:Teleport(PlaceId, LocalPlayer)
                    end
                end
            end)
        end)
    end)
end

-- 5. ANTI-KICK & ANTI-DETECTION BYPASS HOOK (SAFE-SKIP ENGINE)
-- Kiểm tra xem Executor có hỗ trợ đầy đủ các hàm can thiệp Metatable không
local isMetatableSupported = getrawmetatable and setreadonly and newcclosure and getnamecallmethod

if isMetatableSupported then
    pcall(function()
        local metatable = getrawmetatable(game)
        local oldNamecall = metatable.__namecall
        local oldIndex = metatable.__index

        setreadonly(metatable, false)

        -- Hook Namecall chặn các lệnh gọi `LocalPlayer:Kick()` từ game
        metatable.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if self == LocalPlayer and (method == "Kick" or method == "kick") then
                -- Ghi log OFFLINE và tự động kích hoạt Rejoin ngay lập tức bên trong
                updateHeartbeatLog("OFFLINE")
                task.spawn(function()
                    TeleportService:Teleport(PlaceId, LocalPlayer)
                end)
                
                return nil -- Chặn đứng lệnh Kick không cho truyền về server Roblox
            end
            
            return oldNamecall(self, ...)
        end)

        -- Hook Index chặn các script bên thứ ba dò tìm hoặc can thiệp vào Core Rejoin
        metatable.__index = newcclosure(function(self, key)
            if not checkcaller() then
                if key == "FynixRejoinConnected" or key == "LogInterval" then
                    return nil
                end
            end
            return oldIndex(self, key)
        end)

        setreadonly(metatable, true)
    end)
else
    -- Nếu Executor cùi không hỗ trợ, in ra cảnh báo nhẹ trong Console game (Không gây crash script)
    print("[Fynix Warning]: Metatable hooking not supported by this executor. Anti-Kick bypassed safely.")
end
