#!/bin/bash
# Enable bluetooth
# Usage: bluetooth-on.sh

[ $(id -u) -ne 0 ] && { echo "This script requires admin privileges."; exit 1; }

sudo sed -i '/dtoverlay=disable-bt/d' /boot/firmware/config.txt
sudo systemctl unmask bluetooth
sudo systemctl enable bluetooth

echo "Bluetooth disabled. Restart may be required."

exit 0

# EOF
