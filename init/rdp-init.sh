#!/bin/bash
# Install and setup xrdp
# Usage: rdp-init.sh

[ $(id -u) -ne 0 ] && { echo "This script requires admin privileges."; exit 1; }

if which xrdp >/dev/null 2>&1; then
  echo "XRDP is already installed."
else
  echo "Installing XRDP."
  sudo apt update || { echo "Failed to update. Exiting..."; exit 1; }
  sudo apt install xrdp -y || { echo "Failed to install xrdp."; exit 1; }
  echo "gnome-session" > ~/.xsession
  sudo adduser xrdp ssl-cert
  sudo systemctl enable xrdp
  sudo systemctl start xrdp
fi

which xrdp >/dev/null 2>&2 && { sudo ufw allow 3389; exit 0; } || { echo "Failed to install XRDP."; exit 1; }

# EOF
