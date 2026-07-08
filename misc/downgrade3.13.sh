#!/bin/bash

echo "[+] Đang kiểm tra môi trường hệ thống..."

# Kiểm tra xem có phải đang chạy trên Termux không
if [ -d "/data/data/com.termux" ]; then
    echo "[+] Phát hiện môi trường Termux trên Android."
    
    echo "[+] Đang cập nhật gói hệ thống và cài đặt tur-repo..."
    pkg update -y
    pkg install -y x11-repo # Cần thiết cho một số thư viện bổ sung
    pkg install -y tur-repo

    echo "[+] Đang cài đặt chính xác Python 3.13 từ TUR..."
    pkg install -y python3.13

    # Tạo liên kết (alias) để khi gõ 'python3' hoặc 'python' sẽ gọi python3.13
    echo "[+] Cấu hình liên kết cho lệnh python3..."
    rm -f $PREFIX/bin/python3
    rm -f $PREFIX/bin/python
    ln -s $PREFIX/bin/python3.13 $PREFIX/bin/python3
    ln -s $PREFIX/bin/python3.13 $PREFIX/bin/python

    # Cài đặt pip riêng cho bản 3.13 nếu chưa có
    echo "[+] Đang cài đặt pip cho Python 3.13..."
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.13

    echo "[+] HOÀN THÀNH! Kiểm tra phiên bản:"
    python3 --version
    pip --version

else
    echo "[-] Script này hiện tại đã được tối ưu hóa cho Termux (Android)."
    echo "[-] Nếu bạn dùng Ubuntu, vui lòng dùng phiên bản script cũ."
    exit 1
fi
