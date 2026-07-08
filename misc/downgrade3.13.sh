#!/data/data/com.termux/files/usr/bin/bash

echo "[*] 1. Đang gỡ bỏ phiên bản Python cũ..."
pkg uninstall python python-dev python3 -y

echo "[*] 2. Tạo thư mục tạm thời..."
rm -rf $HOME/tmp_python
mkdir -p $HOME/tmp_python && cd $HOME/tmp_python

echo "[*] 3. Tải trực tiếp gói Python 3.13 từ máy chủ lưu trữ Termux..."
# ĐÂY LÀ LINK GỐC CHUẨN ĐỂ TẢI ĐỦ FILE 13MB
curl -sL "https://termux.dev" -o python3.13_aarch64.deb

echo "[*] 4. Tiến hành cài đặt file bằng trình quản lý dpkg..."
if [ -f "python3.13_aarch64.deb" ]; then
    dpkg -i python3.13_aarch64.deb
    apt install -f -y
else
    echo "[-] LỖI: Không thể tải được file cài đặt từ máy chủ chính."
fi

echo "[*] 5. Đang cấu hình liên kết hệ thống cho lệnh 'python'..."
if [ -f "$PREFIX/bin/python3" ]; then
    ln -sf $PREFIX/bin/python3 $PREFIX/bin/python
    
    echo "[+] HOÀN TẤT THÀNH CÔNG! Phiên bản hiện tại của bạn:"
    python --version
else
    echo "[-] LỖI: Quá trình cài đặt Python 3.13 không thành công!"
fi

echo "[*] 6. Dọn dẹp các tệp tin cài đặt tạm..."
cd $HOME
rm -rf $HOME/tmp_python

