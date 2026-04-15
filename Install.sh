#!/data/data/com.termux/files/usr/bin/bash

# ===== FIX REPO =====
printf "deb https://packages.termux.dev/apt/termux-main stable main\n" > $PREFIX/etc/apt/sources.list

# ===== UPDATE =====
yes | pkg update && yes | pkg upgrade -y

# ===== STORAGE =====
echo "y" | termux-setup-storage

# ===== INSTALL PACKAGES =====
yes | pkg install -y python python-pip clang make libffi openssl libjpeg-turbo libpng zlib freetype git cmake build-essential tsu libexpat

# ===== PIP SETUP =====
pip uninstall -y python-psutil 2>/dev/null

pip install --upgrade pip setuptools wheel

pip install --prefer-binary \
requests pytz pyjwt pycryptodome rich colorama flask pillow psutil discord.py python-socketio prettytable \
|| CFLAGS="-Wno-error=implicit-function-declaration" pip install python-psutil

echo "[DONE] Setup hoàn tất"