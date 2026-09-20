#!/bin/bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

pkg_install_many pipewire pipewire-pulse wireplumber rtkit

# Микшер-GUI и firmware для части Intel-звуковых карт (SOF) — часть той же
# аудио-связки, ставим рядом, а не отдельным пакетом
pkg_install_many pavucontrol sof-firmware

log_info "Включаю pipewire/pipewire-pulse/wireplumber (user-сервисы)"
systemctl --user enable --now pipewire pipewire-pulse wireplumber

log_info "Включаю rtkit-daemon (system-сервис, нужен sudo)"
sudo systemctl enable --now rtkit-daemon
log_ok "Готово"
