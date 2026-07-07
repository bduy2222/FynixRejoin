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

# 1. TỰ ĐỘNG CẬP NHẬT VÀ GHI ĐÈ CẤU HÌNH (Bỏ qua prompt sources.list)
echo -e "${CYAN}[1/4] Đang cập nhật hệ thống (Tự động xác nhận)...${RESET}"
# -y: tự động đồng ý
# -o Dpkg::Options...: tự động chọn cấu hình mới nhất mà không hỏi lại
pkg update -y
pkg upgrade -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confdef"

# 2. CÀI ĐẶT CÁC GÓI CẦN THIẾT
echo -e "\n${CYAN}[2/4] Cài đặt trình biên dịch và Python...${RESET}"
pkg install python python-pip clang make binutils libjpeg-turbo libpng -y

# 3. CÀI THƯ VIỆN PYTHON (Tối ưu tốc độ)
echo -e "\n${CYAN}[3/4] Cài đặt thư viện Python...${RESET}"
python -m pip install --upgrade pip
pip install psutil requests aiohttp colorama Pillow nest_asyncio --no-cache-dir

# 4. CẤP QUYỀN LƯU TRỮ
echo -e "\n${CYAN}[4/4] Cấu hình bộ nhớ...${RESET}"
# Lệnh này sẽ yêu cầu người dùng nhấn 'Allow' 1 lần duy nhất từ hệ thống Android
termux-setup-storage

echo -e "\n${GREEN}=================================================${RESET}"
echo -e "${GREEN}           CÀI ĐẶT HOÀN TẤT THÀNH CÔNG!          ${RESET}"
echo -e "${GREEN}=================================================${RESET}"
echo -e "${CYAN}Khởi chạy tool: ${RESET}python bduyrjpremium.py\n"
