#!/bin/bash
# Enable bluetooth
# Usage: bluetooth-on.sh

sudo sed -i '/dtoverlay=disable-bt/d' /boot/firmware/config.txt
sudo systemctl unmask bluetooth
sudo systemctl enable bluetooth

# EOF
