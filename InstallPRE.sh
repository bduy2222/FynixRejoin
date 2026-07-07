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
echo -e "${C_GREEN}        FYNIX REJOIN PREMIUM - FIX ALL ERRORS     ${C_RESET}"
echo -e "${C_CYAN}═════════════════════════════════════════════════${C_RESET}\n"

# ===== BƯỚC 1: ĐỔI MIRROR CHỐNG NGHẼN =====
echo -e "${C_CYAN}[1/4] Đang tối ưu hóa Mirror chống nghẽn mạng...${C_RESET}"
termux-change-repo <<EOF
1
1
EOF

# ===== BƯỚC 2: CẬP NHẬT LIST VÀ CÀI ĐẶT PYTHON QUYẾT LIỆT =====
echo -e "\n${C_CYAN}[2/4] Cài đặt Python và thư viện đồ họa cốt lõi...${C_RESET}"
apt-get update -y

# Sử dụng tùy chọn apt-get thuần chủng để tránh lỗi vỡ cấu hình dpkg
apt-get install -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confdef" python python-pip libjpeg-turbo libpng

# Kiểm tra xem Python đã cài được chưa, nếu chưa thì cài lại bằng pkg cho chắc chắn
if ! command -v python &> /dev/null; then
    echo -e "${C_YELLOW}[!] Phát hiện lỗi cài đặt, tiến hành ép cài bằng pkg...${C_RESET}"
    pkg install python python-pip libjpeg-turbo libpng -y
fi

# ===== BƯỚC 3: CÀI ĐẶT THƯ VIỆN PYTHON TỐC ĐỘ CAO =====
echo -e "\n${C_CYAN}[3/4] Cài đặt các Module Python (Tăng tốc tăng tiến)...${C_RESET}"
python -m pip install --upgrade pip --no-cache-dir

# Sử dụng Mirror PyPI Châu Á để kéo lib nhanh như chớp
pip install psutil requests aiohttp colorama Pillow nest_asyncio --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple

# ===== BƯỚC 4: TỰ ĐỘNG KHỞI TẠO BỘ NHỚ KHÔNG HỎI LẠI =====
echo -e "\n${C_CYAN}[4/4] Kích hoạt cấu hình lưu trữ thiết bị...${C_RESET}"
# Tự động gửi 'y' nếu hệ thống hỏi lại việc rebuild cấu hình storage
echo "y" | termux-setup-storage

echo -e "\n${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
echo -e "${C_GREEN}          CÀI ĐẶT HOÀN TẤT VÀ FIX LỖI THÀNH CÔNG! ${C_RESET}"
echo -e "${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
echo -e "${C_CYAN}• Khởi chạy Tool ngay:${C_RESET} ${C_YELLOW}python bduyrjpremium.py${C_RESET}\n"
