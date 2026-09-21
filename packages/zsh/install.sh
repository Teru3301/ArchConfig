#!/bin/bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

pkg_install zsh

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    log_ok "oh-my-zsh уже установлен"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_if_missing() {
    local repo="$1" dest="$2"
    if [ -d "$dest" ]; then
        log_ok "$(basename "$dest") уже установлен"
    else
        git clone --depth=1 "$repo" "$dest"
    fi
}

clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_if_missing https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_if_missing https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

sed -i 's/^plugins=(.*)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' "$HOME/.zshrc"
sed -i 's|^ZSH_THEME=".*"|ZSH_THEME="powerlevel10k/powerlevel10k"|' "$HOME/.zshrc"

# Алиасы: хардлинк из репозитория в $ZSH_CUSTOM. oh-my-zsh сам подхватывает
# все *.zsh из этой папки (после плагинов), так что .zshrc трогать не нужно.
# Если там уже лежит обычный файл — _hardlink_file сделает backup .bak.<timestamp>.
mkdir -p "$ZSH_CUSTOM"
_hardlink_file "$DIR/config/aliases.zsh" "$ZSH_CUSTOM/aliases.zsh"

log_ok "zsh настроен. Смени шелл вручную: chsh -s $(command -v zsh)"

