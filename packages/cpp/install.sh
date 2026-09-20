#!/bin/bash
# C/C++ toolchain одним куском: компиляторы, сборка, отладка, LSP.
# Раньше gcc/clang/cmake/make/ninja/ccls были отдельными пакетами —
# собрано вместе, т.к. это одна связка и обычно ставится/обновляется разом.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

# Компиляторы
pkg_install_many gcc clang

# Сборка
pkg_install_many cmake make ninja

# Отладка
pkg_install gdb

# bear — генерирует compile_commands.json для make-проектов без CMake,
# без него ccls/clangd не проиндексируют такой проект нормально
pkg_install bear

# LSP для C/C++
pkg_install ccls
