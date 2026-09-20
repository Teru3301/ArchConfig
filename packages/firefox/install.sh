#!/bin/bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

pkg_install firefox

FIREFOX_DIR="$HOME/.mozilla/firefox"
PROFILES_INI="$FIREFOX_DIR/profiles.ini"

# --- 1. Гарантируем, что профиль существует ---
if [[ ! -f "$PROFILES_INI" ]]; then
    echo ">>> Инициализация профиля Firefox (headless запуск)..."
    mkdir -p "$FIREFOX_DIR"
    # --screenshot заставляет Firefox запуститься, создать профиль и выйти
    firefox --headless --screenshot /tmp/firefox-init.png about:blank \
        >/dev/null 2>&1 || true
    rm -f /tmp/firefox-init.png
fi

# --- 2. Находим дефолтный профиль ---
PROFILE_DIR=""
if [[ -f "$PROFILES_INI" ]]; then
    PROFILE_NAME=$(awk -F= '/^Default=/{print $2; exit}' "$PROFILES_INI")
    [[ -n "${PROFILE_NAME:-}" && -d "$FIREFOX_DIR/$PROFILE_NAME" ]] \
        && PROFILE_DIR="$FIREFOX_DIR/$PROFILE_NAME"
fi

# Фолбэк — ищем по маске
if [[ -z "$PROFILE_DIR" ]]; then
    PROFILE_DIR=$(find "$FIREFOX_DIR" -maxdepth 1 -type d -name '*default*' 2>/dev/null | head -n1)
fi

if [[ -z "$PROFILE_DIR" ]]; then
    echo "!! Не удалось найти профиль Firefox в $FIREFOX_DIR" >&2
    echo "   Запустите firefox вручную один раз и перезапустите установку." >&2
    exit 1
fi

# --- 3. Проверяем, не запущен ли Firefox ---
if pgrep -x firefox >/dev/null; then
    echo "!! Firefox запущен. Закройте его перед применением настроек." >&2
    exit 1
fi

# --- 4. Копируем user.js с бэкапом ---
USER_JS="$PROFILE_DIR/user.js"

if [[ -f "$USER_JS" ]]; then
    BACKUP="$USER_JS.bak.$(date +%Y%m%d-%H%M%S)"
    echo ">>> Бэкап существующего user.js -> $BACKUP"
    cp "$USER_JS" "$BACKUP"
fi

cp "$DIR/config/user.js" "$USER_JS"
echo ">>> Настройки применены: $USER_JS"

