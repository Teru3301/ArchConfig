#!/bin/bash

# Скрипт установки только JetBrains Mono Nerd Font для Neovim
# Возвращаемые коды:
# 0 - успех
# 1 - ошибка прав (не root)
# 2 - ошибка установки пакетов
# 3 - ошибка загрузки шрифтов

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

install_pkg() {
    local pkg=$1
    local install_cmd=${2:-"sudo pacman -S --noconfirm --needed"}
    
    if pacman -Qi "$pkg" &>/dev/null; then
        echo -e "${GREEN}[✓]${NC} $pkg уже установлен"
        return 0
    fi

    echo -e "${YELLOW}[~]${NC} Установка $pkg..."
    if ! $install_cmd "$pkg"; then
        echo -e "${RED}[×] Ошибка установки $pkg${NC}" >&2
        return 2
    fi
    echo -e "${GREEN}[✓]${NC} Успешно установлен $pkg"
}

install_jetbrains_nerd() {
    local font_dir="$HOME/.local/share/fonts/JetBrainsMono"
    
    mkdir -p "$font_dir"
    
    echo -e "${YELLOW}[~]${NC} Загрузка JetBrains Mono Nerd Font..."
    if ! curl -fLo "/tmp/JetBrainsMono.zip" \
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip"; then
        echo -e "${RED}[×] Ошибка загрузки шрифта${NC}" >&2
        return 3
    fi
    
    echo -e "${YELLOW}[~]${NC} Распаковка JetBrains Mono..."
    if ! unzip -qo "/tmp/JetBrainsMono.zip" -d "$font_dir"; then
        echo -e "${RED}[×] Ошибка распаковки${NC}" >&2
        return 3
    fi
    
    # Оставляем только Regular версию для экономии места
    find "$font_dir" -type f ! -name "*Regular*" -delete
    rm "/tmp/JetBrainsMono.zip"
    echo -e "${GREEN}[✓]${NC} JetBrains Mono Nerd Font установлен"
}

main() {
    echo -e "\n${YELLOW}=== Установка JetBrains Mono Nerd Font ===${NC}"
    
    # Установка через pacman (если есть в репозиториях)
    echo -e "\n${YELLOW}Проверка пакета ttf-jetbrains-mono-nerd...${NC}"
    if pacman -Si ttf-jetbrains-mono-nerd &>/dev/null; then
        install_pkg "ttf-jetbrains-mono-nerd" || return 2
    else
        echo -e "${YELLOW}[~]${NC} Пакет не найден, устанавливаем вручную"
        install_jetbrains_nerd || return 3
    fi

    # Обновление кэша шрифтов
    echo -e "\n${YELLOW}Обновление кэша шрифтов...${NC}"
    fc-cache -fv
    
    # Проверка установки
    echo -e "\n${YELLOW}Проверка установленных шрифтов:${NC}"
    if fc-list | grep -i "JetBrains Mono.*Nerd" >/dev/null; then
        echo -e "${GREEN}[✓] JetBrains Mono Nerd Font обнаружен${NC}"
    else
        echo -e "${RED}[×] Шрифт не найден!${NC}" >&2
        return 3
    fi

    echo -e "\n${GREEN}Готово! JetBrains Mono Nerd Font установлен.${NC}"
    echo -e "Настройте терминал на использование шрифта:"
    echo -e " - JetBrainsMono Nerd Font Mono (Regular)"
    
    return 0
}

main "$@"
exit $?
