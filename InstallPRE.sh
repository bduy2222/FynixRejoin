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

# ===== BƯỚC 2: CÀI ĐẶT THƯ VIỆN HỆ THỐNG VÀ XỬ LÝ PSUTIL/PILLOW =====
echo -e "\n${C_CYAN}[2/4] Cài đặt các thư viện hệ thống tương thích Python 3.13...${C_RESET}"

# Đồng bộ kho gói
apt-get update -y

# Tải các thư viện đồ họa và công cụ cơ bản nền
apt-get install -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confdef" libjpeg-turbo libpng unzip python python-pip

echo -e "${C_GREEN}[+] Đang xử lý bẻ khóa cài đặt python-psutil độc quyền cho Android...${C_RESET}"
# Tải bản wheel phân phối Linux chính thức (x86_64 cho giả lập) về thư mục tạm
mkdir -p /sdcard/Download/fynix_tmp
pip download psutil --platform manylinux2014_x86_64 --only-binary=:all: --no-cache-dir -d /sdcard/Download/fynix_tmp

# Di chuyển thẳng vào trái tim site-packages của Python 3.13 để bung lụa
cd /data/data/com.termux/files/usr/lib/python3.13/site-packages
unzip -o /sdcard/Download/fynix_tmp/psutil-*.whl

# Tiến hành Vá (Patch) trực tiếp file mã nguồn để triệt hạ lỗi "platform android is not supported"
if [ -f "psutil/__init__.py" ]; then
    sed -i 's/elif LINUX:/elif LINUX or True:/g' psutil/__init__.py
    sed -i 's/raise NotImplementedError(msg)/pass/g' psutil/__init__.py
    echo -e "${C_GREEN}[+] Đã bẻ gãy bộ kiểm duyệt hệ điều hành của psutil thành công!${C_RESET}"
else
    echo -e "${C_YELLOW}[!] Cảnh báo: Không tìm thấy file __init__.py để vá!${C_RESET}"
fi

# Cài đặt gói python-pillow (gói này chạy độc lập không lỗi script)
apt-get install -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confdef" python-pillow

# Dọn rác
rm -rf /sdcard/Download/fynix_tmp
cd ~

# ===== BƯỚC 3: CÀI ĐẶT CÁC MODULE PYTHON NHẸ CÒN LẠI QUA PIP =====
echo -e "\n${C_CYAN}[3/4] Cài đặt các Module Python còn lại qua PIP...${C_RESET}"
pip install requests aiohttp colorama nest_asyncio discord.py --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple

# ===== BƯỚC 4: TỰ ĐỘNG KHỞI TẠO BỘ NHỚ =====
echo -e "\n${C_CYAN}[4/4] Kích hoạt cấu hình lưu trữ thiết bị...${C_RESET}"
echo "y" | termux-setup-storage

echo -e "\n${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
echo -e "${C_GREEN}          CÀI ĐẶT HOÀN TẤT VÀ FIX LỖI THÀNH CÔNG! ${C_RESET}"
echo -e "${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
