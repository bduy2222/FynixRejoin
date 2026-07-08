#!/data/data/com.termux/files/usr/bin/bash

echo "[*] Đang gỡ bỏ phiên bản Python lỗi tương thích..."
pkg uninstall python python-dev python3 -y

echo "[*] Đang cập nhật danh sách gói hệ thống..."
pkg update -y

echo "[*] Đang thiết lập kho lưu trữ phụ (TUR)..."
pkg install tur-repo -y

echo "[*] Ép buộc cập nhật danh sách gói từ kho TUR..."
apt update -y

echo "[*] Đang cài đặt Python 3.13..."
pkg install python3.13 -y

# Kiểm tra xem việc cài đặt Python 3.13 có thành công không trước khi tạo liên kết
if [ -f "$PREFIX/bin/python3.13" ]; then
    echo "[*] Đang cấu hình liên kết hệ thống cho lệnh 'python'..."
    ln -sf $PREFIX/bin/python3.13 $PREFIX/bin/python
    ln -sf $PREFIX/bin/python3.13 $PREFIX/bin/python3
    
    echo "[+] HOÀN TẤT THÀNH CÔNG! Kiểm tra phiên bản:"
    python --version
else
    echo "[-] LỖI: Không thể cài đặt Python 3.13. Vui lòng kiểm tra lại kết nối mạng!"
fi
