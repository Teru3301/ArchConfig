#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

PACKAGES_FILE="$SCRIPT_DIR/packages.txt"
PACKAGES_DIR="$SCRIPT_DIR/packages"
STATE_FILE="$SCRIPT_DIR/.installed"
touch "$STATE_FILE"

DRY_RUN=false
FORCE=false
ONLY=""

usage() {
    cat <<EOF
Использование: ./setup.sh [опции]

  --dry-run       Показать план (что будет установлено), ничего не делать
  --force         Переустановить/перенастроить даже то, что уже отмечено как готовое
  --only=NAME     Выполнить только один пакет (по имени папки в packages/)
  -h, --help      Эта справка
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run) DRY_RUN=true; shift ;;
        --force) FORCE=true; shift ;;
        --only=*) ONLY="${1#--only=}"; shift ;;
        -h|--help) usage; exit 0 ;;
        *) log_err "Неизвестный флаг: $1"; usage; exit 1 ;;
    esac
done

if [ ! -f "$PACKAGES_FILE" ]; then
    log_err "Не найден $PACKAGES_FILE"
    exit 1
fi

# Список имён пакетов: пустые строки и строки с # игнорируются
mapfile -t NAMES < <(grep -vE '^\s*(#|$)' "$PACKAGES_FILE")

if [ ${#NAMES[@]} -eq 0 ]; then
    log_warn "packages.txt пуст, нечего делать"
    exit 0
fi

FAILED=()

for name in "${NAMES[@]}"; do
    name="$(echo "$name" | xargs)" # trim пробелов

    if [ -n "$ONLY" ] && [ "$name" != "$ONLY" ]; then
        continue
    fi

    dir="$PACKAGES_DIR/$name"
    install_script="$dir/install.sh"

    if [ ! -d "$dir" ]; then
        log_err "packages/$name не найдена, но указана в packages.txt — пропускаю"
        FAILED+=("$name (нет папки)")
        continue
    fi

    if [ ! -f "$install_script" ]; then
        log_err "Нет install.sh в packages/$name — пропускаю"
        FAILED+=("$name (нет install.sh)")
        continue
    fi

    if grep -qxF "$name" "$STATE_FILE" 2>/dev/null && [ "$FORCE" = false ]; then
        log_ok "$name уже настроен ранее — пропускаю (--force чтобы повторить)"
        continue
    fi

    echo ""
    log_info "=== $name ==="

    if [ "$DRY_RUN" = true ]; then
        echo "  (dry-run) выполнил бы: $install_script"
        continue
    fi

    chmod +x "$install_script"
    if (cd "$dir" && PKG_DIR="$dir" "$install_script"); then
        grep -qxF "$name" "$STATE_FILE" || echo "$name" >> "$STATE_FILE"
        log_ok "$name готов"
    else
        log_err "Ошибка при установке $name"
        FAILED+=("$name (ошибка выполнения)")
    fi
done

if [ "$DRY_RUN" = true ]; then
    exit 0
fi

echo ""
if [ ${#FAILED[@]} -gt 0 ]; then
    log_warn "Завершено с ошибками:"
    for f in "${FAILED[@]}"; do echo "  - $f"; done
else
    log_ok "Все пакеты из packages.txt обработаны успешно"
fi

log_info "Не забудь раскомментировать [multilib] в /etc/pacman.conf, если ещё не сделано"
read -rp "Выполнить 'sudo pacman -Syu' и 'sudo mkinitcpio -P' сейчас? [y/N] " ans
if [[ "$ans" =~ ^[Yy]$ ]]; then
    sudo pacman -Syu
    sudo mkinitcpio -P
fi
