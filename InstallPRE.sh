#!/data/data/com.termux/files/usr/bin/bash

set -e # Dừng ngay nếu có lệnh lỗi

echo "======================================"
echo "    FYNIX SETUP OPTIMIZED FOR CLOUD"
echo "======================================"

# 1. Update Repo
echo "[*] Updating repositories..."
pkg update -y && pkg upgrade -y

# 2. Cài đặt các gói cốt lõi (Gom thành 1 dòng để tránh lỗi xuống dòng)
echo "[*] Installing core packages..."
pkg install -y python git curl wget clang make openssl libffi zlib termux-tools tsu

# 3. Cấu hình pip và cài thư viện Python
echo "[*] Configuring Python..."
python -m ensurepip --upgrade
python -m pip install --upgrade pip setuptools wheel

# Chỉ cài những thứ thực sự cần thiết cho script của bạn
echo "[*] Installing dependencies..."
python -m pip install --no-cache-dir requests rich colorama

# 4. Tải tool
DOWNLOAD_DIR="$HOME/storage/downloads"
mkdir -p "$DOWNLOAD_DIR"
DOWNLOAD_URL="https://raw.githubusercontent.com/bduy2222/FynixRejoin/main/obf-bduyrjpremium.py"
OUTPUT_FILE="$DOWNLOAD_DIR/obf-bduyrjpremium.py"

echo "[*] Downloading Fynix Tool..."
curl -L --retry 5 "$DOWNLOAD_URL" -o "$OUTPUT_FILE"

# 5. Phân quyền
chmod +x "$OUTPUT_FILE"

echo ""
echo "======================================"
echo "      INSTALL COMPLETED SUCCESSFULLY"
echo "======================================"
echo "Chạy tool bằng lệnh:"
echo "python $OUTPUT_FILE"
