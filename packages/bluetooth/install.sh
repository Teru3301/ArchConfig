#!/bin/bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

pkg_install bluez-utils 
# pkg_install blueman

sudo systemctl disable --now bluetooth.service
