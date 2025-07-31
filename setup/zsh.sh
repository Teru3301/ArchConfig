#!/bin/bash

if ! command -v zsh &> /dev/null; then
    sudo pacman -S zsh || exit 1
fi
RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || exit 1
ZSH_CUSTOM="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"
if [ ! -d "${ZSH_CUSTOM}" ]; then
    echo "Error: Oh My Zsh custom directory not found!"
    exit 1
fi
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}"/plugins/zsh-syntax-highlighting || exit 1
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}"/plugins/zsh-autosuggestions || exit 1
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}"/themes/powerlevel10k || exit 1
sed -i 's/^plugins=(.*)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc
sed -i 's/^ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
echo "Setup zsh completed! Restart your shell to apply changes."

