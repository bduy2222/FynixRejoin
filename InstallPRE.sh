#!/data/data/com.termux/files/usr/bin/bash

# ==================================================

# FYNIX TERMUX INSTALLER

# ==================================================

set +e

export DEBIAN_FRONTEND=noninteractive
export FORCE_UNSAFE_CONFIGURE=1

export CFLAGS="-O2 -pipe"
export MULTIDICT_NO_EXTENSIONS=1
export YARL_NO_EXTENSIONS=1
export PYCRYPTODOME_DISABLE_EXTENSIONS=1
export AUDIOOP_LTS_SKIP_EXTENSIONS=1
export AIOHTTP_NO_EXTENSIONS=1

echo ""
echo "======================================"
echo "         FYNIX TERMUX SETUP"
echo "======================================"
echo ""

# ==================================================

# CHECK TERMUX

# ==================================================

if [ -z "$PREFIX" ]; then
echo "[ERROR] Run inside Termux"
exit 1
fi

export PATH=$PREFIX/bin:$PATH

# ==================================================

# STORAGE

# ==================================================

if [ ! -d "$HOME/storage" ]; then
termux-setup-storage
sleep 3
fi

# ==================================================

# WAKELOCK

# ==================================================

termux-wake-lock 2>/dev/null || true

# ==================================================

# FIX REPO

# ==================================================

echo "[*] Configuring repositories..."

mkdir -p "$PREFIX/etc"

cat > "$PREFIX/etc/apt/sources.list" << EOF
deb https://packages.termux.dev/apt/termux-main stable main
EOF

pkg update -y

if [ $? -ne 0 ]; then
echo "[ERROR] Failed to update packages."
echo "Your Termux installation may be broken."
exit 1
fi

pkg upgrade -y

# ==================================================

# CORE PACKAGES

# ==================================================

echo "[*] Installing core packages..."

pkg install -y 
python 
git 
curl 
wget 
clang 
make 
openssl 
libffi 
zlib 
libjpeg-turbo 
libpng 
freetype 
termux-tools 
tsu

# ==================================================

# PYTHON CHECK

# ==================================================

python -V

if [ $? -ne 0 ]; then
echo "[ERROR] Python installation failed."
exit 1
fi

# ==================================================

# PIP

# ==================================================

echo "[*] Updating pip..."

python -m ensurepip --upgrade 2>/dev/null || true

python -m pip install 
--upgrade 
pip 
setuptools 
wheel 
--no-cache-dir

# ==================================================

# PREBUILT PACKAGES

# ==================================================

echo "[*] Installing prebuilt packages..."

pkg install -y 
python-psutil 
python-pillow || true

# ==================================================

# PYTHON LIBRARIES

# ==================================================

echo "[*] Installing Python libraries..."

python -m pip install 
--prefer-binary 
--no-cache-dir 
requests 
pytz 
pyjwt 
pycryptodome 
rich 
colorama 
flask 
python-socketio 
prettytable 
multidict 
yarl 
audioop-lts 
aiohttp 
discord.py

# ==================================================

# CLEAN

# ==================================================

pkg clean

rm -rf ~/.cache/pip

# ==================================================

# DOWNLOAD TOOL

# ==================================================

echo ""
echo "=== DOWNLOADING FYNIX REJOIN ==="

DOWNLOAD_DIR="$HOME/storage/downloads"

mkdir -p "$DOWNLOAD_DIR"

DOWNLOAD_URL="https://raw.githubusercontent.com/bduy2222/FynixRejoin/main/obf-bduyrjpremium.py"

OUTPUT_FILE="$DOWNLOAD_DIR/obf-bduyrjpremium.py"

if command -v curl >/dev/null 2>&1; then

```
curl -L \
--retry 5 \
--retry-delay 3 \
"$DOWNLOAD_URL" \
-o "$OUTPUT_FILE"
```

else

```
wget -O "$OUTPUT_FILE" "$DOWNLOAD_URL"
```

fi

# ==================================================

# VERIFY

# ==================================================

if [ -f "$OUTPUT_FILE" ] && [ -s "$OUTPUT_FILE" ]; then

```
chmod 777 "$OUTPUT_FILE"

echo ""
echo "[OK] Download completed"
echo "[FILE] $OUTPUT_FILE"

ls -lh "$OUTPUT_FILE"
```

else

```
echo ""
echo "[ERROR] Download failed"
```

fi

# ==================================================

# DONE

# ==================================================

echo ""
echo "======================================"
echo "      INSTALL COMPLETED"
echo "======================================"
echo ""
echo "Run:"
echo "python ~/storage/downloads/obf-bduyrjpremium.py"
echo ""
