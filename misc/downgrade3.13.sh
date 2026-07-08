#!/bin/bash

echo "[+] Đang kiểm tra môi trường hệ thống..."

if [ -d "/data/data/com.termux" ]; then
    echo "[+] Phát hiện môi trường Termux trên Android."
    
    echo "[+] Đang cập nhật gói hệ thống và cài đặt tur-repo..."
    pkg update -y
    pkg install -y tur-repo

    echo "[+] Đang cài đặt chính xác Python 3.13 từ TUR..."
    # Tên gói chính xác trong TUR là python313 chứ không phải python3.13
    pkg install -y python313

    echo "[+] Cấu hình liên kết cho lệnh python3..."
    rm -f $PREFIX/bin/python3
    rm -f $PREFIX/bin/python
    
    # Tạo liên kết từ binary python3.13 (tên file được cài vào hệ thống) sang python3
    ln -s $PREFIX/bin/python3.13 $PREFIX/bin/python3
    ln -s $PREFIX/bin/python3.13 $PREFIX/bin/python

    echo "[+] Đang cài đặt pip cho Python 3.13..."
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.13

    echo "[+] HOÀN THÀNH! Kiểm tra phiên bản:"
    python3 --version
    pip3 --version
else
    echo "[-] Script này hiện tại đã được tối ưu hóa cho Termux (Android)."
    exit 1
fi
