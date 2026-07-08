#!/data/data/com.termux/files/usr/bin/bash

echo "[*] 1. Đang gỡ bỏ phiên bản Python cũ để tránh xung đột..."
pkg uninstall python python-dev python3 -y

echo "[*] 2. Tạo và di chuyển vào thư mục tạm thời..."
mkdir -p $HOME/tmp_python && cd $HOME/tmp_python

echo "[*] 3. Tải trực tiếp gói Python 3.13 chính thức từ kho TUR GitHub..."
# Sử dụng cờ -o để ép định dạng tên file đầu ra, tránh lỗi No such file or directory
curl -L "https://github.com" -o python3.13_3.13.1_aarch64.deb

echo "[*] 4. Tiến hành cài đặt file .deb bằng trình quản lý dpkg..."
if [ -f "python3.13_3.13.1_aarch64.deb" ]; then
    dpkg -i python3.13_3.13.1_aarch64.deb
    # Tự động nạp cấu hình và sửa lỗi nếu thiếu các thư viện hệ thống đi kèm
    apt install -f -y
else
    echo "[-] LỖI: Không tìm thấy file cài đặt đã tải. Thử dùng wget..."
    pkg install wget -y
    wget "https://github.com"
    dpkg -i python3.13_3.13.1_aarch64.deb
    apt install -f -y
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
