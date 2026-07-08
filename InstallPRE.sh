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
echo -e "${C_GREEN}         FYNIX REJOIN PREMIUM - FAST INSTALL      ${C_RESET}"
echo -e "${C_CYAN}═════════════════════════════════════════════════${C_RESET}\n"

# ===== BƯỚC 1: ĐỔI MIRROR CHỐNG NGHẼN =====
echo -e "${C_CYAN}[1/4] Đang tối ưu hóa Mirror chống nghẽn mạng...${C_RESET}"
termux-change-repo <<EOF
1
1
EOF

# ===== BƯỚC 2: CÀI ĐẶT GÓI HỆ THỐNG ĐÃ BIÊN DỊCH SẴN (SIÊU NHANH) =====
echo -e "\n${C_CYAN}[2/4] Cài đặt các thư viện pre-compiled từ kho Termux...${C_RESET}"
apt-get update -y

# Lấy chính xác phiên bản Python 3.13 hiện tại để ghim cấu hình
VERSION=$(apt-cache madison python | grep -o '3\.13\.[0-9a-zA-Z.~_-]*' | head -n1)

# Ép cài python-psutil và python-pillow bản ăn sẵn qua apt, chặn đứng việc kéo cmake/llvm bừa bãi
if [ -n "$VERSION" ]; then
    echo -e "${C_GREEN}[+] Ghim cấu hình Python=$VERSION để cài đặt siêu tốc...${C_RESET}"
    apt-get install -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confdef" \
        python=$VERSION python-pip python-psutil python-pillow libjpeg-turbo libpng
else
    echo -e "${C_YELLOW}[!] Cài đặt gói hệ thống thông thường...${C_RESET}"
    apt-get install -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confdef" \
        python-psutil python-pillow libjpeg-turbo libpng
fi

# ===== BƯỚC 3: CÀI ĐẶT CÁC MODULE PYTHON NHẸ CÒN LẠI QUA PIP =====
echo -e "\n${C_CYAN}[3/4] Cài đặt các Module Python còn lại qua PIP...${C_RESET}"

# Đã bỏ 'psutil' và 'Pillow' khỏi pip vì bước 2 cài bản ăn sẵn siêu nhanh rồi.
# Mấy gói còn lại dưới đây cực nhẹ, chỉ là file script thuần nên tải vèo cái là xong, không cần compile gì cả!
pip install requests aiohttp colorama nest_asyncio discord.py --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple

# ===== BƯỚC 4: TỰ ĐỘNG KHỞI TẠO BỘ NHỚ =====
echo -e "\n${C_CYAN}[4/4] Kích hoạt cấu hình lưu trữ thiết bị...${C_RESET}"
echo "y" | termux-setup-storage

echo -e "\n${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
echo -e "${C_GREEN}          CÀI ĐẶT HOÀN TẤT VÀ FIX LỖI THÀNH CÔNG! ${C_RESET}"
echo -e "${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
