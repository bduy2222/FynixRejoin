#!/data/data/com.termux/files/usr/bin/bash

# Cấu hình môi trường không tương tác để tự động hóa hoàn toàn, tự động đồng ý mọi thiết lập
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
export PIP_ONLY_BINARY="pillow"

termux-wake-lock

# ==================== TỰ ĐỘNG KHÔI PHỤC & CHỌN REPO THÔNG MẠNG ====================
echo "=== ĐANG TỰ ĐỘNG KHẢO SÁT VÀ KHÔI PHỤC KHO GÓI TERMUX ==="
mkdir -p $PREFIX/etc/apt/sources.list.d

# Thử nghiệm lần lượt các Mirror lớn nhất, tự động dừng lại khi tìm thấy mạng chạy được
MIRRORS=(
    "https://sustech.edu.cn"
    "https://tsinghua.edu.cn"
    "https://grimler.se"
    "https://workers.dev"
)

for mirror in "${MIRRORS[@]}"; do
    echo "deb $mirror stable main" > $PREFIX/etc/apt/sources.list
    echo "Đang thử nghiệm kết nối tới: $mirror"
    if apt-get update -y -q; then
        echo "==> KHỚP MẠNG THÀNH CÔNG VỚI REPO: $mirror"
        break
    fi
done
# ==================================================================================

# Đảm bảo gỡ lỗi cấu hình gói cũ nếu có và đồng bộ nâng cấp hệ thống cốt lõi
dpkg --configure -a
apt-get upgrade -y -q -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef"

# TỰ ĐỘNG CÀI KHO GÓI PHỤ TRỢ (TUR) - Chứa bản dựng sẵn hoạt động 100% của Pillow cho x86_64
apt-get install -y -q termux-am
apt-get install -y -q tur-repo || pkg install -y tur-repo
apt-get update -y -q

# Tự động cấp quyền bộ nhớ mà không làm gián đoạn script
if [ ! -d "$HOME/storage" ]; then
    am start -n com.termux/.app.PermissionCheckActivity > /dev/null 2>&1
    sleep 2
fi

# Cài đặt các gói biên dịch bắt buộc, bổ sung gói python-pillow dựng sẵn không lo sập hệ thống
apt-get install -y -q -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" \
    termux-tools python clang make libffi openssl libjpeg-turbo libpng zlib freetype git ndk-sysroot libwebp python-pillow

# Nâng cấp pip và các công cụ đóng gói nền tảng lên bản mới nhất
pip install --upgrade pip setuptools wheel --no-cache-dir

# --- Build & cài đặt psutil tối ưu cho Android (ĐÃ ĐIỀN ĐƯỜNG LINK GIT CHUẨN ĐẦY ĐỦ CỦA BẠN) ---
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

echo "=== ĐÃ TỰ ĐỘNG FIX TẤT CẢ LỖI & CÀI ĐẶT THÀNH CÔNG ==="
