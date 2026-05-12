#!/data/data/com.termux/files/usr/bin/bash

# 1. Cập nhật hệ thống và cài đặt các công cụ build cơ bản
yes | pkg update && yes | pkg upgrade -y
echo "y" | termux-setup-storage
yes | pkg install -y python python-pip clang make libffi libffi-dev openssl openssl-dev libjpeg-turbo libpng zlib freetype git cmake build-essential tsu libexpat python-dev

# 2. Nâng cấp các công cụ quản lý gói của Python
pip install --upgrade pip setuptools wheel

# 3. Fix lỗi "Platform not supported" của psutil bằng cách sửa mã nguồn trực tiếp
echo "Fixing psutil for Android..."
cd $HOME
rm -rf psutil # Xóa bản cũ nếu có
git clone https://github.com/giampaolo/psutil.git
cd psutil
# Lệnh sed này sửa file để psutil nhận diện môi trường Android là hợp lệ
sed -i 's/sys.platform.startswith("linux")/sys.platform.startswith(("linux", "android"))/g' psutil/_common.py
pip install .
cd $HOME

# 4. Cài đặt aiohttp và các thư viện còn lại
# Đã bao gồm các thư viện bạn yêu cầu từ lệnh trước
pip install --prefer-binary aiohttp requests pytz pyjwt pycryptodome rich colorama flask pillow discord.py python-socketio prettytable

echo "--- SETUP HOÀN TẤT ---"
