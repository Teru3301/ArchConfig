#!/bin/bash
# eww-git (виджеты/бар на Rust) + mpvpaper (видео-обои через mpv) — оба
# из AUR, нужен yay (ставится раньше в packages.txt).
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

if ! command -v yay &>/dev/null; then
    log_err "yay не найден — eww-git и mpvpaper только из AUR. Поставь пакет yay раньше в packages.txt"
    exit 1
fi

pkg_install_many eww-git mpvpaper
