#!/data/data/com.termux/files/usr/bin/bash

echo "[*] 1. Đang gỡ bỏ phiên bản Python cũ..."
pkg uninstall python python-dev python3 -y

echo "[*] 2. Tạo thư mục tạm thời..."
rm -rf $HOME/tmp_python
mkdir -p $HOME/tmp_python && cd $HOME/tmp_python

echo "[*] 3. Tải trực tiếp gói Python 3.13 từ kho dữ liệu lưu trữ ổn định..."
# Sử dụng link trực tiếp từ kho lưu trữ chính thức bản aarch64 (Nặng đúng 12.8 MB)
curl -sL "https://github.com" -o python3.13_aarch64.deb

echo "[*] 4. Tiến hành cài đặt file bằng trình quản lý dpkg..."
if [ -f "python3.13_aarch64.deb" ]; then
    dpkg -i python3.13_aarch64.deb
    # Tự động sửa lỗi nếu thiếu thư viện hệ thống phụ thuộc đi kèm
    apt install -f -y
else
    echo "[-] LỖI: Không thể tải được file cài đặt từ máy chủ chính."
fi

echo "[*] 5. Đang cấu hình liên kết hệ thống cho lệnh 'python'..."
if [ -f "$PREFIX/bin/python3.13" ]; then
    ln -sf $PREFIX/bin/python3.13 $PREFIX/bin/python
    ln -sf $PREFIX/bin/python3.13 $PREFIX/bin/python3
    
    echo "[+] HOÀN TẤT THÀNH CÔNG! Phiên bản hiện tại của bạn:"
    python --version
else
    echo "[-] LỖI: Quá trình cài đặt Python 3.13 không thành công!"
fi

echo "[*] 6. Dọn dẹp các tệp tin cài đặt tạm..."
cd $HOME
rm -rf $HOME/tmp_python
