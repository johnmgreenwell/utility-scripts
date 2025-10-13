#!/bin/bash
# Enable wifi
# Usage: wifi-on.sh

[ $(id -u) -ne 0 ] && { echo "This script requires admin privileges."; exit 1; }

command -v nmcli >/dev/null 2>&1 || { echo "Command 'nmcli' not found."; exit 2; }
sudo sed -i '/dtoverlay=disable-wifi/d' /boot/firmware/config.txt
sudo nmcli radio wifi on

echo "Wifi enabled. Restart may be required."

exit 0

# EOF
