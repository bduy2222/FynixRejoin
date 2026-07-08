#!/bin/bash

# --- CẤU HÌNH KHÔNG CHỜ PROMPT (ÉP BUỘC) ---
export DEBIAN_FRONTEND=noninteractive

# --- BẢNG MÀU ANSI DỊU MẮT ---
C_RESET="\033[0m"
C_GREEN="\033[32;1m"
C_CYAN="\033[36;1m"
C_YELLOW="\033[33;1m"

clear
echo -e "${C_CYAN}═════════════════════════════════════════════════${C_RESET}"
echo -e "${C_GREEN}         FYNIX REJOIN PREMIUM - FAST INSTALL      ${C_RESET}"
echo -e "${C_CYAN}═════════════════════════════════════════════════${C_RESET}\n"

# ===== BƯỚC 1: ĐỔI MIRROR CHỐNG NGHẼN =====
echo -e "${C_CYAN}[1/4] Đang tối ưu hóa Mirror chống nghẽn mạng...${C_RESET}"
termux-change-repo <<EOF
1
1
EOF

# ===== BƯỚC 2: THIẾT LẬP KHO TUR VÀ CÀI THƯ VIỆN ĐÚNG PHIÊN BẢN =====
echo -e "\n${C_CYAN}[2/4] Cài đặt các thư viện hệ thống tương thích Python 3.13...${C_RESET}"

# Ép cài tur-repo để đồng bộ kho gói phụ
pkg install -y tur-repo
apt-get update -y

# Tải các thư viện đồ họa nền
apt-get install -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confdef" libjpeg-turbo libpng

# Lấy chính xác phiên bản Python 3.13 hiện có của hệ thống để ghim chặt cấu hình phụ thuộc
VERSION=$(apt-cache madison python | grep -o '3\.13\.[0-9a-zA-Z.~_-]*' | head -n1)

echo -e "${C_GREEN}[+] Đang tiến hành đồng bộ gói cấu hình pre-compiled...${C_RESET}"
if [ -n "$VERSION" ]; then
    # Ghim cứng bản python=3.13 để bắt buộc apt phải lấy bản psutil/pillow tương thích ngược với Python 3.13 từ kho TUR
    apt-get install -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confdef" \
        python=$VERSION python-pip python-psutil python-pillow
else
    # Phương án dự phòng nếu không lấy được biến version
    apt-get install -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confdef" \
        python-psutil python-pillow
fi

# ===== BƯỚC 3: CÀI ĐẶT CÁC MODULE PYTHON NHẸ CÒN LẠI QUA PIP =====
echo -e "\n${C_CYAN}[3/4] Cài đặt các Module Python còn lại qua PIP...${C_RESET}"
pip install requests aiohttp colorama nest_asyncio discord.py --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple

# ===== BƯỚC 4: TỰ ĐỘNG KHỞI TẠO BỘ NHỚ =====
echo -e "\n${C_CYAN}[4/4] Kích hoạt cấu hình lưu trữ thiết bị...${C_RESET}"
echo "y" | termux-setup-storage

echo -e "\n${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
echo -e "${C_GREEN}          CÀI ĐẶT HOÀN TẤT VÀ FIX LỖI THÀNH CÔNG! ${C_RESET}"
echo -e "${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
