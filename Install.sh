#!/data/data/com.termux/files/usr/bin/bash

clear
echo "======================================"
echo "        FYNIX REJOIN INSTALLER        "
echo "======================================"
sleep 1

# ==============================
# UPDATE TERMUX
# ==============================
echo "[1/7] Updating packages..."
yes | pkg update -y
yes | pkg upgrade -y

# ==============================
# STORAGE PERMISSION
# ==============================
echo "[2/7] Setting up storage..."
echo "y" | termux-setup-storage

# ==============================
# ENABLE WAKELOCK
# ==============================
echo "[3/7] Enabling wakelock..."
if command -v termux-wake-lock >/dev/null 2>&1; then
    termux-wake-lock
    echo "Wakelock enabled."
else
    echo "termux-wake-lock not available."
fi

# ==============================
# INSTALL SYSTEM PACKAGES
# ==============================
echo "[4/7] Installing system dependencies..."

yes | pkg install -y \
python \
python-pip \
clang \
make \
libffi \
openssl \
libjpeg-turbo \
libpng \
zlib \
freetype \
git \
cmake \
build-essential \
tsu \
libexpat \
rust

# ==============================
# FIX PIP
# ==============================
echo "[5/7] Upgrading pip..."

pip uninstall -y psutil >/dev/null 2>&1

pip install --upgrade pip setuptools wheel

# ==============================
# INSTALL PYTHON LIBRARIES
# ==============================
echo "[6/7] Installing Python libraries..."

pip install --prefer-binary \
requests \
pytz \
pyjwt \
pycryptodome \
rich \
colorama \
flask \
pillow \
discord.py \
python-socketio \
prettytable

# Install psutil with fallback fix
pip install --only-binary=:all: psutil || \
CFLAGS="-Wno-error=implicit-function-declaration" pip install psutil

# ==============================
# DOWNLOAD TOOL
# ==============================
echo "[7/7] Downloading Fynix Rejoin Tool..."

cd /sdcard/Download || exit

curl -L -o obf-bduyrjpremium.py \
https://raw.githubusercontent.com/bduy2222/FynixRejoin/refs/heads/main/obf-bduyrjpremium.py

echo ""
echo "======================================"
echo "      INSTALLATION COMPLETED          "
echo "======================================"
sleep 2

# ==============================
# RUN TOOL
# ==============================
echo "Starting Fynix Rejoin..."

su -c "export PATH=\$PATH:/data/data/com.termux/files/usr/bin && export TERM=xterm-256color && cd /sdcard/Download && python obf-bduyrjpremium.py"
