#!/bin/bash

echo "[+] Đang kiểm tra môi trường hệ thống..."

if [ -d "/data/data/com.termux" ]; then
    echo "[+] Phát hiện môi trường Termux trên Android."
    
    echo "[+] Đang thiết lập kho lưu trữ phụ TUR (Termux User Repository)..."
    # Ép cài đặt tur-repo để mở khóa các gói Python cũ
    pkg install -y tur-repo

    echo "[+] Đang cập nhật lại danh sách gói..."
    pkg update -y

    # Tìm lại phiên bản Python 3.13 sau khi đã thêm kho TUR
    VERSION=$(apt-cache madison python | grep -o '3\.13\.[0-9a-zA-Z.~_-]*' | head -n1)

    if [ -n "$VERSION" ]; then
        echo "[+] Đã tìm thấy phiên bản thích hợp trong kho TUR: Python $VERSION"
        echo "[+] Tiến hành hạ cấp về Python $VERSION..."
        # Sử dụng tùy chọn --allow-downgrades để ép Termux đè bản 3.13 lên 3.14
        apt-get install -y --allow-downgrades python=$VERSION python-pip
    else
        echo "[-] Vẫn không tìm thấy phiên bản 3.13 trên các Mirror hiện tại."
        echo "[+] Đang thử giải pháp cài đặt trực tiếp gói python313 riêng biệt..."
        pkg install -y python313
    fi

    # Cấu hình liên kết mặc định lệnh 'python' và 'python3'
    echo "[+] Cấu hình lại các liên kết thực thi..."
    if command -v python3.13 &>/dev/null; then
        rm -f $PREFIX/bin/python3 $PREFIX/bin/python
        ln -s $PREFIX/bin/python3.13 $PREFIX/bin/python3
        ln -s $PREFIX/bin/python3.13 $PREFIX/bin/python
    fi

    # Cài đặt/Vá lại PIP chuẩn cho bản 3.13 để không bị dính interpreter của 3.14
    echo "[+] Đồng bộ lại PIP cho Python 3.13..."
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3

    echo "---"
    echo "[+] HOÀN THÀNH QUÁ TRÌNH THIẾT LẬP!"
    echo "[+] Phiên bản hiện tại trên hệ thống của bạn:"
    python3 --version 2>/dev/null || echo "[-] Lỗi lệnh python3"
    python --version 2>/dev/null || echo "[-] Lỗi lệnh python"
    pip --version 2>/dev/null || echo "[-] Lỗi lệnh pip"
else
    echo "[-] Script này được thiết kế riêng cho Termux."
    exit 1
fi
