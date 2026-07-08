#!/bin/bash

# Đảm bảo script chạy với quyền root
if [ "$EUID" -ne 0 ]; then
  echo "[-] Vui lòng chạy script này với quyền root (sudo)."
  exit 1
fi

echo "[+] Đang kiểm tra phiên bản Python hiện tại..."

# Lấy phiên bản python3 hiện tại
if command -v python3 &>/dev/null; then
    CURRENT_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
    echo "[+] Phiên bản Python3 hiện tại là: $CURRENT_VERSION"
else
    CURRENT_VERSION="0.0"
    echo "[!] Không tìm thấy Python3 trên hệ thống."
fi

# Hàm cài đặt Python 3.13
install_python_313() {
    echo "[+] Cập nhật hệ thống và thêm PPA deadsnakes..."
    apt-get update -y
    apt-get install -y software-properties-common
    add-apt-repository -y ppa:deadsnakes/ppa
    apt-get update -y

    echo "[+] Cài đặt Python 3.13 và pip..."
    apt-get install -y python3.13 python3.13-venv python3.13-distutils

    # Cấu hình update-alternatives để python3 nhận bản 3.13
    echo "[+] Cấu hình ưu tiên cho Python 3.13..."
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.13 1
    
    # Thiết lập mặc định (nếu có nhiều bản cũ)
    update-alternatives --set python3 /usr/bin/python3.13

    echo "[+] Đang cài đặt/cập nhật pip cho Python 3.13..."
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.13

    echo "[+] HOÀN THÀNH! Kiểm tra lại phiên bản:"
    python3 --version
    pip3 --version
}

# So sánh phiên bản (Kiểm tra xem có lớn hơn 3.13 không)
# Sử dụng sort -V để so sánh chuỗi phiên bản chính xác
if [ "$(printf '%s\n%s' "3.13" "$CURRENT_VERSION" | sort -V | head -n1)" = "3.13" ] && [ "$CURRENT_VERSION" != "3.13" ]; then
    echo "[!] Phát hiện phiên bản ($CURRENT_VERSION) cao hơn 3.13. Tiến hành hạ cấp..."
    
    # Tùy chọn: Xóa liên kết update-alternatives cũ nếu có để tránh xung đột
    update-alternatives --remove-all python3 &>/dev/null
    
    install_python_313
elif [ "$CURRENT_VERSION" = "3.13" ]; then
    echo "[+] Hệ thống đã ở phiên bản Python 3.13. Không cần thay đổi."
else
    echo "[+] Phiên bản hiện tại thấp hơn 3.13 hoặc chưa cài đặt. Tiến hành cài đặt Python 3.13..."
    install_python_313
fi
