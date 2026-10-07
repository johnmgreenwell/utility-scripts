#!/bin/bash
# Install and setup xrdp
# Usage: rdp-init.sh <PORT_NUM>

PORT_NUM="${1:-3389}"

[ $(id -u) -ne 0 ] && { echo "This script requires admin privileges."; exit 1; }

if which xrdp >/dev/null 2>&1; then
  echo "XRDP is already installed."
else
  echo "Installing XRDP."
  apt update || { echo "Failed to update. Exiting..."; exit 2; }
  apt install xrdp -y || { echo "Failed to install xrdp."; exit 3; }
  echo "gnome-session" > ~/.xsession
  adduser xrdp ssl-cert
  systemctl enable xrdp
  systemctl start xrdp
fi

if which xrdp >/dev/null 2>&2; then
  echo "Setting RDP firewall port allowance to $PORT_NUM..."
  ufw allow $PORT_NUM
  systemctl restart ssh
else
  echo "Failed to install XRDP."
  exit 2
fi

exit 0

# EOF
