#!/data/data/com.termux/files/usr/bin/bash

echo "[*] Đang tự động chuyển máy chủ Termux sang Cloudflare để fix lỗi tải..."
# Ép Termux dùng mirror Cloudflare nhằm đảm bảo không bị lỗi "Unable to locate"
echo "deb https://cloudflare.com stable main" > $PREFIX/etc/apt/sources.list

echo "[*] Đang gỡ bỏ phiên bản Python cũ..."
pkg uninstall python python-dev python3 -y

echo "[*] Đang cập nhật lại hệ thống..."
apt update -y && apt upgrade -y

echo "[*] Đang thiết lập kho lưu trữ phụ (TUR)..."
pkg install tur-repo -y

echo "[*] Cài đặt công cụ quản lý đa phiên bản Python..."
# Cài đặt tur-multipy giúp tải trực tiếp mọi phiên bản python độc lập
pkg install tur-multipy -y
apt update -y

echo "[*] Đang cài đặt chính xác Python 3.13..."
apt install python3.13 -y

# Kiểm tra và thiết lập đường dẫn chạy lệnh
if [ -f "$PREFIX/bin/python3.13" ]; then
    echo "[*] Đang tạo liên kết hệ thống..."
    ln -sf $PREFIX/bin/python3.13 $PREFIX/bin/python
    ln -sf $PREFIX/bin/python3.13 $PREFIX/bin/python3
    
    echo "[+] HẠ CẤP THÀNH CÔNG! Phiên bản hiện tại của bạn:"
    python --version
else
    echo "[-] Nếu vẫn lỗi, hãy chạy lệnh sau ngoài màn hình chính: termux-change-repo"
    echo "[-] Sau đó tích chọn toàn bộ các kho và chọn Mirror của Cloudflare hoặc Grimler nhé!"
fi
