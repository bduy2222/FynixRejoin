#!/data/data/com.termux/files/usr/bin/bash

echo "[*] 1. Đang gỡ bỏ phiên bản Python cũ để tránh xung đột..."
pkg uninstall python python-dev python3 -y

echo "[*] 2. Tạo thư mục tạm thời..."
mkdir -p $HOME/tmp_python && cd $HOME/tmp_python

echo "[*] 3. Tải trực tiếp gói Python 3.13 (.deb) từ GitHub..."
# Tải file cài đặt chính thức dành cho kiến trúc chip aarch64 (hầu hết điện thoại Android hiện nay)
curl -L -O https://github.com

echo "[*] 4. Tiến hành cài đặt file .deb bằng trình quản lý dpkg..."
dpkg -i python3.13_3.13.1_aarch64.deb

# Tự động sửa lỗi nếu thiếu thư viện phụ thuộc đi kèm
apt install -f -y

echo "[*] 5. Đang cấu hình liên kết hệ thống cho lệnh 'python'..."
if [ -f "$PREFIX/bin/python3.13" ]; then
    ln -sf $PREFIX/bin/python3.13 $PREFIX/bin/python
    ln -sf $PREFIX/bin/python3.13 $PREFIX/bin/python3
    
    echo "[+] HOÀN TẤT THÀNH CÔNG! Phiên bản hiện tại của bạn:"
    python --version
else
    echo "[-] LỖI: Cài đặt file .deb thất bại. Vui lòng kiểm tra lại kết nối mạng!"
fi

echo "[*] Dọn dẹp tệp tin rác..."
rm -rf $HOME/tmp_python
