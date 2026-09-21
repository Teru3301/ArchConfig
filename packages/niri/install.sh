#!/bin/bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

# ВАЖНО: этот package/niri раньше отсутствовал, хотя был указан в
# packages.txt — setup.sh молча его пропускал ("packages/niri не найдена").
# Поэтому niri у вас фактически никогда не проходил через этот установщик,
# и связанные с ним настройки портала не применялись.

pkg_install_many niri xwayland-satellite

CONF_DIR="$HOME/.config/niri"
CONF_FILE="$CONF_DIR/config.kdl"
mkdir -p "$CONF_DIR"

link_config "niri" "$DIR/config/niri"

if [ ! -f "$CONF_FILE" ]; then
    log_warn "$CONF_FILE не найден — создаю базовый файл (будет предложен niri по умолчанию при первом запуске, если его нет)"
    touch "$CONF_FILE"
fi

# Явный импорт окружения в systemd/DBus нужен, чтобы xdg-desktop-portal
# (и, соответственно, OBS) увидели актуальные WAYLAND_DISPLAY и
# XDG_CURRENT_DESKTOP этой сессии. При запуске через `niri-session` / `niri
# --session` niri делает это сам, но одна лишняя явная строка ничего не
# ломает и подстраховывает на случай, если niri запускается иначе (например,
# напрямую из .xinitrc/exec без --session).
MARKER="dbus-update-activation-environment"
if ! grep -qF "$MARKER" "$CONF_FILE"; then
    log_info "Добавляю spawn-at-startup для dbus-update-activation-environment в $CONF_FILE"
    cat >> "$CONF_FILE" <<'EOF'

// Добавлено установщиком: гарантирует, что WAYLAND_DISPLAY/XDG_CURRENT_DESKTOP
// доедут до systemd --user и DBus, иначе xdg-desktop-portal-wlr не видит
// текущую сессию и OBS не показывает источник "Захват экрана (PipeWire)".
spawn-at-startup "dbus-update-activation-environment" "--systemd" "--all"
EOF
else
    log_ok "spawn-at-startup для dbus-update-activation-environment уже есть в конфиге"
fi

# ГОНКА ПРИ СТАРТЕ: xdg-desktop-portal.service активируется по DBus почти
# сразу после старта niri-session (его дёргает что-нибудь из автозапуска —
# панель, апплет и т.п.), и в этот момент xdg-desktop-portal-wlr.service
# может ещё не пройти свой ConditionEnvironment=WAYLAND_DISPLAY, т.к.
# импорт окружения в systemd --user ещё не успел завершиться. Итог: wlr так
# и остаётся "inactive (dead)" на весь остаток сессии, портал молча падает
# на gtk-бэкенд, который не умеет ScreenCast — OBS/Discord не видят источники
# захвата экрана вообще, без единой ошибки в интерфейсе.
#
# Лечится форс-рестартом wlr-портала уже ПОСЛЕ того, как окружение точно
# импортировано (с небольшой задержкой, чтобы гарантированно проиграть гонку).
RESTART_MARKER="restart\" \"xdg-desktop-portal-wlr"
if ! grep -qF "$RESTART_MARKER" "$CONF_FILE"; then
    log_info "Добавляю spawn-at-startup для форс-рестарта xdg-desktop-portal-wlr в $CONF_FILE"
    cat >> "$CONF_FILE" <<'EOF'

// Добавлено установщиком: чинит гонку между стартом niri-session и первой
// DBus-активацией xdg-desktop-portal — без этого xdg-desktop-portal-wlr
// может так и остаться "inactive (dead)" всю сессию, и ScreenCast в OBS/
// Discord будет пустым (см. `systemctl --user status xdg-desktop-portal-wlr`).
spawn-at-startup "sh" "-c" "sleep 3 && systemctl --user restart xdg-desktop-portal-wlr xdg-desktop-portal"
EOF
else
    log_ok "spawn-at-startup для форс-рестарта xdg-desktop-portal-wlr уже есть в конфиге"
fi

# --- Чистка xdg-desktop-portal-gnome -------------------------------------
# niri зависит не лично на xdg-desktop-portal-gnome, а на виртуальный пакет
# xdg-desktop-portal-impl — его уже закрывают xdg-desktop-portal-wlr и
# xdg-desktop-portal-hyprland (оба официально Provides: xdg-desktop-portal-impl,
# см. archlinux.org). Поэтому gnome-портал можно снести обычным pacman -Rns
# (без форса), pacman не будет ругаться на сломанные зависимости — а заодно
# уйдут пакеты, доставленные только ради него (nautilus он же "Файлы",
# gnome-desktop-4, libadwaita, graphene). Раз зависимость niri виртуальная
# и уже закрыта другими провайдерами — pacman -Syu не притащит его обратно,
# отдельный pacman hook для этого не нужен.
if is_installed xdg-desktop-portal-gnome; then
    log_warn "xdg-desktop-portal-gnome установлен — сношу вместе с шлейфом (nautilus, gnome-desktop-4, libadwaita и т.п.)"
    sudo pacman -Rns --noconfirm xdg-desktop-portal-gnome
fi

cat <<'EOF'

[!] Как ПРАВИЛЬНО запускать niri, чтобы работал захват экрана:
    - из display manager (GDM/SDDM/greetd) выбрать сессию "niri" (.desktop
      ставится пакетом сам) — это самый надёжный вариант, он использует
      niri-session и сам поднимает graphical-session.target;
    - либо из TTY командой `niri-session` (systemd) — НЕ голым `niri`.
      Голый `niri` без --session/-session НЕ импортирует окружение в
      systemd/DBus, и портал не увидит сессию вообще, даже с правильным
      portals.conf.

[!] После первого входа в niri проверьте активный бэкенд ScreenCast:
    busctl --user introspect org.freedesktop.portal.Desktop \
        /org/freedesktop/portal/desktop | grep -i screencast
    Должен резолвиться в xdg-desktop-portal-wlr. xdg-desktop-portal-gnome
    в системе сознательно не держим — его зависимость перед niri (виртуальный
    xdg-desktop-portal-impl) уже закрыта wlr/hyprland, поэтому pacman -Syu
    его не вернёт.
EOF

log_ok "niri настроен"
