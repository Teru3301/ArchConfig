#!/bin/bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

pkg_install waybar

# Перенесите сюда ваш реальный конфиг: setup/waybar/* -> packages/waybar/config/waybar/*
link_config "waybar" "$DIR/config/waybar"
