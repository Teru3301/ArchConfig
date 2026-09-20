#!/bin/bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

if command -v yay &>/dev/null; then
    log_ok "yay уже установлен"
    exit 0
fi

sudo pacman -S --needed --noconfirm git base-devel

tmpdir="$(mktemp -d)"
git clone https://aur.archlinux.org/yay.git "$tmpdir"
(cd "$tmpdir" && makepkg -si --noconfirm)
rm -rf "$tmpdir"

log_ok "yay установлен"
