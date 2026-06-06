#!/data/data/com.termux/files/usr/bin/bash

set -e

echo "======================================"
echo "    FYNIX SETUP (TIME-FIXED VERSION)"
echo "======================================"

# 1. Bỏ qua kiểm tra thời gian của apt để fix lỗi "not valid yet"
echo "[*] Fixing time validation error..."
mkdir -p "$PREFIX/etc/apt/apt.conf.d"
echo 'Acquire::Check-Valid-Until "false";' > "$PREFIX/etc/apt/apt.conf.d/99no-check-valid"

# 2. Update Repo
echo "[*] Updating repositories..."
pkg update -y && pkg upgrade -y

# 3. Cài đặt các gói cốt lõi
echo "[*] Installing core packages..."
pkg install -y python git curl wget clang make openssl libffi zlib termux-tools tsu

# 4. Cấu hình pip và cài thư viện Python
echo "[*] Configuring Python..."
python -m ensurepip --upgrade
python -m pip install --upgrade pip setuptools wheel

echo "[*] Installing dependencies..."
python -m pip install --no-cache-dir requests rich colorama

# 5. Tải tool
DOWNLOAD_DIR="$HOME/storage/downloads"
mkdir -p "$DOWNLOAD_DIR"
DOWNLOAD_URL="https://raw.githubusercontent.com/bduy2222/FynixRejoin/main/obf-bduyrjpremium.py"
OUTPUT_FILE="$DOWNLOAD_DIR/obf-bduyrjpremium.py"

echo "[*] Downloading Fynix Tool..."
curl -L --retry 5 "$DOWNLOAD_URL" -o "$OUTPUT_FILE"

# 6. Phân quyền
chmod +x "$OUTPUT_FILE"

echo ""
echo "======================================"
echo "      INSTALL COMPLETED SUCCESSFULLY"
echo "======================================"
echo "Chạy tool bằng lệnh:"
echo "python $OUTPUT_FILE"
