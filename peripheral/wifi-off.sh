#!/bin/bash
# Disable wifi
# Usage: wifi-off.sh

command -v nmcli >/dev/null 2>&1 || { echo "Command 'nmcli' not found."; exit 1; }
sudo nmcli radio wifi off
echo "dtoverlay=disable-wifi" | sudo tee -a /boot/firmware/config.txt > /dev/null

exit 0

# EOF
