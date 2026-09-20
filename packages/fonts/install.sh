#!/bin/bash
# Шрифты для повседневной работы:
#   1. Офисный минимум — замены Times New Roman / Arial / Courier New,
#      совместимые по метрике (документы не "съезжают" при открытии .docx)
#   2. Цветные эмодзи (иначе в браузере/мессенджерах вместо картинок —
#      чёрно-белые контуры/квадратики)
#   3. Nerd Font для терминала/waybar (иконки в статус-баре и промпте)
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "$DIR/../../lib/common.sh" ]; then
    # shellcheck source=/dev/null
    source "$DIR/../../lib/common.sh"
else
    log_info()  { echo -e "\033[1;34m[i]\033[0m $*"; }
    log_ok()    { echo -e "\033[1;32m[✓]\033[0m $*"; }
    log_warn()  { echo -e "\033[1;33m[!]\033[0m $*"; }
    log_err()   { echo -e "\033[1;31m[x]\033[0m $*" >&2; }
    is_installed() { pacman -Qi "$1" &>/dev/null; }
    pkg_install() {
        local pkg="$1"
        if is_installed "$pkg"; then log_ok "$pkg уже установлен"; return 0; fi
        log_info "Устанавливаю $pkg..."
        if command -v yay &>/dev/null; then yay -S --noconfirm --needed "$pkg"
        else sudo pacman -S --noconfirm --needed "$pkg"; fi
    }
    pkg_install_many() { local p; for p in "$@"; do pkg_install "$p"; done; }
fi

# ---------------------------------------------------------------------------
# 1. Офисный минимум: кириллица/латиница + метрически совместимые замены
#    MS-шрифтов (Liberation Serif = Times New Roman, Liberation Sans = Arial,
#    Liberation Mono = Courier New) — оба пакета в официальных репах Arch.
# ---------------------------------------------------------------------------
pkg_install_many \
    ttf-liberation \
    noto-fonts \
    ttf-dejavu

# Настоящие MS-шрифты (пиксель-в-пиксель как в Windows/Word) — только AUR,
# зависит от внешнего источника, поэтому best-effort и не валит весь скрипт.
if command -v yay &>/dev/null; then
    if ! is_installed ttf-ms-fonts && ! is_installed ttf-ms-win11-auto-install; then
        log_info "Пробую поставить оригинальные MS-шрифты (Times New Roman и др.) из AUR..."
        yay -S --noconfirm --needed ttf-ms-fonts || \
            log_warn "Не удалось поставить ttf-ms-fonts из AUR (частая проблема — битые ссылки)." \
                     "Liberation Serif как замена Times New Roman уже стоит и метрически совместим."
    else
        log_ok "Оригинальные MS-шрифты уже установлены"
    fi
else
    log_warn "yay не найден — пропускаю оригинальные MS-шрифты, используется Liberation (метрическая замена)"
fi

# ---------------------------------------------------------------------------
# 2. Цветные эмодзи
# ---------------------------------------------------------------------------
pkg_install noto-fonts-emoji

# Подстраховка: иногда fontconfig выбирает для эмодзи-диапазона другой
# (чёрно-белый/контурный) шрифт раньше цветного Noto Color Emoji.
#
# ВАЖНО про расположение файла:
#   - /etc/fonts/conf.d/NN-*.conf читаются В ПОРЯДКЕ НОМЕРОВ, и именно
#     здесь определяются реальные шрифты для generic-алиасов (sans-serif,
#     serif, monospace) — обычно в файлах с номерами 45+/60+.
#   - Если положить наше правило в conf.d с маленьким номером (было:
#     01-emoji-priority.conf), оно выполнится ДО того как реальные шрифты
#     попадут в список — Noto Color Emoji окажется первым/единственным
#     кандидатом на этом этапе, а не последним, несмотря на binding=weak.
#     Для kitty (и любого приложения, берущего метрики ячейки из первого
#     разрешённого monospace-шрифта) это фатально — битмап-шрифт без
#     нормальных моноширинных метрик и он падает при старте.
#   - /etc/fonts/local.conf подключается ПОСЛЕДНИМ (после всего conf.d/)
#     по дизайну fontconfig — поэтому наш append оказывается в конце
#     списка фолбэков, где ему и место.
LOCAL_CONF=/etc/fonts/local.conf
LOCAL_CONF_CONTENT='<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <match target="pattern">
    <test qual="any" name="family"><string>sans-serif</string></test>
    <edit name="family" mode="append" binding="weak"><string>Noto Color Emoji</string></edit>
  </match>
  <match target="pattern">
    <test qual="any" name="family"><string>serif</string></test>
    <edit name="family" mode="append" binding="weak"><string>Noto Color Emoji</string></edit>
  </match>
  <match target="pattern">
    <test qual="any" name="family"><string>monospace</string></test>
    <edit name="family" mode="append" binding="weak"><string>Noto Color Emoji</string></edit>
  </match>
</fontconfig>'

# Убираем старый (проблемный) файл, если остался от прошлой версии скрипта
OLD_CONF=/etc/fonts/conf.d/01-emoji-priority.conf
if [ -f "$OLD_CONF" ]; then
    sudo rm -f "$OLD_CONF"
    log_warn "Удалён устаревший $OLD_CONF (читался слишком рано, ломал monospace для kitty)"
fi

if [ ! -f "$LOCAL_CONF" ] || ! diff -q <(echo "$LOCAL_CONF_CONTENT") "$LOCAL_CONF" &>/dev/null; then
    echo "$LOCAL_CONF_CONTENT" | sudo tee "$LOCAL_CONF" > /dev/null
    log_ok "Приоритет цветных эмодзи прописан ($LOCAL_CONF)"
else
    log_ok "Приоритет цветных эмодзи уже настроен"
fi

# ---------------------------------------------------------------------------
# 3. Nerd Font для терминала/waybar (иконки в статус-баре, промпте и т.п.)
# ---------------------------------------------------------------------------
if fc-list | grep -qi "JetBrains Mono.*Nerd"; then
    log_ok "JetBrains Mono Nerd Font уже установлен"
elif pacman -Si ttf-jetbrains-mono-nerd &>/dev/null; then
    pkg_install ttf-jetbrains-mono-nerd
else
    log_info "ttf-jetbrains-mono-nerd нет в репозиториях, качаю вручную..."
    FONT_DIR="$HOME/.local/share/fonts/JetBrainsMono"
    mkdir -p "$FONT_DIR"
    tmpzip="$(mktemp)"
    curl -fLo "$tmpzip" \
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip"
    unzip -qo "$tmpzip" -d "$FONT_DIR"
    find "$FONT_DIR" -type f ! -name "*Regular*" -delete
    rm "$tmpzip"
    log_ok "JetBrains Mono Nerd Font установлен вручную"
fi

# ---------------------------------------------------------------------------
# Обновляем кэш шрифтов
# ---------------------------------------------------------------------------
fc-cache -f > /dev/null
log_ok "Все шрифты установлены, кэш обновлён"

echo ""
echo "Проверить эмодзи:      fc-match emoji"
echo "Проверить Times New Roman: fc-match 'Times New Roman'"
echo "Список всех шрифтов:   fc-list | less"
