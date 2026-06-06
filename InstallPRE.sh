#!/data/data/com.termux/files/usr/bin/bash

# Không dùng set -e ở bước đầu để tránh bị dừng do lỗi mirror
echo "======================================"
echo "    FYNIX BARRICADE SETUP (FIXED)"
echo "======================================"

# 1. ÉP BUỘC TẠO FILE CẤU HÌNH TRƯỚC TIÊN
echo "[*] Bypassing time-check..."
mkdir -p "$PREFIX/etc/apt/apt.conf.d"
echo 'Acquire::Check-Valid-Until "false";' > "$PREFIX/etc/apt/apt.conf.d/99no-check-valid"
echo 'Acquire::AllowInsecureRepositories "true";' >> "$PREFIX/etc/apt/apt.conf.d/99no-check-valid"

# 2. Xóa sạch cache apt cũ để buộc nó đọc file cấu hình mới
echo "[*] Cleaning APT cache..."
rm -rf "$PREFIX/var/lib/apt/lists/*"

# 3. Update mà KHÔNG dùng termux-change-repo (để tránh ghi đè cấu hình)
echo "[*] Updating packages..."
pkg update -y || echo "[!] Update warning, proceeding..."

# 4. Cài đặt các gói cốt lõi
echo "[*] Installing dependencies..."
pkg install -y python python-pip clang make libffi openssl libjpeg-turbo libpng zlib freetype git cmake build-essential tsu libexpat python-psutil

# 5. Cấu hình Pip và cài thư viện
echo "[*] Configuring Python & Libraries..."
python -m pip install --upgrade pip setuptools wheel
pip install --prefer-binary aiohttp requests pytz pyjwt pycryptodome rich colorama flask pillow discord.py python-socketio prettytable

# 6. Tải tool
echo "[*] Downloading Fynix Tool..."
mkdir -p "$HOME/storage/downloads"
TOOL_URL="https://raw.githubusercontent.com/bduy2222/FynixRejoin/refs/heads/main/obf-bduyrjpremium.py"
OUTPUT_FILE="$HOME/storage/downloads/obf-bduyrjpremium.py"

curl -L --retry 5 "$TOOL_URL" -o "$OUTPUT_FILE"
chmod +x "$OUTPUT_FILE"

echo ""
echo "======================================"
echo "      INSTALLATION COMPLETED!"
echo "======================================"
echo "Chạy tool: python $OUTPUT_FILE"
