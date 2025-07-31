#!/bin/bash

echo "set terminal"
sudo ln -sf $(command -v kitty) /usr/bin/x-terminal-emulator && \
echo "done"

echo "copy config"
cp -r kitty ~/.config/
