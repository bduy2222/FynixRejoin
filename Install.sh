#!/data/data/com.termux/files/usr/bin/bash

# ==============================
# INIT
# ==============================
set -e

LOG_FILE="$HOME/fynix_install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

clear
echo "=== FYNIX INSTALLER ==="
echo ""

# ==============================
# ERROR HANDLER
# ==============================
error_exit() {
    echo ""
    echo "[ERROR] Installation failed!"
    echo "Check log: $LOG_FILE"
    exit 1
}

# ==============================
# FIX CRLF (🔥 cực quan trọng)
# ==============================
sed -i 's/\r$//' "$0" 2>/dev/null || true

# ==============================
# CHECK INTERNET
# ==============================
echo "[*] Checking internet..."
ping -c 1 google.com >/dev/null 2>&1 || error_exit

# ==============================
# REPO SETUP (SMART)
# ==============================
setup_repo() {
    echo "[*] Setting up repositories..."

    mirrors=(
        "https://packages-cf.termux.dev/apt/termux-main"
        "https://packages.termux.dev/apt/termux-main"
    )

    cp $PREFIX/etc/apt/sources.list $PREFIX/etc/apt/sources.list.bak 2>/dev/null || true

    for m in "${mirrors[@]}"; do
        echo "Trying: $m"

        echo "deb $m stable main" > $PREFIX/etc/apt/sources.list

        if pkg update -y >/dev/null 2>&1; then
            echo "[OK] Using $m"
            return 0
        fi
    done

    return 1
}

setup_repo || error_exit

# ==============================
# UPDATE SYSTEM
# ==============================
echo "[*] Updating system..."
pkg update -y || error_exit
pkg upgrade -y || error_exit

# ==============================
# STORAGE
# ==============================
echo "[*] Setting up storage..."
termux-setup-storage >/dev/null 2>&1 || true
sleep 2

# ==============================
# WAKE LOCK
# ==============================
command -v termux-wake-lock >/dev/null 2>&1 && termux-wake-lock

# ==============================
# INSTALL CORE
# ==============================
echo "[*] Installing core packages..."

pkg install -y \
python clang make libffi openssl \
libjpeg-turbo libpng zlib freetype git cmake \
libexpat rust tsu curl ncurses dos2unix \
|| error_exit

# ==============================
# FIX PIP
# ==============================
echo "[*] Updating pip..."
python -m pip install --upgrade pip setuptools wheel || error_exit

# ==============================
# INSTALL PYTHON LIBS
# ==============================
echo "[*] Installing python libraries..."

python -m pip install --prefer-binary \
requests pytz pyjwt pycryptodome rich colorama flask \
pillow discord.py python-socketio prettytable psutil \
|| error_exit

# ==============================
# DOWNLOAD TOOL (RETRY)
# ==============================
echo "[*] Downloading tool..."

cd ~/storage/downloads 2>/dev/null || cd ~ || error_exit

URL="https://raw.githubusercontent.com/bduy2222/FynixRejoin/refs/heads/main/obf-bduyrjpremium.py"

for i in {1..3}; do
    if curl -L -o obf-bduyrjpremium.py "$URL"; then
        break
    fi
    echo "[RETRY] Download failed... ($i)"
    sleep 2
done

[ -f obf-bduyrjpremium.py ] || error_exit

# ==============================
# DONE
# ==============================
echo ""
echo "[OK] Installed successfully"
echo ""

# ==============================
# RUN TOOL
# ==============================
export TERM=xterm-256color

echo "[*] Starting tool..."

if command -v tsu >/dev/null 2>&1; then
    tsu -c "cd ~/storage/downloads && python obf-bduyrjpremium.py"
else
    python obf-bduyrjpremium.py
fi