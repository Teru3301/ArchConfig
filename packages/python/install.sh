#!/bin/bash
# Python toolchain: интерпретатор, пакетный менеджер, окружения, линтер, LSP.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

pkg_install_many python python-pip python-virtualenv python-pylint

# LSP для Python
pkg_install pyright

# В официальных репах и AUR нет пакета с именем ровно "conda" — базовый
# пакет называется miniconda3 (он же Provides: conda, команда после
# установки та же). Если у вас уже стоит что-то другое (anaconda, mamba) —
# закомментируйте строку ниже.
if ! command -v conda &>/dev/null; then
    pkg_install miniconda3
    log_warn "conda установлена, но нужен один разовый шаг: conda init zsh (или bash) и перезапуск шелла"
else
    log_ok "conda уже доступна"
fi
