#!/bin/bash
# GUI поверх NetworkManager: редактор соединений + апплет с иконкой в трее.
# Сам NetworkManager сюда не входит — предполагается, что уже стоит
# (на него завязан packages/dns-resolver).
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

pkg_install_many nm-connection-editor network-manager-applet
