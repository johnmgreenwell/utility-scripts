#!/bin/bash
# Enable wifi
# Usage: wifi-on.sh

sudo sed -i '/dtoverlay=disable-wifi/d' /boot/firmware/config.txt
sudo nmcli radio wifi on

# EOF
