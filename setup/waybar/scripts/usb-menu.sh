#!/bin/bash

# Получаем список USB-разделов (не устройств)
DEVICES=$(lsblk -rpo NAME,TYPE,TRAN | awk '$3=="usb" && $2=="part" {print $1}')

if [[ -z "$DEVICES" ]]; then
    notify-send "USB" "Нет USB разделов"
    exit 0
fi

MENU=""
for DEV in $DEVICES; do
    LABEL=$(lsblk -no LABEL "$DEV")
    [[ -z "$LABEL" ]] && LABEL=$(basename "$DEV")
    MENU+="$LABEL ($DEV)\n"
done

SELECTED=$(echo -e "$MENU" | wofi --dmenu --prompt "Выбери USB раздел" --width=500 --height=300)

[[ -z "$SELECTED" ]] && exit 0

# Извлечь имя устройства из строки
DEV=$(echo "$SELECTED" | grep -o '/dev/[a-zA-Z0-9]*')

# Вызвать скрипт монтирования/отмонтирования
~/.config/waybar/scripts/usb-mount-toggle.sh "$DEV"

