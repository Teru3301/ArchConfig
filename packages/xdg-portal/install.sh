#!/bin/bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

# Бэкенды xdg-desktop-portal, которые нужны системе:
#   gnome    -> ScreenCast под niri (так рекомендует вики niri; niri сам
#               реализует нужный D-Bus интерфейс для этого портала)
#   hyprland -> ScreenCast/Screenshot под Hyprland
#   gtk      -> всё остальное (FileChooser, Settings и т.п.), общий fallback
#
# Какой бэкенд использовать в конкретной сессии, решают файлы
# <XDG_CURRENT_DESKTOP>-portals.conf из config/xdg-desktop-portal
# (niri-portals.conf, hyprland-portals.conf). Скрипт только ставит пакеты
# и ничего не удаляет.
pkg_install_many \
    xdg-desktop-portal-gnome \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk

# per-desktop portals.conf лежат в ~/.config/xdg-desktop-portal/
link_config "xdg-desktop-portal" "$DIR/config/xdg-desktop-portal"

log_info "Перезапускаю портал-стек, чтобы подхватились новые portals.conf"
systemctl --user daemon-reload || true
systemctl --user restart \
    xdg-desktop-portal \
    xdg-desktop-portal-gnome \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk 2>/dev/null || \
    log_warn "Не удалось перезапустить один из user-сервисов портала (возможно, сессия ещё не активна — применится при следующем логине)"

log_info "Обновляю dbus-activation-environment"
dbus-update-activation-environment --systemd --all 2>/dev/null || \
    log_warn "dbus-update-activation-environment не выполнился (нет активной DBus-сессии) — не критично, niri сделает это сам при старте"

log_ok "Готово. Проверить активный ScreenCast-бэкенд можно так:"
log_ok "  busctl --user introspect org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop | grep -i screencast"

