#!/data/data/com.termux/files/usr/bin/bash

=========================

FYNIX TERMUX SETUP

=========================

===== SAFE MODE =====

set +e

===== CHECK TERMUX =====

if [ -z "$PREFIX" ]; then
echo "[ERROR] Run inside Termux"
exit 1
fi

===== FIX PATH =====

export PATH=$PREFIX/bin:$PATH

===== FIX DNS (curl SSL fix) =====

mkdir -p $PREFIX/etc

echo "nameserver 1.1.1.1" > $PREFIX/etc/resolv.conf
echo "nameserver 8.8.8.8" >> $PREFIX/etc/resolv.conf

===== FIX REPO =====

cat > $PREFIX/etc/apt/sources.list << EOF
deb https://packages.termux.dev/apt/termux-main stable main
EOF

===== CLEAN BROKEN CACHE =====

rm -rf $PREFIX/var/lib/apt/lists/*
apt clean

===== UPDATE =====

pkg update -y
pkg install -y termux-tools

===== STORAGE =====

if [ ! -d "$HOME/storage" ]; then
termux-setup-storage
sleep 3
fi

===== WAKELOCK =====

termux-wake-lock 2>/dev/null

===== ANTI SLEEP =====

settings put global stay_on_while_plugged_in 3 2>/dev/null

===== INSTALL CORE =====

pkg install -y 
python 
git 
curl 
wget 
clang 
make 
cmake 
openssl 
libffi 
libjpeg-turbo 
libpng 
freetype 
zlib 
tsu 
ca-certificates

===== FIX CURL =====

pkg reinstall curl -y

===== FIX SSL =====

pkg reinstall openssl ca-certificates -y

===== PIP SAFE =====

python -m pip install --upgrade pip setuptools wheel --no-cache-dir

===== REMOVE BROKEN PSUTIL =====

pip uninstall -y psutil python-psutil 2>/dev/null

===== INSTALL PSUTIL SAFELY =====

pkg install -y python-psutil || 
pip install psutil --prefer-binary --no-cache-dir

===== INSTALL LIBRARIES =====

pip install --prefer-binary --no-cache-dir 
requests 
pytz 
pyjwt 
pycryptodome 
rich 
colorama 
flask 
pillow 
discord.py 
python-socketio 
prettytable

===== TEST CURL =====

curl https://google.com >/dev/null 2>&1

if [ $? -eq 0 ]; then
echo "[OK] curl working"
else
echo "[WARN] curl still has issues"
fi

===== DONE =====

echo ""
echo "[DONE] Fynix setup completed"
echo "[TIP] Run: python main.py"