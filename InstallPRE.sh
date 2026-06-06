#!/data/data/com.termux/files/usr/bin/bash

echo "=========================================="
echo "   FYNIX INSTALLER - ROBUST VERSION"
echo "=========================================="

# 1. Tự động tạo cấu hình vượt lỗi thời gian (APT FIX)
echo "[*] Applying APT time-sync bypass..."
mkdir -p "$PREFIX/etc/apt/apt.conf.d"
cat > "$PREFIX/etc/apt/apt.conf.d/99no-check-valid" << EOF
Acquire::Check-Valid-Until "false";
Acquire::AllowInsecureRepositories "true";
EOF

# 2. Dọn dẹp cache cũ và cập nhật
echo "[*] Cleaning cache and updating..."
rm -rf "$PREFIX/var/lib/apt/lists/*"
pkg update -y || { echo "[ERROR] Update failed, check network."; exit 1; }

# 3. Cài đặt các gói cốt lõi
echo "[*] Installing core dependencies..."
pkg install -y python git curl wget clang make openssl libffi zlib termux-tools tsu

# 4. Cấu hình Python Pip
echo "[*] Configuring Python pip..."
python -m ensurepip --upgrade
python -m pip install --upgrade pip setuptools wheel

# 5. Cài đặt thư viện Python cần thiết
echo "[*] Installing Python libraries..."
python -m pip install --no-cache-dir requests rich colorama

# 6. Tải Tool
echo "[*] Downloading Fynix Tool..."
DOWNLOAD_DIR="$HOME/storage/downloads"
mkdir -p "$DOWNLOAD_DIR"
OUTPUT_FILE="$DOWNLOAD_DIR/obf-bduyrjpremium.py"

curl -L -o "$OUTPUT_FILE" https://raw.githubusercontent.com/bduy2222/FynixRejoin/main/obf-bduyrjpremium.py

if [ -f "$OUTPUT_FILE" ]; then
    chmod +x "$OUTPUT_FILE"
    echo ""
    echo "=========================================="
    echo "      INSTALLATION COMPLETED!"
    echo "=========================================="
    echo "Để chạy tool, sử dụng lệnh:"
    echo "python $OUTPUT_FILE"
else
    echo "[ERROR] Download failed. Please check your internet connection."
fi
