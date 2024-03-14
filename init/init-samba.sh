#!/bin/bash

if which samba >/dev/null 2>&2; then
  echo "Samba is already installed."
  exit 0
else
  echo "Installing samba."
  sudo apt install samba -y
fi

# Rename to target shared directory
sudo mkdir -p /mnt/hdd1/shared

echo "Updating smb.conf file with custom settings."
sudo cat >> /etc/samba/smb.conf <<- EOM
# Place custom server details here
# https://ubuntu.com/tutorials/install-and-configure-samba#3-setting-up-samba
EOM

# Replace with target device/directory
sudo mount /dev/sda1 /mnt/hdd1
sudo systemctl restart smbd.service nmbd.service

exit 0

# EOF
