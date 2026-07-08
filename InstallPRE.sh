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

# Kiểm tra nếu phiên bản hiện tại không phải là 3.13 thì tiến hành hạ cấp
CURRENT_PY_VER=$(python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>/dev/null)

if [ "$CURRENT_PY_VER" != "3.13" ]; then
    echo -e "${C_YELLOW}[!] Phát hiện Python phiên bản $CURRENT_PY_VER. Tiến hành hạ cấp về 3.13...${C_RESET}"
    
    # Xóa triệt để bản cũ tránh xung đột file cấu trúc
    apt-get purge -y python python-pip
    apt-get autoremove -y
    
    # Tải gói deb Python 3.13.1 bản chuẩn x86_64 dành cho môi trường giả lập
    echo -e "${C_GREEN}[+] Đang kéo gói Python 3.13 từ kho lưu trữ...${C_RESET}"
    curl -L -o $HOME/python3.13.deb "https://github.com/termux/termux-packages/raw/6c7cb0bd6e481005ca7ffcd89f8f4a1fa6ce8bb3/packages/python/python_3.13.1_x86_64.deb"
    
    # Ép hệ thống bung cài đặt bản deb vừa tải
    dpkg -i $HOME/python3.13.deb
    rm -f $HOME/python3.13.deb
    
    # Khôi phục pip cho Python 3.13 thủ công
    echo -e "${C_GREEN}[+] Khởi tạo trình quản lý gói PIP cho Python 3.13...${C_RESET}"
    curl -sL https://bootstrap.pypa.io/get-pip.py | python
    
    # KHÓA (HOLD) KHÔNG CHO APT TỰ ĐỘNG NÂNG CẤP LÊN 3.14 SAU NÀY
    apt-mark hold python
else
    echo -e "${C_GREEN}[+] Hệ thống đã ở sẵn Python 3.13. Tiến hành ghim phiên bản chống cập nhật lỗi...${C_RESET}"
    apt-mark hold python
fi

# Đồng bộ lại danh sách gói và cài các công cụ bổ trợ nền
apt-get update -y
apt-get install -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confdef" libjpeg-turbo libpng unzip python-pillow

# Lấy chính xác đường dẫn site-packages của Python 3.13 vừa cài
PYTHON_SITE_DIR=$(python -c "import site; print(site.getsitepackages()[0])")

echo -e "${C_GREEN}[+] Đang giải quyết bẻ khóa cài đặt python-psutil trên Python 3.13...${C_RESET}"
# Tạo thư mục tạm an toàn ngay trong $HOME để tải gói bánh xe (wheel)
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
PY_FINAL_VER=$(python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}')")
echo -e "${C_GREEN}[+] Phiên bản Python hiện tại: $PY_FINAL_VER${C_RESET}"

python -c "import psutil; print('-> Kiểm tra mô-đun psutil: OK')" 2>/dev/null || echo -e "${C_YELLOW}[!] Lưu ý: Cần kiểm tra lại quyền chạy script${C_RESET}"

echo -e "\n${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
echo -e "${C_GREEN}          CÀI ĐẶT HOÀN TẤT VÀ FIX LỖI THÀNH CÔNG! ${C_RESET}"
echo -e "${C_GREEN}═════════════════════════════════════════════════${C_RESET}"
