#!/bin/bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

pkg_install noctalia 

STATE="${XDG_STATE_HOME:-$HOME/.local/state}/noctalia"
seed_file "$DIR/state/settings.toml"  "$STATE/settings.toml"

