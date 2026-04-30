#!/data/data/com.termux/files/usr/bin/bash

set -e
set -o pipefail

# ===== CHECK TERMUX =====
[ -z "$PREFIX" ] && exit 1

# ===== FIX REPO =====
echo "deb https://packages.termux.dev/apt/termux-main stable main" > $PREFIX/etc/apt/sources.list 2>/dev/null || true

# ===== UPDATE =====
pkg update -y
pkg upgrade -y

# ===== STORAGE =====
if [ ! -d "$HOME/storage" ]; then
    termux-setup-storage
    sleep 2
fi

# ===== WAKELOCK =====
termux-wake-lock 2>/dev/null || true

# ===== ANTI SLEEP =====
settings put global stay_on_while_plugged_in 3 2>/dev/null || true

# ===== INSTALL CORE =====
pkg install -y \
python git curl wget clang make cmake \
libffi openssl libjpeg-turbo libpng zlib freetype \
tsu libexpat

# ===== FIX PSUTIL ( QUAN TRNG NHT) =====
pip uninstall -y psutil python-psutil 2>/dev/null || true
pkg install -y python-psutil   #  KHÔNG dùng pip na

# ===== FIX PIP (KHÔNG phá Termux) =====
python -m ensurepip --upgrade 2>/dev/null || true
pip install --upgrade setuptools wheel

# ===== INSTALL LIBS (KHÔNG psutil) =====
pip install --prefer-binary \
requests pytz pyjwt pycryptodome rich colorama flask pillow discord.py python-socketio prettytable

# ===== FIX SSL =====
pkg install -y ca-certificates
update-ca-certificates 2>/dev/null || true
pip install certifi --upgrade

# ===== FIX CURL ( FIX LI CURL) =====
pkg install -y curl wget
curl --version >/dev/null || echo "[WARN] curl issue"

# ===== PATH =====
export PATH=$PREFIX/bin:$PATH

echo "[DONE] Setup hoàn tt"