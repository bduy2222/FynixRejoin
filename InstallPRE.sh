#!/bin/bash

# --- CẤU HÌNH KHÔNG CHỜ PROMPT (ÉP BUỘC) ---
export DEBIAN_FRONTEND=noninteractive

# --- BẢNG MÀU ANSI DỊU MỚT ---
C_RESET="\033[0m"
C_GREEN="\033[32;1m"
C_CYAN="\033[36;1m"
C_YELLOW="\033[33;1m"

clear
echo -e "${C_CYAN}═════════════════════════════════════════════════${C_RESET}"
echo -e "${C_GREEN}         FYNIX REJOIN PREMIUM - ADD DISCORD MODULE ${C_RESET}"
echo -e "${C_CYAN}═════════════════════════════════════════════════${C_RESET}\n"

# ===== BƯỚC 1: ĐỔI MIRROR CHỐNG NGHẼN =====
echo -e "${C_CYAN}[1/4] Đang tối ưu hóa Mirror chống nghẽn mạng...${C_RESET}"
termux-change-repo <<EOF
1
1
EOF

# ===== BƯỚC 2: CÀI ĐẶT THƯ VIỆN HỆ THỐNG VÀ PYTHON-PSUTIL CHUẨN =====
echo -e "\n${C_CYAN}[2/4] Cài đặt các thư viện đồ họa và python-psutil...${C_RESET}"
apt-get update -y

# Lấy lại chính xác phiên bản Python 3.13 hiện có trong hệ thống kho TUR
VERSION=$(apt-cache madison python | grep -o '3\.13\.[0-9a-zA-Z.~_-]*' | head -n1)

# Cài đặt thêm build-essential, libjpeg-turbo, libpng để Pillow có thể compile qua pip
# Đồng thời ép apt cài python-psutil nhưng GIỮ CỨNG python ở phiên bản 3.13 cũ
if [ -n "$VERSION" ]; then
    echo -e "${C_GREEN}[+] Đang ghim cấu hình Python=$VERSION để cài gói hệ thống...${C_RESET}"
    apt-get install -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confdef" \
        python=$VERSION python-pip python-psutil libjpeg-turbo libpng build-essential
else
    echo -e "${C_YELLOW}[!] Không xác định được cụ thể tag 3.13, cài gói hệ thống thông thường...${C_RESET}"
    apt-get install -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confdef" \
        python-psutil libjpeg-turbo libpng build-essential
fi

# ===== BƯỚC 3: CÀI ĐẶT CÁC THƯ VIỆN PYTHON QUA PIP =====
echo -e "\n${C_CYAN}[3/4] Cài đặt các Module Python qua PIP...${C_RESET}"

# Đã loại bỏ 'psutil' khỏi danh sách pip vì đã cài bản pre-compiled từ apt ở Bước 2
pip install requests aiohttp colorama Pillow nest_asyncio discord.py --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple

# ===== BƯỚC 4: TỰ ĐỘNG KHỞI TẠO BỘ NHỚ =====
echo -e "\n${C_CYAN}[4/4] Kích hoạt cấu hình lưu trữ thiết bị...${C_RESET}"
echo "y" | termux-setup-storage

echo -e "\n${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
echo -e "${C_GREEN}          CÀI ĐẶT HOÀN TẤT VÀ FIX LỖI THÀNH CÔNG! ${C_RESET}"
echo -e "${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
