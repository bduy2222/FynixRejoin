#!/data/data/com.termux/files/usr/bin/bash

# ==============================
# CONFIG
# ==============================
LOG_FILE="$HOME/fynix_install.log"
exec > "$LOG_FILE" 2>&1

clear
echo "Fynix Installer..."

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
# CHANGE REPO
# ==============================
termux-change-repo <<EOF >/dev/null 2>&1
1
EOF || error_exit

# ==============================
# UPDATE
# ==============================
pkg update -y >/dev/null 2>&1 || error_exit
pkg upgrade -y >/dev/null 2>&1 || error_exit

# ==============================
# STORAGE
# ==============================
termux-setup-storage >/dev/null 2>&1
sleep 2

# ==============================
# WAKELOCK
# ==============================
command -v termux-wake-lock >/dev/null 2>&1 && termux-wake-lock

# ==============================
# INSTALL CORE
# ==============================
pkg install -y python clang make libffi openssl \
libjpeg-turbo libpng zlib freetype git cmake \
libexpat rust tsu >/dev/null 2>&1 || error_exit

# ==============================
# PIP FIX
# ==============================
python -m pip install --upgrade pip setuptools wheel >/dev/null 2>&1 || error_exit

# ==============================
# PYTHON LIBS
# ==============================
pip install --prefer-binary \
requests pytz pyjwt pycryptodome rich colorama flask \
pillow discord.py python-socketio prettytable psutil \
>/dev/null 2>&1 || error_exit

# ==============================
# DOWNLOAD TOOL
# ==============================
cd ~/storage/downloads || error_exit

curl -L -o fynix.py \
https://raw.githubusercontent.com/bduy2222/FynixRejoin/refs/heads/main/obf-bduyrjpremium.py \
>/dev/null 2>&1 || error_exit

# ==============================
# DONE
# ==============================
echo "[OK] Installed successfully"

# ==============================
# RUN TOOL (AUTO ROOT)
# ==============================
export TERM=xterm-256color

tsu -c "cd ~/storage/downloads && python obf-bduyrjpremium.py"
