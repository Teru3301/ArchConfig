#!/bin/bash

if lsblk -o TRAN | grep -q "usb"; then
    echo "USB"
else
    echo ""
fi

