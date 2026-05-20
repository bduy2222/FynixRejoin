#!/data/data/com.termux/files/usr/bin/bash

export DEBIAN_FRONTEND=noninteractive
export FORCE_UNSAFE_CONFIGURE=1

export CFLAGS="-O2 -pipe -Wno-implicit-function-declaration -Wno-int-conversion"
export LDFLAGS="-Wl,--allow-shlib-undefined -L$PREFIX/lib"

export MULTIDICT_NO_EXTENSIONS=1
export YARL_NO_EXTENSIONS=1
export PYCRYPTODOME_DISABLE_EXTENSIONS=1
export AUDIOOP_LTS_SKIP_EXTENSIONS=1
export AIOHTTP_NO_EXTENSIONS=1
export PIP_ONLY_BINARY="pillow"

termux-wake-lock

# ==================== CẤU HÌNH REPO CHUẨN XÁC ====================
echo "=== ĐANG KHỞI TẠO VÀ SỬA ĐỔI REPO TERMUX ==="
mkdir -p $PREFIX/etc/apt/sources.list.d

# Sử dụng chính thức các mirror của các bên lớn bản chuẩn cho Termux
# Thử nghiệm tuần tự từ Mirror chính, Mirror Thượng Hải, đến Mirror Tsinghua
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

dpkg --configure -a
apt-get upgrade -y -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef"

# Cài đặt gói cơ bản
apt-get install -y termux-am termux-tools

# Tự động thêm repo TUR bản chuẩn (nếu cần)
echo "deb [trusted=yes] https://cyberasylum.org/apt/termux-tur tur main" > $PREFIX/etc/apt/sources.list.d/tur.list
apt-get update -y

# Kiểm tra cấp quyền bộ nhớ
if [ ! -d "$HOME/storage" ]; then
    am start -n com.termux/.app.PermissionCheckActivity > /dev/null 2>&1
    sleep 2
fi

# Cài đặt đồng loạt các công cụ cốt lõi
apt-get install -y -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" \
    python clang make libffi openssl libjpeg-turbo libpng zlib freetype git ndk-sysroot libwebp

# Nâng cấp Pip
pip install --upgrade pip setuptools wheel --no-cache-dir

# --- Sửa lỗi cài đặt psutil qua pip thay vì clone git lỗi ---
# Vì psutil đã hỗ trợ tốt, ta có thể cài trực tiếp từ pip hoặc qua repo nếu có sẵn
pip install psutil --no-cache-dir

# --- CÀI ĐẶT GÓI PYTHON ---
pip install --prefer-binary --no-cache-dir multidict yarl requests pytz pyjwt rich colorama flask python-socketio prettytable
pip install --prefer-binary --no-cache-dir pycryptodome pillow
pip install --prefer-binary --no-cache-dir audioop-lts aiohttp discord.py

# DỌN DẸP
apt-get clean
rm -rf ~/.cache/pip

echo "=== XỬ LÝ HOÀN TẤT & CÀI ĐẶT THÀNH CÔNG ==="
