#!/bin/bash
# Disable wifi
# Usage: wifi-off.sh

[ $(id -u) -ne 0 ] && { echo "This script requires admin privileges."; exit 1; }

command -v nmcli >/dev/null 2>&1 || { echo "Command 'nmcli' not found."; exit 2; }
sudo nmcli radio wifi off
echo "dtoverlay=disable-wifi" | sudo tee -a /boot/firmware/config.txt > /dev/null

echo "Wifi disabled. Restart may be required."

exit 0

# EOF
