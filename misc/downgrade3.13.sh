#!/data/data/com.termux/files/usr/bin/bash

echo "[*] 1. Đang gỡ bỏ phiên bản Python cũ để tránh xung đột..."
pkg uninstall python python-dev python3 -y

echo "[*] 2. Tạo và di chuyển vào thư mục tạm thời..."
# Xóa thư mục cũ nếu có để đảm bảo môi trường sạch 100%
rm -rf $HOME/tmp_python
mkdir -p $HOME/tmp_python && cd $HOME/tmp_python

echo "[*] 3. Tải trực tiếp gói Python 3.13 từ kho TUR GitHub..."
# Sử dụng cờ -o viết thường để ép tên file cố định ngay từ đầu
curl -sL "https://github.com" -o python3.13_3.13.1_aarch64.deb

echo "[*] 4. Tiến hành cài đặt file bằng trình quản lý dpkg..."
# Mẹo thông minh: Nếu curl đổi tên thành curl_response, lệnh này vẫn cài được
if [ -f "python3.13_3.13.1_aarch64.deb" ]; then
    dpkg -i python3.13_3.13.1_aarch64.deb
elif [ -f "curl_response" ]; then
    echo "[!] Phát hiện curl tự đổi tên file, đang tiến hành ép cài đặt..."
    dpkg -i curl_response
else
    echo "[-] Không tìm thấy file tải về bằng curl, đang thử tải lại bằng wget..."
    pkg install wget -y
    wget -q "https://github.com" -O python_setup.deb
    dpkg -i python_setup.deb
fi

# Tự động nạp cấu hình sửa lỗi nếu thiếu thư viện hệ thống
apt install -f -y

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
