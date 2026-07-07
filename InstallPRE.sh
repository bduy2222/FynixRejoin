#!/bin/bash

# --- CẤU HÌNH CƯỠNG BỨC KHÔNG PROMPT ---
export DEBIAN_FRONTEND=noninteractive
APT_OPTIONS="-y -o Dpkg::Options::='--force-confnew' -o Dpkg::Options::='--force-confdef'"

# --- BẢNG MÀU ANSI DỊU MẮT ---
C_RESET="\033[0m"
C_GREEN="\033[32;1m"
C_CYAN="\033[36;1m"
C_YELLOW="\033[33;1m"

clear
echo -e "${C_CYAN}═════════════════════════════════════════════════${C_RESET}"
echo -e "${C_GREEN}        FYNIX REJOIN PREMIUM - SUPER SPEED SETUP  ${C_RESET}"
echo -e "${C_CYAN}═════════════════════════════════════════════════${C_RESET}\n"

# ===== BƯỚC 1: ĐỔI MIRROR CHỐNG NGHẼN =====
echo -e "${C_CYAN}[1/4] Đang tối ưu hóa Mirror chống nghẽn mạng...${C_RESET}"
termux-change-repo <<EOF
1
1
EOF

# ===== BƯỚC 2: CẬP NHẬT LIST KHÔNG UPGRADE GÓI CŨ =====
# Chỉ update list để tải gói mới, KHÔNG upgrade toàn bộ hệ thống (tránh kéo theo llvm)
apt update -y

# ===== BƯỚC 3: CÀI PYTHON GỌN NHẸ (BỎ CLANG/LLVM) =====
echo -e "\n${C_CYAN}[2/4] Cài đặt Python và thư viện đồ họa cốt lõi...${C_RESET}"
# ĐÃ XÓA: clang, make, binutils (Giảm từ 664MB xuống còn mười mấy MB!)
apt install python python-pip libjpeg-turbo libpng $APT_OPTIONS

# ===== BƯỚC 4: CÀI THƯ VIỆN PYTHON TỐC ĐỘ CAO =====
echo -e "\n${C_CYAN}[3/4] Cài đặt các Module Python (Tăng tốc tăng tiến)...${C_RESET}"
python -m pip install --upgrade pip

# Sử dụng Mirror của PyPI tại Châu Á (tsinghua) để kéo thư viện với tốc độ tối đa
pip install psutil requests aiohttp colorama Pillow nest_asyncio --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple

# ===== BƯỚC 5: CẤP QUYỀN BỘ NHỚ =====
echo -e "\n${C_CYAN}[4/4] Kích hoạt cấu hình lưu trữ thiết bị...${C_RESET}"
termux-setup-storage

echo -e "\n${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
echo -e "${C_GREEN}          CÀI ĐẶT HOÀN TẤT VỚI TỐC ĐỘ TỐI ƯU!    ${C_RESET}"
echo -e "${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
echo -e "${C_CYAN}• Khởi chạy Tool ngay:${C_RESET} ${C_YELLOW}python bduyrjpremium.py${C_RESET}\n"
