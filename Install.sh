#!/data/data/com.termux/files/usr/bin/bash

export DEBIAN_FRONTEND=noninteractive
export FORCE_UNSAFE_CONFIGURE=1

# Tối ưu hóa cờ biên dịch C và tắt kiểm tra nghiêm ngặt cấu trúc lỗi trên Android
export CFLAGS="-O3 -Wno-implicit-function-declaration -Wno-int-conversion"
export LDFLAGS="-all-allow-shlib-undefined"

# Bỏ qua biên dịch extension C lỗi cho multidict và yarl trên Python 3.13
export MULTIDICT_NO_EXTENSIONS=1
export YARL_NO_EXTENSIONS=1

termux-wake-lock

# GIẢI PHÁP TĂNG TỐC: Xóa sạch danh sách nguồn cũ và ép Termux dùng Mirror Việt Nam (bởi Nguyen Hoang) có băng thông 1Gbps ổn định
echo "deb https://mirrors.nguyenhoang.cloud/termux/termux-main stable main" > $PREFIX/etc/apt/sources.list

dpkg --configure -a
apt-get update -y -q
apt-get upgrade -y -q -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef"

if [ ! -d "$HOME/storage" ]; then
    am start -n com.termux/.app.PermissionCheckActivity > /dev/null 2>&1
    sleep 3
fi

# Dùng apt-get cài đặt qua mirror mới sẽ nhanh hơn rất nhiều
apt-get install -y -q -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" termux-tools python clang make libffi openssl libjpeg-turbo libpng zlib freetype git cmake build-essential tsu libexpat ndk-sysroot libwebp

# Cập nhật pip và các công cụ đóng gói nền tảng lên bản mới nhất
pip install --upgrade pip setuptools wheel --no-cache-dir

# --- Build & cài đặt psutil tối ưu cho Android ---
cd $HOME
rm -rf psutil
git clone --depth 1 https://github.com
cd psutil
sed -i 's/sys.platform.startswith("linux")/sys.platform.startswith(("linux", "android"))/g' psutil/_common.py
pip install . --no-cache-dir
cd $HOME
rm -rf psutil

# --- Cài đặt gói Python thuần (Pure Python) ---
pip install multidict yarl --no-cache-dir

# Tách nhỏ quá trình cài đặt để giảm tải CPU/RAM cho Cloudphone
pip install --prefer-binary --no-cache-dir requests pytz pyjwt rich colorama flask python-socketio prettytable
pip install --prefer-binary --no-cache-dir pycryptodome pillow
pip install --prefer-binary --no-cache-dir aiohttp discord.py

echo "=== ĐÃ HOÀN THÀNH CÀI ĐẶT THÀNH CÔNG ==="
