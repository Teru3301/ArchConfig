#!/bin/bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

pkg_install fastfetch

mkdir -p ~/.config/fastfetch &&\
    wget -O ~/.config/fastfetch/config.jsonc https://raw.githubusercontent.com/dacrab/fastfetch-config/main/config.jsonc

