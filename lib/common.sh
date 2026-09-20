#!/bin/bash
# Подключается через `source` из install.sh каждого пакета.
# Не имеет смысла запускать напрямую.

log_info()  { echo -e "\033[1;34m[i]\033[0m $*"; }
log_ok()    { echo -e "\033[1;32m[✓]\033[0m $*"; }
log_warn()  { echo -e "\033[1;33m[!]\033[0m $*"; }
log_err()   { echo -e "\033[1;31m[x]\033[0m $*" >&2; }

# Проверка, установлен ли пакет через pacman
is_installed() {
    pacman -Qi "$1" &>/dev/null
}

# Установка пакета: yay если есть (для AUR), иначе pacman
pkg_install() {
    local pkg="$1"
    if is_installed "$pkg"; then
        log_ok "$pkg уже установлен"
        return 0
    fi
    log_info "Устанавливаю $pkg..."
    if command -v yay &>/dev/null; then
        yay -S --noconfirm --needed "$pkg"
    else
        sudo pacman -S --noconfirm --needed "$pkg"
    fi
}

# Установка нескольких пакетов одной строкой: pkg_install_many hyprland hyprpaper hyprlock
pkg_install_many() {
    local pkg
    for pkg in "$@"; do
        pkg_install "$pkg"
    done
}

# Хардлинкает один файл src -> dst (то же самое содержимое, тот же inode).
# В отличие от symlink, hardlink не зависит от исходного пути: если src
# позже удалят, dst как физический файл останется цел, пока жива хотя бы
# одна ссылка на inode. Правки с любой из двух сторон видны сразу же,
# т.к. это буквально один и тот же файл на диске.
# Ограничение: работает только в пределах одной файловой системы/раздела
# (обычно repo и ~/.config на одном разделе — проблем не будет). Если
# hardlink невозможен (разные ФС), делаем плановый fallback на copy —
# тогда правки уже не синхронизируются автоматически, только backup спасёт.
_hardlink_file() {
    local src="$1"
    local dst="$2"

    if [ -e "$dst" ] && [ "$(stat -c %i "$src" 2>/dev/null)" = "$(stat -c %i "$dst" 2>/dev/null)" ]; then
        # Уже тот же inode — нечего делать
        return 0
    fi

    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        local backup="${dst}.bak.$(date +%s)"
        log_warn "$dst уже существует, делаю backup -> $backup"
        mv "$dst" "$backup"
    fi

    rm -f "$dst"

    if ln "$src" "$dst" 2>/dev/null; then
        log_ok "Захардлинкано: $dst -> $src"
    else
        log_warn "Hardlink не удался (другой раздел/ФС?), копирую вместо этого: $dst"
        cp "$src" "$dst"
    fi
}

# Рекурсивно хардлинкает все файлы из src (каталог) в dst, повторяя структуру
# подпапок. Директории сами по себе хардлинкать нельзя (ограничение Linux) —
# поэтому пересоздаются как обычные каталоги, а хардлинкается каждый файл
# внутри по отдельности.
hardlink_tree() {
    local src="$1"
    local dst="$2"

    mkdir -p "$dst"

    local entry rel_path target
    while IFS= read -r -d '' entry; do
        rel_path="${entry#"$src"/}"
        target="$dst/$rel_path"

        if [ -d "$entry" ]; then
            mkdir -p "$target"
        else
            mkdir -p "$(dirname "$target")"
            _hardlink_file "$entry" "$target"
        fi
    done < <(find "$src" -mindepth 1 -print0)

    log_ok "Конфиг связан hardlink'ами: $dst <- $src (файлы физически общие, папку src можно удалить без потери $dst)"
}

# Линкует конфиг из packages/<name>/config/<rel> в ~/.config/<rel> хардлинками
# (файл за файлом), а не симлинком на каталог — так конфиг переживёт удаление
# папки со скриптами. Если целевой путь уже существует и это не тот же файл —
# делаем backup. Автоматически мигрирует со старой symlink-схемы.
# Использование (внутри install.sh пакета):
#   link_config "hypr" "$PKG_DIR/config/hypr"
link_config() {
    local rel="$1"                # имя внутри ~/.config, напр. "hypr"
    local src="$2"                # абсолютный путь к packages/<name>/config/<rel>
    local dst="$HOME/.config/$rel"

    if [ ! -e "$src" ]; then
        log_err "Источник конфига не найден: $src"
        return 1
    fi

    mkdir -p "$(dirname "$dst")"

    if [ -L "$dst" ]; then
        # Старая схема (симлинк на каталог) — конвертируем в независимые hardlink'и
        log_warn "$dst — старый symlink на конфиг, конвертирую в независимые hardlink'и"
        rm "$dst"
    fi

    if [ -f "$src" ]; then
        _hardlink_file "$src" "$dst"
        return
    fi

    hardlink_tree "$src" "$dst"
}

# Копирует src -> dst только если dst ещё не существует (для файлов,
# которыми потом управляет само приложение, например state/settings.toml)
seed_file() {
    local src="$1" dst="$2"
    if [ ! -e "$src" ]; then
        log_err "Источник не найден: $src"
        return 1
    fi
    if [ -e "$dst" ]; then
        log_ok "$dst уже есть — не трогаю"
        return 0
    fi
    mkdir -p "$(dirname "$dst")"
    cp -r "$src" "$dst"
    log_ok "Скопировано: $src -> $dst"
}

