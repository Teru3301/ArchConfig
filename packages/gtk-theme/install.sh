#!/bin/bash
# Тема + иконки + GUI-переключатель — устанавливаются вместе, т.к. по
# отдельности lxappearance нечего переключать.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

pkg_install_many materia-gtk-theme papirus-icon-theme adw-gtk-theme

gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

