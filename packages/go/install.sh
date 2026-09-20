#!/bin/bash
# Go toolchain: компилятор, доп. инструменты, отладчик, LSP — вместе,
# т.к. gopls/delve без установленного go всё равно бесполезны.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

pkg_install go
pkg_install go-tools     # staticcheck и другие линтеры/анализаторы
pkg_install delve        # отладчик (dlv)
pkg_install gopls        # LSP для Go
