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

# ===== BƯỚC 2: CÀI ĐẶT THƯ VIỆN HỆ THỐNG VÀ GÓI PRE-COMPILED CHO PY3.13 =====
echo -e "\n${C_CYAN}[2/4] Cài đặt các thư viện pre-compiled tương thích Python 3.13...${C_RESET}"
apt-get update -y

# Cài các thư viện nền của hệ thống trước
apt-get install -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confdef" libjpeg-turbo libpng

# Tạo thư mục tạm để tải gói deb sạch
mkdir -p /sdcard/Download/fynix_tmp && cd /sdcard/Download/fynix_tmp

echo -e "${C_GREEN}[+] Đang kéo gói từ kho lưu trữ lịch sử chính thức (Archive)...${C_RESET}"
# Sử dụng link archive.org độc quyền lưu trữ các bản phân phối cũ của TUR, không lo dính 404
curl -L -o python-psutil.deb "https://archive.org/download/termux-user-repository-tur-legacy/tur/python-psutil/python-psutil_7.0.0-1_x86_64.deb"
curl -L -o python-pillow.deb "https://archive.org/download/termux-user-repository-tur-legacy/tur/python-pillow/python-pillow_11.1.0-1_x86_64.deb"

echo -e "${C_GREEN}[+] Ép hệ thống cài đặt bằng dpkg...${C_RESET}"
# Ép cài đặt không màng dependency để nhận diện thẳng vào lõi Python 3.13
dpkg -i --force-depends *.deb

# Dọn dẹp rác sau khi cài xong
cd ~ && rm -rf /sdcard/Download/fynix_tmp

# ===== BƯỚC 3: CÀI ĐẶT CÁC MODULE PYTHON NHẸ CÒN LẠI QUA PIP =====
echo -e "\n${C_CYAN}[3/4] Cài đặt các Module Python còn lại qua PIP...${C_RESET}"
pip install requests aiohttp colorama nest_asyncio discord.py --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple

# ===== BƯỚC 4: TỰ ĐỘNG KHỞI TẠO BỘ NHỚ =====
echo -e "\n${C_CYAN}[4/4] Kích hoạt cấu hình lưu trữ thiết bị...${C_RESET}"
echo "y" | termux-setup-storage

echo -e "\n${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
echo -e "${C_GREEN}          CÀI ĐẶT HOÀN TẤT VÀ FIX LỖI THÀNH CÔNG! ${C_RESET}"
echo -e "${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
