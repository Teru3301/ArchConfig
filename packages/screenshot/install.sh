#!/bin/bash
# Связка для скриншотов на wlroots-композиторах: grim (захват) + slurp
# (выделение области) + swappy (аннотирование) — используются вместе.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

pkg_install_many grim slurp swappy
