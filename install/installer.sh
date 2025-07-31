#!/bin/bash

sudo pacman -S --noconfirm git

if ! is_package_installed "yay"; then
    echo "Установка yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/yay
    echo "yay установлен!"
    echo " "
fi


is_package_installed () {
    pacman -Qi "$1" &> /dev/null
    return $?
}


PKGM_FILE="package_managers.txt"
if [ ! -f "$PKGM_FILE" ]; then
    echo "e1. f ${PKGM_FILE} nf"
    exit 1
fi
readarray -t PKGM < "$PKGM_FILE"


PKGS_FILE="packages.txt"
if [ ! -f "$PKGS_FILE" ]; then
    echo "e2. f ${PKGS_FILE} nf"
    exit 1
fi
readarray -t PKGS < "$PKGS_FILE"


for pkg in "${PKGS[@]}"; do
    echo "Проверка наличия пакета  -  ${pkg}"
    if is_package_installed "$pkg"; then
        echo "Пакет установлен."
    else
        for pkgm in "${PKGM[@]}"; do
            echo "Установка пакета с помощью ${pkgm}..."
            if sudo $pkgm -S --noconfirm "$pkg"; then
                echo "Установка завершена"
                break
            else
                echo "Ошибка"
            fi
        done
    fi
    echo " "
done


if [ "$(id -u)" -eq 0 ]; then
    exec sudo -u $SUDO_USER "$0" "$@"
    exit
fi
