#!/bin/bash
set -e

GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}[FynixRejoin] SETUP START ...${NC}"

# === Update + cài gói cần thiết ===
yes | pkg update && yes | pkg upgrade -y
echo "y" | termux-setup-storage
yes | pkg install -y python python-pip clang make libffi openssl libjpeg-turbo libpng zlib freetype git cmake build-essential tsu libexpat

# === Fix psutil + cài thư viện Python ===
pip uninstall -y psutil
pip install --upgrade pip setuptools wheel
pip install --prefer-binary requests pytz pyjwt pycryptodome rich colorama flask pillow psutil discord.py python-socketio prettytable || \
CFLAGS="-Wno-error=implicit-function-declaration" pip install psutil

# === Download file tool từ GitHub ===
echo -e "${GREEN}[FynixRejoin] Download file tool...${NC}"
curl -L -o obf-bduyrjpremium.py https://raw.githubusercontent.com/bduy2222/FynixRejoin/refs/heads/main/obf-bduyrjpremium.py

echo -e "${GREEN}[FynixRejoin] Done ${NC}"
