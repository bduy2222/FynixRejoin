#!/data/data/com.termux/files/usr/bin/bash

export DEBIAN_FRONTEND=noninteractive
export FORCE_UNSAFE_CONFIGURE=1

# Ép hệ thống dùng cờ tối ưu hóa biên dịch cho Android để chống lỗi build wheel multidict/aiohttp
export CFLAGS="-O3 -Wno-implicit-function-declaration"
export LDFLAGS="-all-allow-shlib-undefined"

termux-wake-lock

sed -i 's|backend.termux.org|mirrors.tuna.tsinghua.edu.cn/termux|g' $PREFIX/etc/apt/sources.list

dpkg --configure -a
apt-get update -y -q
apt-get upgrade -y -q -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef"

if [ ! -d "$HOME/storage" ]; then
    am start -n com.termux/.app.PermissionCheckActivity > /dev/null 2>&1
    sleep 3
fi

pkg install -y termux-tools python clang make libffi openssl libjpeg-turbo libpng zlib freetype git cmake build-essential tsu libexpat ndk-sysroot --no-user-config

pip install --upgrade pip setuptools wheel --no-cache-dir

cd $HOME
rm -rf psutil
git clone --depth 1 https://github.com/giampaolo/psutil.git
cd psutil
sed -i 's/sys.platform.startswith("linux")/sys.platform.startswith(("linux", "android"))/g' psutil/_common.py
pip install . --no-cache-dir
cd $HOME
rm -rf psutil

# Cài đặt multidict trước với cờ tắt kiểm tra lỗi nghiêm ngặt để dọn đường cho aiohttp
pip install multidict yarl --no-build-isolation --no-cache-dir
pip install --prefer-binary --no-cache-dir aiohttp requests pytz pyjwt pycryptodome rich colorama flask pillow discord.py python-socketio prettytable
