#!/bin/bash

MOUNT_BASE="$HOME/USBs"
DEVICE="$1"

LABEL=$(lsblk -no LABEL "$DEVICE")
[[ -z "$LABEL" ]] && LABEL=$(basename "$DEVICE")

MOUNT_POINT="$MOUNT_BASE/$LABEL"

if mount | grep -q "$MOUNT_POINT"; then
    sudo umount "$DEVICE"
    if [[ $? -eq 0 ]]; then
        rmdir "$MOUNT_POINT" 2>/dev/null
        notify-send "USB" "$DEVICE отмонтировано"
    else
        notify-send "USB" "Ошибка отмонтирования $DEVICE"
    fi
else
    mkdir -p "$MOUNT_POINT"
    sudo mount "$DEVICE" "$MOUNT_POINT"
    if [[ $? -eq 0 ]]; then
        notify-send "USB" "$DEVICE смонтировано в $MOUNT_POINT"
    else
        notify-send "USB" "Ошибка монтирования $DEVICE"
        rmdir "$MOUNT_POINT"
    fi
fi

