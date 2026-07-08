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
        echo "[!] Không tìm thấy phiên bản 3.13 cụ thể trong kho hiện tại."
        echo "[+] Thử cài đặt gói python mặc định của hệ thống..."
        pkg install -y python
    fi

    echo "[+] Đang cấu hình liên kết hệ thống (Mặc định lệnh python/python3 về 3.13)..."
    # Xóa các liên kết cũ nếu có để tránh xung đột
    rm -f $PREFIX/bin/python3
    rm -f $PREFIX/bin/python
    rm -f $PREFIX/bin/pip3
    rm -f $PREFIX/bin/pip

    # Tạo liên kết trỏ thẳng về bản python3.13 vừa cài
    ln -s $PREFIX/bin/python3.13 $PREFIX/bin/python3
    ln -s $PREFIX/bin/python3.13 $PREFIX/bin/python

    echo "[+] Cài đặt và vá lỗi PIP tương thích riêng cho Python 3.13..."
    # Sửa lỗi dính interpreter 3.14 của gói python-pip mặc định
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3

    echo "---"
    echo "[+] HOÀN THÀNH QUÁ TRÌNH THIẾT LẬP!"
    echo "[+] Phiên bản hiện tại trên hệ thống:"
    python --version
    python3 --version
    pip --version

else
    echo "[-] Script này được thiết kế và tối ưu hóa riêng cho môi trường Termux."
    exit 1
fi
