#!/bin/bash

sudo sed -i '/dtoverlay=disable-wifi/d' /boot/firmware/config.txt
sudo nmcli radio wifi on

#EOF
