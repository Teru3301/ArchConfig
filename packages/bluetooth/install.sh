#!/bin/bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

pkg_install bluez-utils 
# pkg_install blueman

log_info "Включаю bluetooth.service"
sudo systemctl enable --now bluetooth.service
# log_ok "Bluetooth готов, GUI: blueman-manager"
