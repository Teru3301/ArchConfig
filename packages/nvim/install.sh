#!/bin/bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

pkg_install neovim

# nvim-treesitter (ветка main, Neovim 0.12+) собирает парсеры локально:
# нужны tree-sitter-cli (из pacman, не из npm) и C-компилятор
pkg_install_many tree-sitter-cli gcc

link_config "nvim" "$DIR/config/nvim"

nvim --headless "+Lazy! sync" +qa

