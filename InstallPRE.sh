#!/bin/bash

# --- CẤU HÌNH TỐC ĐỘ CAO ---
export DEBIAN_FRONTEND=noninteractive
APT_OPTIONS="-y -o Dpkg::Options::='--force-confnew' -o Dpkg::Options::='--force-confdef'"

# TỰ ĐỘNG CHỌN MIRROR NHANH NHẤT (Cực kỳ quan trọng)
echo -e "\033[36m[!] Đang tối ưu hóa đường truyền...\033[0m"
# Lệnh này sẽ tự động chọn mirror gần nhất, không lấy ZJU nữa
termux-change-repo <<EOF
1
1
EOF

# Cập nhật lại list sau khi đổi mirror
apt update -y
# --- BẢNG MÀU ---
GREEN="\e[32;1m"
CYAN="\e[36;1m"
RESET="\e[0m"

clear
echo -e "${CYAN}=================================================${RESET}"
echo -e "${GREEN}      FYNIX REJOIN PREMIUM - FORCED SETUP       ${RESET}"
echo -e "${CYAN}=================================================${RESET}\n"

# 1. Cập nhật hệ thống với các tùy chọn ép buộc
echo -e "${CYAN}[1/4] Cập nhật hệ thống (Cấu hình cưỡng bức)...${RESET}"
apt update -y
apt upgrade $APT_OPTIONS

# 2. Cài đặt các gói cần thiết
echo -e "\n${CYAN}[2/4] Cài đặt dependencies...${RESET}"
apt install python python-pip clang make binutils libjpeg-turbo libpng $APT_OPTIONS

# 3. Cài thư viện Python
echo -e "\n${CYAN}[3/4] Cài đặt thư viện Python...${RESET}"
pip install --upgrade pip
pip install psutil requests aiohttp colorama Pillow nest_asyncio --no-cache-dir

# 4. Cấp quyền
echo -e "\n${CYAN}[4/4] Cấu hình bộ nhớ...${RESET}"
termux-setup-storage

echo -e "\n${GREEN}=================================================${RESET}"
echo -e "${GREEN}           CÀI ĐẶT HOÀN TẤT THÀNH CÔNG!          ${RESET}"
echo -e "${GREEN}=================================================${RESET}"
echo -e "${CYAN}Khởi chạy: ${RESET}python bduyrjpremium.py\n"
