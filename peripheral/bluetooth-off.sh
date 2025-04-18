#!/bin/bash
# Disable bluetooth
# Usage: bluetooth-off.sh

sudo systemctl disable bluetooth
sudo systemctl mask bluetooth
echo "dtoverlay=disable-bt" | sudo tee -a /boot/firmware/config.txt > /dev/null

# EOF
