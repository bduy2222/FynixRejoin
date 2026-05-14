#!/usr/bin/env bash

# Ép hệ thống bỏ qua lỗi định dạng dòng Windows nếu lỡ xảy ra khi nạp từ github
sed -i 's/\r$//' "$0" 2>/dev/null

# Xóa triệt để các cấu hình cũ để không bị bám vào mirror utermux lỗi
rm -rf $PREFIX/etc/termux/sources.list
rm -rf $PREFIX/etc/termux/sources.list.d/*

# Nạp thẳng danh sách các kho lưu trữ gốc từ Cloudflare (Chạy cực ổn định trên MuMu)
mkdir -p $PREFIX/etc/termux
echo "deb termux.dev stable main" > $PREFIX/etc/termux/sources.list

# Cấu hình cài đặt im lặng, tự động nhấn Enter và cập nhật danh sách gói mới
export DEBIAN_FRONTEND=noninteractive
pkg update -y -o Dpkg::Options::="--force-confold" --no-list-cleanup
pkg upgrade -y -o Dpkg::Options::="--force-confold"

# Cấp quyền lưu trữ cho Termux trên giả lập
echo "y" | termux-setup-storage

# Cài đặt toàn bộ công cụ nền và gói phụ thuộc đồ họa
pkg install -y python python-pip clang make libffi openssl libjpeg-turbo libpng zlib freetype git cmake build-essential tsu libexpat libtiff openjpeg -o Dpkg::Options::="--force-confold"

# Gỡ bỏ các thư viện cũ dễ gây xung đột tính toán
pip uninstall -y python-psutil psutil 2>/dev/null

# Khai báo đường dẫn hệ thống để trình biên dịch Python tìm thấy thư viện đồ họa của Termux
export LDFLAGS="-L${PREFIX}/lib"
export CFLAGS="-I${PREFIX}/include -Wno-error=implicit-function-declaration"

# Cập nhật môi trường lõi cho Pip
pip install --upgrade pip setuptools wheel

# Tiến hành cài đặt Pillow từ bản build nhị phân chuẩn cho cấu trúc máy tính x86_64
pip install --no-cache-dir --no-build-isolation --prefer-binary pillow

# Biên dịch Psutil trực tiếp để không bị lỗi Clang Compiler trên Termux mới
CFLAGS="-Wno-error=implicit-function-declaration" pip install --no-cache-dir psutil

# Cài đặt hàng loạt thư viện kết nối mạng và giao diện cho Tool Rejoin của bạn
pip install --prefer-binary requests pytz pyjwt pycryptodome rich colorama flask discord.py python-socketio prettytable
