#!/data/data/com.termux/files/usr/bin/bash

echo "======================================"
echo "    FYNIX BARRICADE SETUP (FIXED)"
echo "======================================"

# 1. Cấp quyền truy cập bộ nhớ (Cần thiết để ghi vào /storage/emulated/0)
echo "[*] Requesting storage permissions..."
termux-setup-storage

# 2. ÉP BUỘC TẠO FILE CẤU HÌNH
echo "[*] Bypassing time-check..."
mkdir -p "$PREFIX/etc/apt/apt.conf.d"
echo 'Acquire::Check-Valid-Until "false";' > "$PREFIX/etc/apt/apt.conf.d/99no-check-valid"
echo 'Acquire::AllowInsecureRepositories "true";' >> "$PREFIX/etc/apt/apt.conf.d/99no-check-valid"

# 3. Xóa sạch cache apt
echo "[*] Cleaning APT cache..."
rm -rf "$PREFIX/var/lib/apt/lists/*"

# 4. Update
echo "[*] Updating packages..."
pkg update -y || echo "[!] Update warning, proceeding..."

# 5. Cài đặt các gói cốt lõi
echo "[*] Installing dependencies..."
pkg install -y python python-pip clang make libffi openssl libjpeg-turbo libpng zlib freetype git cmake build-essential tsu libexpat python-psutil

# 6. Cấu hình Pip và cài thư viện
echo "[*] Configuring Python & Libraries..."
python -m pip install --upgrade pip setuptools wheel
pip install --prefer-binary aiohttp requests pytz pyjwt pycryptodome rich colorama flask pillow discord.py python-socketio prettytable

# 7. Tải tool về thư mục Download gốc của Android
echo "[*] Downloading Fynix Tool..."
TARGET_DIR="/sdcard/Download"
# Kiểm tra nếu /sdcard không khả dụng thì dùng $HOME/storage/downloads
if [ ! -d "$TARGET_DIR" ]; then
    TARGET_DIR="$HOME/storage/downloads"
fi

OUTPUT_FILE="$TARGET_DIR/obf-bduyrjpremium.py"
TOOL_URL="https://raw.githubusercontent.com/bduy2222/FynixRejoin/refs/heads/main/obf-bduyrjpremium.py"

curl -L --retry 5 "$TOOL_URL" -o "$OUTPUT_FILE"
chmod +x "$OUTPUT_FILE"

echo ""
echo "======================================"
echo "      INSTALLATION COMPLETED!"
echo "======================================"
echo "File đã lưu tại: $OUTPUT_FILE"
echo "Chạy tool: python $OUTPUT_FILE"
