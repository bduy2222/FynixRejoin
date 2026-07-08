#!/bin/bash

echo "[+] Đang kiểm tra môi trường hệ thống..."

if [ -d "/data/data/com.termux" ]; then
    echo "[+] Phát hiện môi trường Termux trên Android."
    
    echo "[+] Đang đồng bộ và cập nhật danh sách gói..."
    pkg update -y

    # Tìm phiên bản Python 3.13 có sẵn trong các kho lưu trữ
    VERSION=$(apt-cache madison python | grep -o '3\.13\.[0-9a-zA-Z.~_-]*' | head -n1)

    if [ -n "$VERSION" ]; then
        echo "[+] Tìm thấy phiên bản thích hợp: Python $VERSION"
        echo "[+] Tiến hành hạ cấp/cài đặt Python $VERSION..."
        pkg install -y python=$VERSION
    else
        echo "[!] Không tìm thấy phiên bản 3.13 cụ thể."
        echo "[+] Tự động cài đặt gói mặc định..."
        pkg install -y python
    fi

    # Ép lệnh 'python' (không số) cũng trỏ về 'python3' của bản 3.13 vừa cài
    if [ -f "$PREFIX/bin/python3" ] && [ ! -f "$PREFIX/bin/python" ]; then
        echo "[+] Đang cấu hình lệnh 'python' mặc định về Python 3.13..."
        ln -s $PREFIX/bin/python3 $PREFIX/bin/python
    fi

    echo "---"
    echo "[+] HOÀN THÀNH QUÁ TRÌNH THIẾT LẬP!"
    echo "[+] Phiên bản hiện tại trên hệ thống:"
    python3 --version
    python --version
else
    echo "[-] Script này được thiết kế và tối ưu hóa riêng cho môi trường Termux."
    exit 1
fi
