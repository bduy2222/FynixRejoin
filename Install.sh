#!/data/data/com.termux/files/usr/bin/bash

# Cấu hình môi trường không tương tác để tự động hóa 100%
export DEBIAN_FRONTEND=noninteractive
export FORCE_UNSAFE_CONFIGURE=1

# Tối ưu hóa cờ biên dịch C giảm tải cho CPU ảo x86_64
export CFLAGS="-O2 -pipe -Wno-implicit-function-declaration -Wno-int-conversion"

# GIẢI PHÁP SỬA LỖI PILLOW: Ép trình liên kết loại bỏ hoàn toàn các thư viện hệ thống ARM (/system/lib) gây xung đột kiến trúc x86_64
export LDFLAGS="-Wl,--allow-shlib-undefined -L$PREFIX/lib"

# Ép tất cả các thư viện nặng dùng bản thuần Python (Pure Python) - Tiết kiệm thời gian build
export MULTIDICT_NO_EXTENSIONS=1
export YARL_NO_EXTENSIONS=1
export PYCRYPTODOME_DISABLE_EXTENSIONS=1
export AUDIOOP_LTS_SKIP_EXTENSIONS=1
export AIOHTTP_NO_EXTENSIONS=1

# Ngăn thiết bị rơi vào trạng thái ngủ khi đang chạy ngầm
termux-wake-lock

# CẤU HÌNH LẠI MIRROR CHUẨN: Đường dẫn repo đầy đủ cho Termux chính thức
echo "deb https://sustech.edu.cn stable main" > $PREFIX/etc/apt/sources.list

# Sửa lỗi gói và cập nhật hệ thống cốt lõi
dpkg --configure -a
apt-get update -y -q
apt-get upgrade -y -q -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef"

# Tự động cấp quyền bộ nhớ mà không làm gián đoạn script
if [ ! -d "$HOME/storage" ]; then
    am start -n com.termux/.app.PermissionCheckActivity > /dev/null 2>&1
    sleep 2
fi

# Cài đặt các gói biên dịch bắt buộc, bổ sung thêm libandroid-posix-semaphore chống lỗi build nền tảng
apt-get install -y -q -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" \
    termux-tools python clang make libffi openssl libjpeg-turbo libpng zlib freetype git ndk-sysroot libwebp

# Nâng cấp pip và ép thiết lập cấu hình đóng gói tăng tốc cài đặt
pip install --upgrade pip setuptools wheel --no-cache-dir

# --- Build & cài đặt psutil tối ưu cho Android (ĐÃ SỬA LỖI LINK GIT ĐẦY ĐỦ) ---
cd $HOME && rm -rf psutil
git clone --depth 1 https://github.com
cd psutil
sed -i 's/sys.platform.startswith("linux")/sys.platform.startswith(("linux", "android"))/g' psutil/_common.py
pip install . --no-cache-dir
cd $HOME && rm -rf psutil

# --- CÀI ĐẶT GÓI PYTHON THEO CỤM TỐI ƯU ---

# Cụm 1: Các gói xử lý mạng và cấu trúc cơ bản không cần biên dịch
pip install --prefer-binary --no-cache-dir multidict yarl requests pytz pyjwt rich colorama flask python-socketio prettytable

# Cụm 2: Các gói mã hóa và xử lý hình ảnh (Sử dụng LDFLAGS đã dọn dẹp biến ARM phía trên)
pip install --prefer-binary --no-cache-dir pycryptodome pillow

# Cụm 3: Các gói dịch vụ bất đồng bộ và Bot (Bỏ qua hoàn toàn extension C)
pip install --prefer-binary --no-cache-dir audioop-lts aiohttp discord.py

# DỌN DẸP HỆ THỐNG: Xóa toàn bộ file rác, file tạm sau khi cài đặt để giải phóng dung lượng bộ nhớ trong
apt-get clean
rm -rf ~/.cache/pip

echo "=== ĐÃ SỬA LỖI & CÀI ĐẶT THÀNH CÔNG ==="
