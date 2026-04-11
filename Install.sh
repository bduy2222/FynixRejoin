#!/data/data/com.termux/files/usr/bin/bash

LOG_FILE="$HOME/fynix_install.log"
exec > "$LOG_FILE" 2>&1

clear
echo "Fynix Installer..."

error_exit() {
    echo ""
    echo "[ERROR] Installation failed!"
    echo "Check log: $LOG_FILE"
    exit 1
}
# ==============================
# REPO SETUP (PRO)
# ==============================
setup_repo() {
    echo "[*] Setting up repositories..."

    # ===== BACKUP =====
    cp $PREFIX/etc/apt/sources.list $PREFIX/etc/apt/sources.list.bak 2>/dev/null

    # ===== MAIN REPO (ỔN ĐỊNH NHẤT) =====
    echo "deb https://packages-cf.termux.dev/apt/termux-main stable main" > $PREFIX/etc/apt/sources.list

    # ===== X11 (OPTIONAL) =====
    mkdir -p $PREFIX/etc/apt/sources.list.d
    echo "deb https://packages-cf.termux.dev/apt/termux-x11 x11 main" > $PREFIX/etc/apt/sources.list.d/x11.list

    # ===== UPDATE =====
    pkg update -y >/dev/null 2>&1 || return 1

    echo "[OK] Repo configured"
    return 0
}

setup_repo || error_exit

pkg update -y >/dev/null 2>&1 || error_exit
pkg upgrade -y >/dev/null 2>&1 || error_exit

termux-setup-storage >/dev/null 2>&1
sleep 2

command -v termux-wake-lock >/dev/null 2>&1 && termux-wake-lock

pkg install -y python clang make libffi openssl \
libjpeg-turbo libpng zlib freetype git cmake \
libexpat rust tsu >/dev/null 2>&1 || error_exit

python -m pip install --upgrade pip setuptools wheel >/dev/null 2>&1 || error_exit

python -m pip install --prefer-binary \
requests pytz pyjwt pycryptodome rich colorama flask \
pillow discord.py python-socketio prettytable psutil \
>/dev/null 2>&1 || error_exit

cd ~/storage/downloads 2>/dev/null || cd ~ || error_exit

curl -L -o fynix.py \
https://raw.githubusercontent.com/bduy2222/FynixRejoin/refs/heads/main/obf-bduyrjpremium.py \
>/dev/null 2>&1 || error_exit

echo "[OK] Installed successfully"

export TERM=xterm-256color

if command -v tsu >/dev/null 2>&1; then
    tsu -c "cd ~/storage/downloads && python obf-bduyrjpremium.py"
else
    python fynix.py
fi