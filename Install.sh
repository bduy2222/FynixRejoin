#!/data/data/com.termux/files/usr/bin/bash

# ===== FIX REPO =====
printf "deb https://packages.termux.dev/apt/termux-main stable main\n" > $PREFIX/etc/apt/sources.list

# ===== UPDATE =====
pkg update -y && pkg upgrade -y

# ===== STORAGE =====
termux-setup-storage

# ===== WAKELOCK (🔥 QUAN TRỌNG) =====
echo "[*] Enabling wakelock..."
termux-wake-lock

# ===== OPTIONAL: KEEP CPU ON (ANTI DOZE) =====
# tránh android kill app khi idle
settings put global stay_on_while_plugged_in 3 2>/dev/null

# ===== INSTALL PACKAGES =====
pkg install -y python python-pip clang make libffi openssl libjpeg-turbo libpng zlib freetype git cmake build-essential tsu libexpat-dev python-psutil

# ===== PIP SETUP =====
pip uninstall -y python-psutil 2>/dev/null

pip install --upgrade pip setuptools wheel

pip install --prefer-binary \
requests pytz pyjwt pycryptodome rich colorama flask pillow psutil discord.py python-socketio prettytable \
|| CFLAGS="-Wno-error=implicit-function-declaration"

echo "[DONE] Setup Done"