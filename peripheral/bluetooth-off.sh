#!/bin/bash
# Disable bluetooth
# Usage: bluetooth-off.sh

[ $(id -u) -ne 0 ] && { echo "This script requires admin privileges."; exit 1; }

systemctl disable bluetooth
systemctl mask bluetooth
echo "dtoverlay=disable-bt" | tee -a /boot/firmware/config.txt > /dev/null

echo "Bluetooth enabled. Restart may be required."

exit 0

# EOF
