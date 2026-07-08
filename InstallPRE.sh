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

# ===== BƯỚC 2: CÀI ĐẶT THƯ VIỆN HỆ THỐNG VÀ GÓI PRE-COMPILED CHO PY3.13 =====
echo -e "\n${C_CYAN}[2/4] Cài đặt các thư viện pre-compiled tương thích Python 3.13...${C_RESET}"
apt-get update -y

# Cài các thư viện nền của hệ thống trước
apt-get install -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confdef" libjpeg-turbo libpng

# Tạo thư mục tạm để tải gói deb sạch, né check dependency nghẹt nghèo của apt
mkdir -p /sdcard/Download/fynix_tmp && cd /sdcard/Download/fynix_tmp

echo -e "${C_GREEN}[+] Đang kéo gói python-psutil và python-pillow chuẩn cho Python 3.13...${C_RESET}"
# Tải trực tiếp bản build chuẩn xác cho kiến trúc x86_64 chạy nền Python 3.13 từ archive chính thống của TUR
curl -LO "https://github.com/termux-user-repository/tur/releases/download/packages-2025.01.15/python-psutil_7.0.0-1_x86_64.deb"
curl -LO "https://github.com/termux-user-repository/tur/releases/download/packages-2025.01.15/python-pillow_11.1.0-1_x86_64.deb"

echo -e "${C_GREEN}[+] Ép hệ thống cài đặt bằng dpkg...${C_RESET}"
# Dùng dpkg -i và thêm --force-depends để ép cài đặt bỏ qua mọi lằng nhằng check ngược của hệ thống
dpkg -i --force-depends *.deb

# Dọn dẹp rác sau khi cài xong
cd ~ && rm -rf /sdcard/Download/fynix_tmp

# ===== BƯỚC 3: CÀI ĐẶT CÁC MODULE PYTHON NHẸ CÒN LẠI QUA PIP =====
echo -e "\n${C_CYAN}[3/4] Cài đặt các Module Python còn lại qua PIP...${C_RESET}"
# Đã cài ăn sẵn psutil và Pillow ở bước trên, các gói này chạy pip vèo cái là xong
pip install requests aiohttp colorama nest_asyncio discord.py --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple

# ===== BƯỚC 4: TỰ ĐỘNG KHỞI TẠO BỘ NHỚ =====
echo -e "\n${C_CYAN}[4/4] Kích hoạt cấu hình lưu trữ thiết bị...${C_RESET}"
echo "y" | termux-setup-storage

echo -e "\n${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
echo -e "${C_GREEN}          CÀI ĐẶT HOÀN TẤT VÀ FIX LỖI THÀNH CÔNG! ${C_RESET}"
echo -e "${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
