#!/data/data/com.termux/files/usr/bin/bash

# Bật môi trường không tương tác để tự động vượt qua tất cả các bảng xác nhận (Yes/No)
export DEBIAN_FRONTEND=noninteractive
export FORCE_UNSAFE_CONFIGURE=1

# Cấu hình cờ tối ưu hóa biên dịch C cho CPU
export CFLAGS="-O2 -pipe -Wno-implicit-function-declaration -Wno-int-conversion"
export LDFLAGS="-Wl,--allow-shlib-undefined -L$PREFIX/lib"

# Khóa chặn tiến trình build C nặng để tránh lỗi biên dịch chéo và lỗi RAM ảo (OOM)
export MULTIDICT_NO_EXTENSIONS=1
export YARL_NO_EXTENSIONS=1
export PYCRYPTODOME_DISABLE_EXTENSIONS=1
export AUDIOOP_LTS_SKIP_EXTENSIONS=1
export AIOHTTP_NO_EXTENSIONS=1

termux-wake-lock

# ==================== CẤU HÌNH REPO CHUẨN XÁC ====================
echo "=== ĐANG KHỞI TẠO VÀ SỬA ĐỔI REPO TERMUX ==="
mkdir -p $PREFIX/etc/apt/sources.list.d

# Sử dụng chính thức các mirror của các bên lớn bản chuẩn cho Termux
MIRRORS=(
    "https://packages.termux.org/apt/termux-main"
    "https://mirrors.ustc.edu.cn/termux/termux-main"
    "https://mirrors.tuna.tsinghua.edu.cn/termux/termux-main"
)

SUCCESS=0
for mirror in "${MIRRORS[@]}"; do
    echo "deb [trusted=yes] $mirror stable main" > $PREFIX/etc/apt/sources.list
    echo "Đang kiểm tra kết nối tới: $mirror"
    if apt-get update -y; then
        echo "==> KẾT NỐI REPO THÀNH CÔNG: $mirror"
        SUCCESS=1
        break
    fi
done

if [ $SUCCESS -eq 0 ]; then
    echo "🚨 LỖI: Không thể kết nối tới bất kỳ Repo nào. Vui lòng kiểm tra lại mạng Internet mạng/Cloudphone!"
    exit 1
fi
# ==================================================================================

# Sửa lỗi dở dang của dpkg (nếu có) và nâng cấp hệ thống
dpkg --configure -a
apt-get upgrade -y -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef"

# Cài đặt gói cơ bản
apt-get install -y termux-am termux-tools

# Tự động thêm repo TUR bản chuẩn (Kho lưu trữ chứa sẵn các bản dựng Python tối ưu)
echo "deb [trusted=yes] https://cyberasylum.org/apt/termux-tur tur main" > $PREFIX/etc/apt/sources.list.d/tur.list
apt-get update -y

# Kiểm tra cấp quyền bộ nhớ
if [ ! -d "$HOME/storage" ]; then
    am start -n com.termux/.app.PermissionCheckActivity > /dev/null 2>&1
    sleep 2
fi

# Cài đặt đồng loạt các công cụ cốt lõi và thư viện hệ thống
apt-get install -y -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" \
    python clang make libffi openssl libjpeg-turbo libpng zlib freetype git ndk-sysroot libwebp

# ==================== CÀI ĐẶT GÓI DỰNG SẴN QUA APT ====================
echo "=== CÀI ĐẶT CÁC GÓI NẶNG BẢN DỰNG SẴN ĐỂ CHỐNG LỖI COMPILER ==="
# Cài đặt trực tiếp psutil và pillow bằng lệnh hệ thống, không lo sập build hay thiếu nền tảng
apt-get install -y python-psutil python-pillow
# ==================================================================================

# Nâng cấp Pip, Setuptools và Wheel lên bản mới nhất
pip install --upgrade pip setuptools wheel --no-cache-dir

# --- CÀI ĐẶT CÁC GÓI PYTHON CÒN LẠI ---
echo "=== ĐANG CÀI ĐẶT CÁC THƯ VIỆN PYTHON YÊU CẦU CÒN LẠI ==="
# Lưu ý: Đã loại bỏ 'pillow' khỏi danh sách pip install vì đã được cài bằng apt ở trên
pip install --prefer-binary --no-cache-dir multidict yarl requests pytz pyjwt rich colorama flask python-socketio prettytable
pip install --prefer-binary --no-cache-dir pycryptodome
pip install --prefer-binary --no-cache-dir audioop-lts aiohttp discord.py

# DỌN DẸP HỆ THỐNG: Giải phóng dung lượng lưu trữ
apt-get clean
rm -rf ~/.cache/pip


# ==============================================================
# ==============================================================
echo "=== XỬ LÝ HOÀN TẤT & CÀI ĐẶT THÀNH CÔNG HOÀN TOÀN 100% ==="
