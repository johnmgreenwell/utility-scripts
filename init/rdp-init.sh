#!/bin/bash
# Install and setup xrdp
# Usage: rdp-init.sh <PORT_NUM>

PORT_NUM="${1:-3389}"

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

if which xrdp >/dev/null 2>&2; then
  echo "Setting RDP firewall port allowance to $PORT_NUM..."
  sudo ufw allow $PORT_NUM
  sudo systemctl restart ssh
else
  echo "Failed to install XRDP."
  exit 2
fi

exit 0

# EOF
