#!/data/data/com.termux/files/usr/bin/bash

echo "[*] Đang gỡ bỏ phiên bản Python cũ..."
pkg uninstall python python-dev python3 -y

echo "[*] Đang cấu hình cứng kho lưu trữ phụ (TUR)..."
# Tự động cài đặt tur-repo gốc
pkg install tur-repo -y

# Ép hệ thống nhận diện đúng nguồn lưu trữ của TUR nếu lệnh pkg install tur-repo bị bỏ sót nguồn
mkdir -p $PREFIX/etc/apt/sources.list.d
echo "deb https://workers.dev stable main" > $PREFIX/etc/apt/sources.list.d/tur.list

echo "[*] Đang cập nhật lại toàn bộ danh sách gói..."
apt update -y

echo "[*] Đang tiến hành cài đặt Python 3.13..."
apt install python3.13 -y

# Kiểm tra xem việc cài đặt Python 3.13 có thành công không
if [ -f "$PREFIX/bin/python3.13" ]; then
    echo "[*] Đang cấu hình liên kết hệ thống cho lệnh 'python'..."
    ln -sf $PREFIX/bin/python3.13 $PREFIX/bin/python
    ln -sf $PREFIX/bin/python3.13 $PREFIX/bin/python3
    
    echo "[+] HOÀN TẤT THÀNH CÔNG! Phiên bản hiện tại:"
    python --version
else
    echo "[-] LỖI: Vẫn không thể tìm thấy Python 3.13. Hãy thử chạy lệnh 'termux-change-repo' để đổi sang mirror khác rồi chạy lại script!"
fi
