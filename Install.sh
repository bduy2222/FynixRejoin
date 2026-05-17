#!/data/data/com.termux/files/usr/bin/bash

# Tự động nhả wake-lock khi xong hoặc lỗi
trap 'termux-wake-unlock' EXIT
termux-wake-lock

export DEBIAN_FRONTEND=noninteractive
export FORCE_UNSAFE_CONFIGURE=1

# Cập nhật hệ thống an toàn
pkg update -y -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef"

# Kiểm tra quyền bộ nhớ
if [ ! -d "$HOME/storage" ]; then
    termux-setup-storage
    echo "Vui lòng cấp quyền bộ nhớ trên màn hình, sau đó nhấn Enter..."
    read -r
fi

# ĐÃ SỬA: Xóa bỏ --no-user-config ở đây để tránh lỗi dừng script
pkg install -y python clang make libffi openssl libjpeg-turbo libpng zlib freetype git cmake build-essential tsu libexpat ndk-sysroot pkg-config libwebp

# Cập nhật pip
pip install --upgrade pip setuptools wheel --no-cache-dir

# Build psutil cho Android 10+
cd "$HOME" || exit
rm -rf psutil
git clone --depth 1 https://github.com/giampaolo/psutil.git
cd psutil || exit
sed -i 's/sys.platform.startswith("linux")/sys.platform.startswith(("linux", "android"))/g' psutil/_common.py
pip install . --no-cache-dir
cd "$HOME" || exit
rm -rf psutil

# Cài đặt các gói Python
export CFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"

pip install --prefer-binary --no-cache-dir \
    aiohttp \
    requests \
    pytz \
    pyjwt \
    pycryptodome \
    rich \
    colorama \
    flask \
    pillow \
    discord.py \
    python-socketio \
    prettytable

echo "=== CÀI ĐẶT THÀNH CÔNG ==="
