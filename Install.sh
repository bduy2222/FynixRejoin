#!/data/data/com.termux/files/usr/bin/bash

# Thêm trap để tự động nhả wake-lock nếu script bị lỗi hoặc dừng giữa chừng
trap 'termux-wake-unlock' EXIT
termux-wake-lock

export DEBIAN_FRONTEND=noninteractive
export FORCE_UNSAFE_CONFIGURE=1

# Cập nhật repo và hệ thống một cách an toàn
pkg update -y -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef"

# Kiểm tra và yêu cầu quyền truy cập bộ nhớ (sẽ hiển thị pop-up trên điện thoại)
if [ ! -d "$HOME/storage" ]; then
    termux-setup-storage
    echo "Vui lòng cấp quyền bộ nhớ trên màn hình điện thoại, sau đó nhấn Enter để tiếp tục..."
    read -r
fi

# Cài đặt các gói phụ thuộc hệ thống (Thêm pkg-config và libwebp cho Pillow)
pkg install -y python clang make libffi openssl libjpeg-turbo libpng zlib freetype git cmake build-essential tsu libexpat ndk-sysroot pkg-config libwebp --no-user-config

# Cập nhật công cụ build cho Python
pip install --upgrade pip setuptools wheel --no-cache-dir

# Cài đặt và fix lỗi psutil trên Termux Android 10+
cd "$HOME" || exit
rm -rf psutil
git clone --depth 1 https://github.com/giampaolo/psutil.git
cd psutil || exit
# Sửa dòng kiểm tra nền tảng để nhận diện Android
sed -i 's/sys.platform.startswith("linux")/sys.platform.startswith(("linux", "android"))/g' psutil/_common.py
pip install . --no-cache-dir
cd "$HOME" || exit
rm -rf psutil

# Cài đặt các thư viện Python cần thiết
# Thêm các biến môi trường để hỗ trợ Pillow biên dịch đúng các thư viện ảnh vừa cài
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


