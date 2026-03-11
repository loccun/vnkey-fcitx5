## Bộ gõ Telex C++ và fcitx5 (vnkey)

### 1. Thành phần chính

Trong thư mục gốc `unikey/` hiện có:

- `vietnamese.h/.cpp`: Hàm `telex_to_unicode` chuyển chuỗi Telex → Unicode tiếng Việt.
- `engine.h/.cpp`: Engine buffer C++ (`EngineVietCpp`)
- `vnkey-fcitx/`: Addon fcitx5 `vnkey` (bộ gõ Telex dùng C++).

### 2. Build và chạy test C++

Yêu cầu:

- Compiler hỗ trợ C++17.
- CMake ≥ 3.10.

Gợi ý cài dependency (tuỳ distro):

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y build-essential cmake

# Fedora
sudo dnf install -y gcc-c++ cmake make

# Arch
sudo pacman -S --needed base-devel cmake
```

Lệnh:

```bash
cmake -B build .
cmake --build build
./build/unikey_telex_cpp_tests
```

Nếu mọi thứ ổn sẽ in ra:

```text
All C++ tests passed.
```

Nếu bạn vừa pull code mới mà build bị lạ, hãy build sạch:

```bash
rm -rf build
cmake -B build .
cmake --build build
./build/unikey_telex_cpp_tests
```

### 3. Cài bộ gõ `vnkey` cho fcitx5

Yêu cầu:

- fcitx5 + file header phát triển (gói `fcitx5-dev` hoặc tương đương).

Gợi ý cài dependency (tuỳ distro):

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y fcitx5 fcitx5-configtool libfcitx5core-dev libfcitx5utils-dev

# Fedora (tên gói có thể khác nhẹ theo phiên bản)
sudo dnf install -y fcitx5 fcitx5-configtool fcitx5-devel

# Arch
sudo pacman -S --needed fcitx5 fcitx5-configtool
```

#### Cài toàn hệ thống (đề xuất)

```bash
cd vnkey-fcitx
cmake -B build -DCMAKE_INSTALL_PREFIX=/usr .
cmake --build build
sudo cmake --install build
```

#### Cài cho user hiện tại (không dùng sudo)

```bash
cd vnkey-fcitx
cmake -B build -DCMAKE_INSTALL_PREFIX="$HOME/.local" .
cmake --build build
cmake --install build
```

Sau đó restart fcitx5:

```bash
fcitx5 -r
```

Nếu mới cài lần đầu mà chưa thấy `vnkey` trong danh sách, hãy logout/login hoặc reboot.

#### Cài nhanh bằng script `install.sh`

Ở thư mục gốc `unikey/` đã có sẵn script:

```bash
# Cài cho user hiện tại (PREFIX = $HOME/.local)
./install.sh --user

# Hoặc cài toàn hệ thống (PREFIX = /usr, cần sudo)
./install.sh --system
```

Script sẽ:

- Build core C++ + chạy `./build/unikey_telex_cpp_tests`.
- Build addon `vnkey-fcitx`.
- Chạy `cmake --install` với prefix tương ứng.

### 4. Bật input method `vnkey`

1. Mở `fcitx5-configtool`.
2. Tab **Input Method** → **Add** → tìm `**vnkey`**
  (tên hiển thị: “Vietnamese (Telex) - vnkey”).
3. Thêm vào danh sách và Apply.
4. Dùng phím tắt của fcitx5 để chuyển sang `vnkey` rồi gõ thử:
  - `tieengs vieetj` → `tiếng việt`
  - `nguyeenx` → `nguyễn`

### 5. Hai chế độ gõ trong `vnkey`

Addon `vnkey` có **2 chế độ chính**:

#### 5.1. Mặc định: preedit (gạch chân)

- Chữ đang gõ được hiển thị dưới dạng **preedit có gạch chân**.
- Khi nhấn Space / Enter / dấu câu, từ sẽ được “chốt” và gửi vào ứng dụng.
- Ưu điểm: ổn định, tương thích tốt với hầu hết ứng dụng (editor, terminal, trình duyệt…).

#### 5.2. Thử nghiệm: Direct commit + rollback (không preedit)

- Bật / tắt trong `fcitx5-configtool`:
  - Tab **Addons** → chọn **vnkey** → nút **Configure** →
  checkbox **DirectCommitRollback** (mặc định đang bật).
- Hiệu ứng người dùng:
  - Chữ Việt xuất hiện **trực tiếp** trong ô nhập (không còn gạch chân).
  - Gõ `nguyeenx` sẽ thấy hiện dần thành `nguyễn` ngay trong ứng dụng.
- Lưu ý:
  - Một số ứng dụng không hỗ trợ đầy đủ tính năng của fcitx5, khi đó `vnkey`
  sẽ tự động quay về chế độ preedit (gạch chân) để tránh lỗi.
  - Undo/Redo trong vài ứng dụng có thể khác một chút so với chế độ mặc định.
  Nếu cảm thấy khó chịu, hãy tắt tùy chọn **DirectCommitRollback**.

### 6. Gỡ cài đặt `vnkey`

Nếu bạn đã cài `vnkey` vào `/usr`:

```bash
sudo rm -f /usr/lib/fcitx5/vnkey.so
sudo rm -f /usr/share/fcitx5/addon/vnkey.conf
sudo rm -f /usr/share/fcitx5/inputmethod/vnkey.conf
fcitx5 -r
```

Nếu bạn cài bản user-local vào `$HOME/.local`:

```bash
rm -f "$HOME/.local/lib/fcitx5/vnkey.so"
rm -f "$HOME/.local/share/fcitx5/addon/vnkey.conf"
rm -f "$HOME/.local/share/fcitx5/inputmethod/vnkey.conf"
fcitx5 -r
```

