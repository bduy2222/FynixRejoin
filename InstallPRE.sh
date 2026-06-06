#!/data/data/com.termux/files/usr/bin/bash

echo "=========================================="
echo "      FORCE INSTALLATION - NO APT"
echo "=========================================="

# 1. Bỏ qua hoàn toàn việc update hệ thống
echo "[*] Skipping APT update (Time lock bypass)..."

# 2. Cài đặt Python và Pip bằng cách dùng tệp nhị phân có sẵn (nếu có)
# hoặc thử tải trực tiếp các gói cần thiết bằng lệnh curl
if ! command -v python &> /dev/null; then
    echo "[*] Python not found, trying to install..."
    # Cố gắng cài không thông qua update hệ thống
    pkg install python -y || echo "[!] APT failed, assuming python exists or environment is restricted."
fi

# 3. Cấu hình Pip trực tiếp (Không phụ thuộc vào apt)
echo "[*] Configuring pip..."
python -m ensurepip --upgrade
python -m pip install --upgrade pip setuptools wheel

# 4. Cài đặt thư viện Python (Đây là phần quan trọng nhất)
echo "[*] Installing required libraries..."
python -m pip install --no-cache-dir requests rich colorama

# 5. Tải tool
echo "[*] Downloading Fynix Tool..."
DOWNLOAD_DIR="$HOME/storage/downloads"
mkdir -p "$DOWNLOAD_DIR"
OUTPUT_FILE="$DOWNLOAD_DIR/obf-bduyrjpremium.py"

curl -L -o "$OUTPUT_FILE" https://raw.githubusercontent.com/bduy2222/FynixRejoin/main/obf-bduyrjpremium.py

if [ -f "$OUTPUT_FILE" ]; then
    chmod +x "$OUTPUT_FILE"
    echo "=========================================="
    echo "      INSTALL SUCCESSFUL!"
    echo "=========================================="
    echo "Chạy tool: python $OUTPUT_FILE"
else
    echo "[ERROR] Tải file thất bại."
fi
