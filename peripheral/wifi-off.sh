#!/bin/bash

sudo nmcli radio wifi off
echo "dtoverlay=disable-wifi" | sudo tee -a /boot/firmware/config.txt > /dev/null

#EOF
