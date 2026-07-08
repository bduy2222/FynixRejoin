#!/data/data/com.termux/files/usr/bin/bash

echo "[*] 1. Xóa bỏ cấu hình kho lưu trữ cũ bị lỗi..."
rm -f $PREFIX/etc/apt/sources.list.d/*

echo "[*] 2. Ép buộc đặt lại danh sách máy chủ chính thức (Cloudflare)..."
echo "deb https://cloudflare.com stable main" > $PREFIX/etc/apt/sources.list

echo "[*] 3. Sửa lỗi chữ ký bảo mật và cập nhật khóa (Fix Keyring)..."
# Tải và cài đặt trực tiếp file keyring chính thức để sửa lỗi "not signed"
pkg install termux-keyring -y --force-yes

echo "[*] 4. Đang làm sạch bộ nhớ đệm APT..."
apt clean
apt update -y

echo "[*] 5. Đang cài đặt kho lưu trữ phụ (TUR) mới..."
pkg install tur-repo -y

echo "[*] 6. Đang cập nhật danh sách gói tổng hợp..."
apt update -y

echo "[*] 7. Tiến hành cài đặt Python 3.13..."
pkg uninstall python python-dev python3 -y
apt install python3.13 -y

# Kiểm tra cuối cùng và tạo liên kết chạy lệnh
if [ -f "$PREFIX/bin/python3.13" ]; then
    echo "[*] Thiết lập phím tắt lệnh 'python'..."
    ln -sf $PREFIX/bin/python3.13 $PREFIX/bin/python
    ln -sf $PREFIX/bin/python3.13 $PREFIX/bin/python3
    
    echo "[+] HOÀN TẤT THÀNH CÔNG! Phiên bản hiện tại:"
    python --version
else
    echo "[-] Lỗi cài đặt. Vui lòng bảo member gõ lệnh: 'termux-change-repo' ngoài màn hình, chọn 'Mirror by Cloudflare' rồi chạy lại script."
fi
