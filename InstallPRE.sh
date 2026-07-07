#!/bin/bash

# Bảng màu cho đẹp và chuyên nghiệp
GREEN="\e[32;1m"
CYAN="\e[36;1m"
RED="\e[31;1m"
RESET="\e[0m"

clear
echo -e "${CYAN}=================================================${RESET}"
echo -e "${GREEN}      FYNIX REJOIN PREMIUM - SETUP ENVIRONMENT    ${RESET}"
echo -e "${CYAN}=================================================${RESET}\n"

echo -e "${CYAN}[1/4] Cập nhật hệ thống Termux...${RESET}"
pkg update -y && pkg upgrade -y

echo -e "\n${CYAN}[2/4] Cài đặt Python và các trình biên dịch cần thiết...${RESET}"
# Cài đặt Python, trình biên dịch C (clang, make) và thư viện ảnh cho Pillow, psutil
pkg install python python-pip clang make binutils libjpeg-turbo libpng -y

echo -e "\n${CYAN}[3/4] Cài đặt các thư viện Python...${RESET}"
# Nâng cấp pip lên bản mới nhất trước khi cài
pip install --upgrade pip

# Cài đặt các thư viện cốt lõi của tool
pip install psutil requests aiohttp colorama Pillow nest_asyncio

echo -e "\n${CYAN}[4/4] Cấp quyền truy cập bộ nhớ cho Termux...${RESET}"
echo -e "${RED}(Lưu ý: Hãy nhấn CHO PHÉP / ALLOW khi bảng thông báo hiện lên nhé!)${RESET}"
termux-setup-storage

echo -e "\n${GREEN}[✓] QUÁ TRÌNH CÀI ĐẶT HOÀN TẤT!${RESET}"
echo -e "${CYAN}Bây giờ bạn có thể chạy tool bằng lệnh:${RESET} python bduyrjpremium.py\n"
