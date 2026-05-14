#!/usr/bin/env bash

mkdir -p $PREFIX/etc/termux
echo "deb grimler.se stable main" > $PREFIX/etc/termux/sources.list

export DEBIAN_FRONTEND=noninteractive
pkg update -y -o Dpkg::Options::="--force-confold"
pkg upgrade -y -o Dpkg::Options::="--force-confold"

echo "y" | termux-setup-storage

pkg install -y python python-pip clang make libffi openssl libjpeg-turbo libpng zlib freetype git cmake build-essential tsu libexpat libtiff openjpeg -o Dpkg::Options::="--force-confold"

pip uninstall -y python-psutil psutil 2>/dev/null

export LDFLAGS="-L${PREFIX}/lib"
export CFLAGS="-I${PREFIX}/include -Wno-error=implicit-function-declaration"

pip install --upgrade pip setuptools wheel

pip install --no-cache-dir --no-build-isolation --prefer-binary pillow

CFLAGS="-Wno-error=implicit-function-declaration" pip install --no-cache-dir psutil

pip install --prefer-binary requests pytz pyjwt pycryptodome rich colorama flask discord.py python-socketio prettytable
