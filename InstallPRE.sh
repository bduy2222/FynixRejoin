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
echo -e "${C_GREEN}        FYNIX REJOIN PREMIUM - FIX PSUTIL ERROR   ${C_RESET}"
echo -e "${C_CYAN}═════════════════════════════════════════════════${C_RESET}\n"

# ===== BƯỚC 1: ĐỔI MIRROR CHỐNG NGHẼN =====
echo -e "${C_CYAN}[1/4] Đang tối ưu hóa Mirror chống nghẽn mạng...${C_RESET}"
termux-change-repo <<EOF
1
1
EOF

# ===== BƯỚC 2: CẬP NHẬT LIST VÀ CÀI ĐẶT PYTHON + PSUTIL HỆ THỐNG =====
echo -e "\n${C_CYAN}[2/4] Cài đặt Python, Psutil và thư viện đồ họa cốt lõi...${C_RESET}"
apt-get update -y

# Cài đặt python-psutil từ apt-get (Bản pre-compiled của Termux, bao không lỗi)
apt-get install -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confdef" python python-pip python-psutil libjpeg-turbo libpng

# Kiểm tra dự phòng (Fallback) nếu apt-get có vấn đề thì ép bằng pkg
if ! command -v python &> /dev/null || ! python -c "import psutil" &> /dev/null; then
    echo -e "${C_YELLOW}[!] Có chút trục trặc, tiến hành cài ép cấu hình bằng pkg...${C_RESET}"
    pkg install python python-pip python-psutil libjpeg-turbo libpng -y
fi

# ===== BƯỚC 3: CÀI ĐẶT CÁC THƯ VIỆN PYTHON CÒN LẠI =====
echo -e "\n${C_CYAN}[3/4] Cài đặt các Module Python còn lại...${C_RESET}"
# BỎ QUA lệnh upgrade pip vì Termux cấm, cài thẳng các lib còn lại (đã bỏ psutil khỏi pip)
pip install requests aiohttp colorama Pillow nest_asyncio --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple

# ===== BƯỚC 4: TỰ ĐỘNG KHỞI TẠO BỘ NHỚ =====
echo -e "\n${C_CYAN}[4/4] Kích hoạt cấu hình lưu trữ thiết bị...${C_RESET}"
echo "y" | termux-setup-storage

echo -e "\n${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
echo -e "${C_GREEN}          CÀI ĐẶT HOÀN TẤT VÀ FIX LỖI THÀNH CÔNG! ${C_RESET}"
echo -e "${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
echo -e "${C_CYAN}• Khởi chạy Tool ngay:${C_RESET} ${C_YELLOW}python bduyrjpremium.py${C_RESET}\n"
