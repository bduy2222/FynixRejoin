#!/bin/bash

# --- BẢNG MÀU ---
GREEN="\e[32;1m"
CYAN="\e[36;1m"
YELLOW="\e[33;1m"
RED="\e[31;1m"
RESET="\e[0m"

clear
echo -e "${CYAN}=================================================${RESET}"
echo -e "${GREEN}      FYNIX REJOIN PREMIUM - AUTO SETUP         ${RESET}"
echo -e "${CYAN}=================================================${RESET}\n"

# 1. TỰ ĐỘNG ĐỔI MIRROR REPO (Tăng tốc tải gói)
echo -e "${CYAN}[1/5] Đang tối ưu hóa Repository (Mirror)...${RESET}"
termux-change-repo <<EOF
1
1
EOF

# 2. CẬP NHẬT HỆ THỐNG
echo -e "\n${CYAN}[2/5] Cập nhật hệ thống...${RESET}"
pkg update -y && pkg upgrade -y

# 3. CÀI ĐẶT CÁC GÓI CẦN THIẾT
echo -e "\n${CYAN}[3/5] Cài đặt trình biên dịch và Python...${RESET}"
pkg install python python-pip clang make binutils libjpeg-turbo libpng -y

# 4. CÀI THƯ VIỆN VỚI TỐC ĐỘ CAO (Dùng --no-cache-dir để tránh lỗi vặt)
echo -e "\n${CYAN}[4/5] Cài đặt các thư viện Python (Đang tăng tốc)...${RESET}"
python -m pip install --upgrade pip
pip install psutil requests aiohttp colorama Pillow nest_asyncio --no-cache-dir

# 5. TỰ ĐỘNG CẤP QUYỀN LƯU TRỮ
echo -e "\n${CYAN}[5/5] Cấu hình bộ nhớ...${RESET}"
# Dùng lệnh giả lập nhấn Enter hoặc cài sẵn quyền
if [ ! -d "$HOME/storage" ]; then
    echo -e "${YELLOW}Đang kích hoạt quyền truy cập bộ nhớ...${RESET}"
    termux-setup-storage
    # Script không thể tự bấm nút 'Allow' thay người dùng được (do bảo mật Android)
    # Nhưng lệnh này sẽ kích hoạt bảng prompt ngay lập tức cho người dùng
fi

echo -e "\n${GREEN}=================================================${RESET}"
echo -e "${GREEN}           CÀI ĐẶT HOÀN TẤT THÀNH CÔNG!          ${RESET}"
echo -e "${GREEN}=================================================${RESET}"
echo -e "${CYAN}Khởi chạy tool: ${RESET}python bduyrjpremium.py\n"
