#!/bin/bash

#if [ "$(id -u)" -eq 0 ]; then
#    echo "Этот скрипт не должен запускаться с root-правами" >&2
#    exit 1
#fi

echo "copy config"
sudo cp swayimg/swayimg-thunar /usr/local/bin/
sudo mkdir -p ~/.local/share/applications
sudo cp swayimg/swayimg-folder.desktop ~/.local/share/applications/

cp swayimg/mimeapps.list ~/.config/
