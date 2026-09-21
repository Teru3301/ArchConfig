#!/bin/bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

pkg_install yazi

mkdir -p ~/.config/environment.d
printf 'EDITOR=nvim\nVISUAL=nvim\n' > ~/.config/environment.d/editor.conf

link_config "yazi" "$DIR/config/yazi"

