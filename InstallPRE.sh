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
echo -e "${C_GREEN}         FYNIX REJOIN PREMIUM - ADD DISCORD MODULE ${C_RESET}"
echo -e "${C_CYAN}═════════════════════════════════════════════════${C_RESET}\n"

# ===== BƯỚC 1: ĐỔI MIRROR CHỐNG NGHẼN =====
echo -e "${C_CYAN}[1/4] Đang tối ưu hóa Mirror chống nghẽn mạng...${C_RESET}"
termux-change-repo <<EOF
1
1
EOF

# ===== BƯỚC 2: CÀI ĐẶT THƯ VIỆN ĐỒ HỌA CỐT LÕI (BỎ QUA CÀI LẠI PYTHON) =====
echo -e "\n${C_CYAN}[2/4] Cài đặt các thư viện đồ họa cốt lõi...${C_RESET}"
apt-get update -y

# CHÚ Ý: Đã bỏ gói 'python' và 'python-pip' ra khỏi đây để tránh bị nâng cấp nhầm lên 3.14.
# Gói 'python-psutil' cài qua apt có thể kéo theo python 3.14 làm phụ thuộc (dependency), 
# nên an toàn nhất là cài các thư viện phụ trợ hệ thống trước:
apt-get install -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confdef" libjpeg-turbo libpng

# ===== BƯỚC 3: CÀI ĐẶT CÁC THƯ VIỆN PYTHON QUA PIP (BAO GỒM PSUTIL) =====
echo -e "\n${C_CYAN}[3/4] Cài đặt các Module Python qua PIP của Python 3.13...${C_RESET}"

# Ép pip cài 'psutil' trực tiếp từ nguồn thay vì dùng apt, đảm bảo ăn khớp 100% với Python 3.13 hiện tại.
pip install psutil requests aiohttp colorama Pillow nest_asyncio discord.py --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple

# ===== BƯỚC 4: TỰ ĐỘNG KHỞI TẠO BỘ NHỚ =====
echo -e "\n${C_CYAN}[4/4] Kích hoạt cấu hình lưu trữ thiết bị...${C_RESET}"
echo "y" | termux-setup-storage

echo -e "\n${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
echo -e "${C_GREEN}          CÀI ĐẶT HOÀN TẤT VÀ FIX LỖI THÀNH CÔNG! ${C_RESET}"
echo -e "${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
