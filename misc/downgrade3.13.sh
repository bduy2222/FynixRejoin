#!/bin/bash

echo "[+] Đang kiểm tra môi trường hệ thống..."

if [ -d "/data/data/com.termux" ]; then
    echo "[+] Phát hiện môi trường Termux trên Android."
    
    echo "[+] Đang cập nhật danh sách gói..."
    pkg update -y

    # Tìm phiên bản Python 3.13 từ kho TUR (tur-packages)
    VERSION=$(apt-cache madison python | grep -o '3\.13\.[0-9a-zA-Z.~_-]*' | head -n1)

    if [ -n "$VERSION" ]; then
        echo "[+] Tìm thấy phiên bản thích hợp: Python $VERSION"
        echo "[+] Tiến hành hạ cấp/cài đặt Python $VERSION..."
        pkg install -y python=$VERSION
    else
        echo "[!] Không tìm thấy phiên bản 3.13 cụ thể."
        echo "[+] Cài đặt gói mặc định hiện tại..."
        pkg install -y python
    fi

    # Tạo liên kết cho lệnh 'python' nếu chưa có
    if [ -f "$PREFIX/bin/python3" ] && [ ! -f "$PREFIX/bin/python" ]; then
        echo "[+] Tạo liên kết mặc định lệnh 'python' về 'python3'..."
        ln -s $PREFIX/bin/python3 $PREFIX/bin/python
    fi

    echo "---"
    echo "[+] HOÀN THÀNH QUÁ TRÌNH THIẾT LẬP!"
    echo "[+] Phiên bản hiện tại trên hệ thống:"
    python3 --version 2>/dev/null || echo "[-] Không tìm thấy lệnh python3"
    python --version 2>/dev/null || echo "[-] Không tìm thấy lệnh python"
else
    echo "[-] Script này được thiết kế riêng cho Termux."
    exit 1
fi
