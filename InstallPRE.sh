#!/data/data/com.termux/files/usr/bin/bash

set -e

echo "======================================"
echo "    FYNIX AUTO-SETUP FOR CLOUD"
echo "======================================"

# 1. Fix lỗi thời gian và cấu hình APT
echo "[*] Configuring APT for environment..."
mkdir -p "$PREFIX/etc/apt/apt.conf.d"
echo 'Acquire::Check-Valid-Until "false";' > "$PREFIX/etc/apt/apt.conf.d/99no-check-valid"
echo 'Acquire::AllowInsecureRepositories "true";' >> "$PREFIX/etc/apt/apt.conf.d/99no-check-valid"

# 2. Tự động chọn mirror tốt nhất
echo "[*] Selecting fastest mirror..."
yes | termux-change-repo || echo "[!] Skip mirror selection."

# 3. Update & Cài đặt gói (Dùng python-psutil từ kho)
echo "[*] Installing dependencies..."
pkg update -y
pkg upgrade -y
pkg install -y python python-pip clang make libffi openssl libjpeg-turbo libpng zlib freetype git cmake build-essential tsu libexpat python-psutil

# 4. Config Pip
echo "[*] Configuring Python environment..."
python -m pip install --upgrade pip setuptools wheel

# 5. Cài đặt các thư viện cần thiết
echo "[*] Installing requirements..."
pip install --prefer-binary aiohttp requests pytz pyjwt pycryptodome rich colorama flask pillow discord.py python-socketio prettytable

# 6. Tải tool từ GitHub
DOWNLOAD_DIR="$HOME/storage/downloads"
mkdir -p "$DOWNLOAD_DIR"
TOOL_URL="https://raw.githubusercontent.com/bduy2222/FynixRejoin/refs/heads/main/obf-bduyrjpremium.py"
OUTPUT_FILE="$DOWNLOAD_DIR/obf-bduyrjpremium.py"

echo "[*] Downloading Fynix Tool..."
curl -L --retry 5 "$TOOL_URL" -o "$OUTPUT_FILE"
chmod +x "$OUTPUT_FILE"

echo ""
echo "======================================"
echo "      INSTALLATION COMPLETED!"
echo "======================================"
echo "File lưu tại: $OUTPUT_FILE"
echo "Chạy tool: python $OUTPUT_FILE"
