#!/bin/bash
# Install and setup xrdp
# Usage: rdp-init.sh

if which xrdp >/dev/null 2>&1; then
  echo "XRDP is already installed."
else
  echo "Installing XRDP."
  sudo apt update || { echo "Failed to update. Exiting..."; exit 1; }
  sudo apt install xrdp -y || { echo "Failed to install xrdp."; exit 1; }
  sudo systemctl enable xrdp
  sudo systemctl start xrdp
  echo "gnome-session" > ~/.xsession
  sudo adduser xrdp ssl-cert
fi

which xrdp >/dev/null 2>&2 && { sudo ufw allow 3389; exit 0; } || { echo "Failed to install XRDP."; exit 1; }

# EOF
