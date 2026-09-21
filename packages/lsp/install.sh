#!/bin/bash
# Языковые серверы общего назначения, не привязанные к отдельному toolchain-пакету.
# ccls -> packages/cpp, gopls -> packages/go, pyright -> packages/python,
# omnisharp -> packages/dotnet (лежат рядом со своим SDK/компилятором).
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

# npm нужен как рантайм для части JS-based серверов ниже
pkg_install npm

pkg_install tree-sitter

pkg_install_many \
    bash-language-server \
    dockerfile-language-server \
    typescript-language-server \
    vscode-langservers-extracted \
    lua-language-server \
    yaml-language-server \
    rust-analyzer

# Примечание: отдельного "html-languageserver" сознательно нет — в Arch
# он называется vscode-html-languageserver и даёт те же бинарники, что уже
# входят в vscode-langservers-extracted (общий апстрим). Ставить оба —
# конфликт файлов пакетов при pacman.
