#!/bin/bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

pkg_install_many hyprland hyprpaper hyprlock hypridle

# Перенесите сюда ваши реальные конфиги из старого архива:
# setup/hypr/*.conf -> packages/hypr/config/hypr/*.conf
link_config "hypr" "$DIR/config/hypr"
