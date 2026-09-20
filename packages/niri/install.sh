#!/bin/bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

# niri тянет xdg-desktop-portal-gnome как зависимость — это нормально:
# именно он нужен niri для записи экрана, так что здесь его не трогаем.
# Настройка бэкендов лежит в packages/xdg-portal.
pkg_install_many niri xwayland-satellite

CONF_DIR="$HOME/.config/niri"
CONF_FILE="$CONF_DIR/config.kdl"
mkdir -p "$CONF_DIR"

link_config "niri" "$DIR/config/niri"

if [ ! -f "$CONF_FILE" ]; then
    log_warn "$CONF_FILE не найден — создаю пустой файл (niri подставит значения по умолчанию)"
    touch "$CONF_FILE"
fi

# Явный импорт окружения в systemd/DBus: xdg-desktop-portal должен видеть
# актуальные WAYLAND_DISPLAY и XDG_CURRENT_DESKTOP этой сессии. При запуске
# через `niri-session` niri делает это сам, строка подстраховывает на случай
# другого способа запуска.
MARKER="dbus-update-activation-environment"
if ! grep -qF "$MARKER" "$CONF_FILE"; then
    log_info "Добавляю spawn-at-startup для dbus-update-activation-environment в $CONF_FILE"
    cat >> "$CONF_FILE" <<'EOF'

// Добавлено установщиком: передаёт WAYLAND_DISPLAY/XDG_CURRENT_DESKTOP
// в systemd --user и DBus, чтобы xdg-desktop-portal видел текущую сессию.
spawn-at-startup "dbus-update-activation-environment" "--systemd" "--all"
EOF
else
    log_ok "spawn-at-startup для dbus-update-activation-environment уже есть в конфиге"
fi

cat <<'EOF'

[!] Как запускать niri, чтобы работал захват экрана:
    - из display manager (GDM/SDDM/greetd) выбрать сессию "niri";
    - либо из TTY командой `niri-session` (НЕ голым `niri`): без --session
      окружение не попадает в systemd/DBus, и портал не увидит сессию.

[!] После первого входа проверьте бэкенд ScreenCast:
    busctl --user introspect org.freedesktop.portal.Desktop \
        /org/freedesktop/portal/desktop | grep -i screencast
EOF

log_ok "niri настроен"

