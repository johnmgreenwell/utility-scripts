#!/bin/bash
# Install and setup xrdp
# Usage: rdp-init.sh

if which xrdp >/dev/null 2>&2; then
  echo "XRDP is already installed."
else
  echo "Installing XRDP."
  sudo apt update
  sudo apt install xrdp -y
  sudo systemctl enable xrdp
  sudo systemctl start xrdp
  echo "gnome-session" > ~/.xsession
  sudo adduser xrdp ssl-cert
fi

which xrdp >/dev/null 2>&2 && { sudo ufw allow 3389; exit 0; } || { echo "Failed to install XRDP."; exit 1; }

# EOF
