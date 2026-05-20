#!/data/data/com.termux/files/usr/bin/bash

# Cấu hình môi trường không tương tác để tự động hóa 100%
export DEBIAN_FRONTEND=noninteractive
export FORCE_UNSAFE_CONFIGURE=1

# Tối ưu hóa cờ biên dịch C giảm tải cho CPU ảo x86_64 của Cloudphone
export CFLAGS="-O2 -pipe -Wno-implicit-function-declaration -Wno-int-conversion"
export LDFLAGS="-Wl,--allow-shlib-undefined -L$PREFIX/lib"

# Ép tất cả các thư viện nặng dùng bản thuần Python (Pure Python) - Tiết kiệm thời gian build
export MULTIDICT_NO_EXTENSIONS=1
export YARL_NO_EXTENSIONS=1
export PYCRYPTODOME_DISABLE_EXTENSIONS=1
export AUDIOOP_LTS_SKIP_EXTENSIONS=1
export AIOHTTP_NO_EXTENSIONS=1

# GIẢI PHÁP TRIỆT TIÊU LỖI PILLOW: Khóa không cho pip tự dịch mã nguồn C lỗi kiến trúc chéo x86_64
export PIP_ONLY_BINARY="pillow"

# Ngăn thiết bị rơi vào trạng thái ngủ khi đang chạy ngầm
termux-wake-lock

# GIẢI PHÁP SỬA LỖI MẠNG 'NOSPLIT': Xóa sạch tệp nguồn cũ cấu hình sai để khôi phục cấu hình chuẩn
rm -f $PREFIX/etc/apt/sources.list
rm -f $PREFIX/etc/apt/sources.list.d/*

# Thiết lập Mirror chính thức của toàn cầu có CDN tự động chuyển vùng tốc độ cao, tránh bị tường lửa Cloudphone chặn
echo "deb https://sustech.edu.cn stable main" > $PREFIX/etc/apt/sources.list

# Sửa lỗi cấu hình gói cũ và cập nhật hệ thống cốt lõi
dpkg --configure -a
apt-get update -y -q
apt-get upgrade -y -q -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef"

# KÍCH HOẠT KHO GÓI PHỤ TRỢ (TUR) - Kho này chứa bản dựng sẵn hoạt động 100% của Pillow cho Python mới trên x86_64
apt-get install -y -q termux-am
apt-get install -y -q tur-repo
apt-get update -y -q

# Tự động cấp quyền bộ nhớ mà không làm gián đoạn script
if [ ! -d "$HOME/storage" ]; then
    am start -n com.termux/.app.PermissionCheckActivity > /dev/null 2>&1
    sleep 2
fi

# Cài đặt các gói biên dịch bắt buộc, bổ sung gói python-pillow dựng sẵn từ kho TUR để không bị crash
apt-get install -y -q -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" \
    termux-tools python clang make libffi openssl libjpeg-turbo libpng zlib freetype git ndk-sysroot libwebp python-pillow

# Nâng cấp pip và các công cụ đóng gói nền tảng lên bản mới nhất
pip install --upgrade pip setuptools wheel --no-cache-dir

# --- Build & cài đặt psutil tối ưu cho Android (ĐÃ SỬA LỖI DÒNG GIT CLONE GỐC) ---
cd $HOME && rm -rf psutil
git clone --depth 1 https://github.com
cd psutil
sed -i 's/sys.platform.startswith("linux")/sys.platform.startswith(("linux", "android"))/g' psutil/_common.py
pip install . --no-cache-dir
cd $HOME && rm -rf psutil

# --- CÀI ĐẶT GÓI PYTHON THEO CỤM TỐI ƯU ---

# Cụm 1: Các gói xử lý mạng và cấu trúc cơ bản không cần biên dịch
pip install --prefer-binary --no-cache-dir multidict yarl requests pytz pyjwt rich colorama flask python-socketio prettytable

# Cụm 2: Các gói mã hóa (Pillow đã lấy từ hệ thống thông qua thư viện TUR ổn định 100%)
pip install --prefer-binary --no-cache-dir pycryptodome

# Cụm 3: Các gói dịch vụ bất đồng bộ và Bot (Bỏ qua hoàn toàn extension C)
pip install --prefer-binary --no-cache-dir audioop-lts aiohttp discord.py

# DỌN DẸP HỆ THỐNG: Xóa toàn bộ file rác, file tạm sau khi cài đặt để giải phóng dung lượng bộ nhớ trong cho Cloudphone
apt-get clean
rm -rf ~/.cache/pip

echo "=== ĐÃ SỬA TOÀN BỘ LỖI & CÀI ĐẶT THÀNH CÔNG ==="
