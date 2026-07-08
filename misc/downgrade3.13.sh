#!/data/data/com.termux/files/usr/bin/bash

echo "[*] Đang xóa phiên bản Python cũ..."
pkg uninstall python python-dev -y

echo "[*] Đang cập nhật hệ thống Termux..."
pkg update -y && pkg upgrade -y

echo "[*] Đang cài đặt kho lưu trữ phụ (TUR)..."
pkg install tur-repo -y

echo "[*] Đang cài đặt Python 3.13..."
pkg install python3.13 python3.13-dev -y

echo "[*] Đang tạo liên kết để lệnh 'python' trỏ thẳng vào Python 3.13..."
ln -sf $PREFIX/bin/python3.13 $PREFIX/bin/python

echo "[+] Hoàn tất! Kiểm tra phiên bản hiện tại:"
python --version
