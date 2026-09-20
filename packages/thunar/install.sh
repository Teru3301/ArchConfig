#!/bin/bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

pkg_install_many thunar thunar-archive-plugin tumbler thunar-media-tags-plugin thunar-volman

# gvfs — обязателен для монтирования флешек/сетевых шар и корзины из GUI
# (без него thunar-volman почти бесполезен). ffmpegthumbnailer — превью
# видеофайлов через tumbler.
pkg_install_many gvfs ffmpegthumbnailer

# Делаем Thunar файловым менеджером по умолчанию (xdg-mime, а не link_config —
# у Thunar нет своего каталога в ~/.config, который имело бы смысл симлинкать)
log_info "Устанавливаю Thunar как файловый менеджер по умолчанию (inode/directory)"
xdg-mime default thunar.desktop inode/directory
log_ok "xdg-mime query default inode/directory -> $(xdg-mime query default inode/directory)"
