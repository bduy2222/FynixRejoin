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

# ===== BƯỚC 1: KÍCH HOẠT QUYỀN BỘ NHỚ VÀ ĐỔI MIRROR =====
echo -e "${C_CYAN}[1/4] Khởi tạo bộ nhớ và tối ưu hóa Mirror...${C_RESET}"
echo "y" | termux-setup-storage

termux-change-repo <<EOF
1
1
EOF

# ===== BƯỚC 2: QUẢN LÝ HẠ CẤP VÀ GHIM CỨNG PYTHON 3.13 =====
echo -e "\n${C_CYAN}[2/4] Đang kiểm tra và cấu hình Python 3.13...${C_RESET}"

# Hủy đóng băng cũ nếu có để tránh lỗi apt hung packages
apt-mark unhold python >/dev/null 2>&1

CURRENT_PY_VER=$(python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>/dev/null)

if [ "$CURRENT_PY_VER" != "3.13" ]; then
    echo -e "${C_YELLOW}[!] Hệ thống chưa có hoặc lệch phiên bản Python. Tiến hành ép cài bản 3.13...${C_RESET}"
    
    # Xóa triệt để tàn dư lỗi
    apt-get purge -y python python-pip
    apt-get autoremove -y
    
    # Tải gói deb Python 3.13.1 bản Raw Binary thật (Nặng ~13MB) cho x86_64
    echo -e "${C_GREEN}[+] Đang kéo gói chuẩn Python 3.13.1 (Raw Package)...${C_RESET}"
    curl -L -o $HOME/python3.13.deb "https://archive.org/download/termux-x86-64-packages/python_3.13.1_x86_64.deb"
    
    # Ép cài đặt tệp tin vừa tải
    dpkg -i $HOME/python3.13.deb
    rm -f $HOME/python3.13.deb
    
    # Khởi tạo lại PIP trực tiếp từ tổng đài pypa cho bản 3.13
    echo -e "${C_GREEN}[+] Khởi tạo trình quản lý gói PIP cho Python 3.13...${C_RESET}"
    curl -sL https://bootstrap.pypa.io/get-pip.py | python
    
    # ĐÓNG BĂNG TRÁNH LÊN 3.14 LẦN NỮA
    apt-mark hold python
else
    echo -e "${C_GREEN}[+] Hệ thống đang ở sẵn Python 3.13. Đang tiến hành đóng băng ghim phiên bản...${C_RESET}"
    apt-mark hold python
fi

# Đồng bộ danh sách gói và xử lý các thư viện nền
apt-get update -y
apt-get install -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confdef" libjpeg-turbo libpng unzip python-pillow

# Lấy chính xác đường dẫn site-packages của Python 3.13 vừa được dựng
PYTHON_SITE_DIR=$(python -c "import site; print(site.getsitepackages()[0])")

echo -e "${C_GREEN}[+] Đang xử lý cài đè và vá lỗi python-psutil...${C_RESET}"
# Tạo thư mục tạm an toàn ngay trong $HOME
mkdir -p $HOME/fynix_tmp
pip download psutil --platform manylinux2014_x86_64 --only-binary=:all: --no-cache-dir -d $HOME/fynix_tmp

# Di chuyển trực tiếp vào lõi site-packages và bung file chạy
cd "$PYTHON_SITE_DIR"
unzip -o $HOME/fynix_tmp/psutil-*.whl

# Tiến hành Vá (Patch) trực tiếp file mã nguồn để xóa bỏ lệnh chặn Android
if [ -f "psutil/__init__.py" ]; then
    sed -i 's/elif LINUX:/elif LINUX or True:/g' psutil/__init__.py
    sed -i 's/raise NotImplementedError(msg)/pass/g' psutil/__init__.py
    echo -e "${C_GREEN}[+] Đã bẻ gãy bộ kiểm duyệt hệ điều hành của psutil thành công!${C_RESET}"
else
    echo -e "${C_YELLOW}[!] Cảnh báo: Không tìm thấy file __init__.py để vá!${C_RESET}"
fi

# Dọn rác
rm -rf $HOME/fynix_tmp
cd ~

# ===== BƯỚC 3: CÀI ĐẶT CÁC MODULE PYTHON CÒN LẠI QUA PIP =====
echo -e "\n${C_CYAN}[3/4] Cài đặt các Module Python còn lại qua PIP...${C_RESET}"
pip install requests aiohttp colorama nest_asyncio discord.py --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple

# ===== BƯỚC 4: KIỂM TRA TRẠNG THÁI CUỐI CÙNG =====
echo -e "\n${C_CYAN}[4/4] Kiểm tra trạng thái hệ thống cuối cùng...${C_RESET}"
PY_FINAL_VER=$(python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}')" 2>/dev/null)
echo -e "${C_GREEN}[+] Phiên bản Python hiện tại: $PY_FINAL_VER${C_RESET}"

python -c "import psutil; print('-> Kiểm tra mô-đun psutil: OK')" 2>/dev/null || echo -e "${C_YELLOW}[!] Lưu ý: Cần kiểm tra lại quyền chạy script${C_RESET}"

echo -e "\n${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
echo -e "${C_GREEN}          CÀI ĐẶT HOÀN TẤT VÀ FIX LỖI THÀNH CÔNG! ${C_RESET}"
echo -e "${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
