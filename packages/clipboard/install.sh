#!/bin/bash
# wl-clipboard — базовый доступ к буферу обмена под Wayland (wl-copy/wl-paste),
# cliphist — история буфера обмена поверх него. Второй бесполезен без первого.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

pkg_install_many wl-clipboard cliphist
