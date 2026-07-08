#!/data/data/com.termux/files/usr/bin/bash

echo "[*] 1. Xóa triệt để các kho lưu trữ phụ bị lỗi (Gây lỗi NOSPLIT)..."
# Lệnh này sẽ dọn sạch file cấu hình chứa liên kết gãy từ workers.dev
rm -rf $PREFIX/etc/apt/sources.list.d/*

echo "[*] 2. Ép cấu hình kho chính về máy chủ chính thức ổn định..."
echo "deb https://cloudflare.com stable main" > $PREFIX/etc/apt/sources.list

echo "[*] 3. Xóa bộ nhớ đệm APT cũ để nạp cấu hình mới..."
apt clean

echo "[*] 4. Đồng bộ danh sách gói hệ thống..."
apt update -y

echo "[*] 5. Cài đặt lại kho lưu trữ phụ (TUR) bản mới ổn định..."
apt install tur-repo -y

echo "[*] 6. Đọc danh sách gói từ kho TUR vừa thêm..."
apt update -y

echo "[*] 7. Tiến hành gỡ cài đặt Python cũ và hạ cấp xuống Python 3.13..."
pkg uninstall python python-dev python3 -y
apt install python3.13 -y

# Bước kiểm tra cuối cùng và tạo liên kết chạy lệnh
if [ -f "$PREFIX/bin/python3.13" ]; then
    echo "[*] Cấu hình phím tắt cho lệnh 'python'..."
    ln -sf $PREFIX/bin/python3.13 $PREFIX/bin/python
    ln -sf $PREFIX/bin/python3.13 $PREFIX/bin/python3
    
    echo "[+] CHÚC MỪNG! ĐÃ HẠ CẤP THÀNH CÔNG PYTHON 3.13!"
    python --version
else
    echo "[-] Lỗi cài đặt thất bại. Vui lòng bảo member tắt hoàn toàn Termux mở lại rồi chạy lại lệnh."
fi
