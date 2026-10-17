#!/bin/bash
# Enable bluetooth
# Usage: bluetooth-on.sh

[ $(id -u) -ne 0 ] && { echo "This script requires admin privileges."; exit 1; }

sed -i '/dtoverlay=disable-bt/d' /boot/firmware/config.txt
systemctl unmask bluetooth
systemctl enable bluetooth

echo "Bluetooth disabled. Restart may be required."

exit 0

# EOF
