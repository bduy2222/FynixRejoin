#!/data/data/com.termux/files/usr/bin/bash

# Bật môi trường không tương tác để tự động vượt qua tất cả các bảng xác nhận (Yes/No)
export DEBIAN_FRONTEND=noninteractive
export FORCE_UNSAFE_CONFIGURE=1

# Cấu hình cờ tối ưu hóa biên dịch C cho CPU ảo x86_64 trên Cloudphone
export CFLAGS="-O2 -pipe -Wno-implicit-function-declaration -Wno-int-conversion"
export LDFLAGS="-Wl,--allow-shlib-undefined -L$PREFIX/lib"

# Khóa chặn tiến trình build C nặng để tránh lỗi biên dịch chéo và lỗi RAM ảo (OOM)
export MULTIDICT_NO_EXTENSIONS=1
export YARL_NO_EXTENSIONS=1
export PYCRYPTODOME_DISABLE_EXTENSIONS=1
export AUDIOOP_LTS_SKIP_EXTENSIONS=1
export AIOHTTP_NO_EXTENSIONS=1
export PIP_ONLY_BINARY="pillow"

termux-wake-lock

# ==================== TỰ ĐỘNG KHẢO SÁT & ĐỔI REPO THÔNG MẠNG ====================
echo "=== ĐANG TỰ ĐỘNG KHẢO SÁT VÀ KHÔI PHỤC KHO GÓI TERMUX ==="
mkdir -p $PREFIX/etc/apt/sources.list.d

# Cú pháp đường dẫn chuẩn xác 100% của các Mirror lớn tích hợp mạng lưới CDN
MIRRORS=(
    "https://sustech.edu.cn"
    "https://tsinghua.edu.cn"
    "https://grimler.se"
)

# Quét tìm máy chủ hoạt động, nếu một máy chủ chặn mạng hệ thống tự nhảy sang máy chủ khác
for mirror in "${MIRRORS[@]}"; do
    echo "deb $mirror stable main" > $PREFIX/etc/apt/sources.list
    echo "Đang thử nghiệm kết nối tới: $mirror"
    if apt-get update -y -q; then
        echo "==> KHỚP MẠNG THÀNH CÔNG VỚI REPO: $mirror"
        break
    fi
done
# ==================================================================================

# Đồng bộ gỡ lỗi cấu hình gói cũ và nâng cấp toàn diện hệ thống cốt lõi ban đầu
dpkg --configure -a
apt-get upgrade -y -q -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef"

# TỰ ĐỘNG KÍCH HOẠT KHO GÓI PHỤ TRỢ (TUR) - Để lấy bản dựng sẵn Pillow cho Python 3.13 trên x86_64
apt-get install -y -q termux-am
apt-get install -y -q tur-repo || pkg install -y tur-repo
apt-get update -y -q

# Kiểm tra và cấp quyền bộ nhớ mà không làm treo tiến trình chạy ngầm
if [ ! -d "$HOME/storage" ]; then
    am start -n com.termux/.app.PermissionCheckActivity > /dev/null 2>&1
    sleep 2
fi

# Cài đặt các gói biên dịch bắt buộc, bổ sung gói python-pillow dựng sẵn không lo sập
apt-get install -y -q -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" \
    termux-tools python clang make libffi openssl libjpeg-turbo libpng zlib freetype git ndk-sysroot libwebp python-pillow

# Nâng cấp công cụ quản lý thư viện Python lên bản mới nhất
pip install --upgrade pip setuptools wheel --no-cache-dir

# --- Build & cài đặt psutil tối ưu cho Android (ĐÃ ĐIỀN ĐƯỜNG LINK GIT ĐẦY ĐỦ PHẦN ĐUÔI) ---
cd $HOME && rm -rf psutil
git clone --depth 1 https://github.com
cd psutil
sed -i 's/sys.platform.startswith("linux")/sys.platform.startswith(("linux", "android"))/g' psutil/_common.py
pip install . --no-cache-dir
cd $HOME && rm -rf psutil

# --- CÀI ĐẶT GÓI PYTHON THEO CỤM TỐI ƯU HẠN CHẾ SẬP RAM ---
pip install --prefer-binary --no-cache-dir multidict yarl requests pytz pyjwt rich colorama flask python-socketio prettytable
pip install --prefer-binary --no-cache-dir pycryptodome
pip install --prefer-binary --no-cache-dir audioop-lts aiohttp discord.py

# DỌN DẸP HỆ THỐNG: Giải phóng dung lượng ổ đĩa lưu trữ cho Cloudphone
apt-get clean
rm -rf ~/.cache/pip

echo "=== ĐÃ TỰ ĐỘNG FIX TẤT CẢ LỖI & CÀI ĐẶT THÀNH CÔNG ==="
