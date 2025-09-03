#!/bin/bash
# Enable wifi
# Usage: wifi-on.sh

command -v nmcli >/dev/null 2>&1 || { echo "Command 'nmcli' not found."; exit 1; }
sudo sed -i '/dtoverlay=disable-wifi/d' /boot/firmware/config.txt
sudo nmcli radio wifi on

exit 0

# EOF
