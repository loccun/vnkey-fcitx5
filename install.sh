#!/usr/bin/env bash

set -euo pipefail

MODE="user"
if [[ "${1:-}" == "--system" ]]; then
  MODE="system"
elif [[ "${1:-}" == "--user" ]]; then
  MODE="user"
elif [[ "${1:-}" != "" ]]; then
  echo "Usage: $0 [--user|--system]"
  echo "  --user   Install vnkey into \$HOME/.local (default)"
  echo "  --system Install vnkey into /usr (requires sudo)"
  exit 1
fi

if [[ "$MODE" == "system" ]]; then
  PREFIX="/usr"
else
  PREFIX="${HOME}/.local"
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Building core library and tests (C++17, CMake) ..."
cmake -B "${ROOT_DIR}/build" "${ROOT_DIR}"
cmake --build "${ROOT_DIR}/build"

echo "==> Running C++ tests ..."
"${ROOT_DIR}/build/unikey_telex_cpp_tests"

echo "==> Building fcitx5 addon 'vnkey' (mode: ${MODE}, prefix: ${PREFIX}) ..."
cd "${ROOT_DIR}/vnkey-fcitx"
cmake -B build -DCMAKE_INSTALL_PREFIX="${PREFIX}" .
cmake --build build

echo "==> Installing addon 'vnkey' into ${PREFIX} ..."
if [[ "$MODE" == "system" ]]; then
  sudo cmake --install build
else
  cmake --install build
fi

echo
echo "Done."
echo "- Add input method 'vnkey' in fcitx5-configtool (Input Method -> Add -> vnkey)."
echo "- Then restart fcitx5: fcitx5 -r"

