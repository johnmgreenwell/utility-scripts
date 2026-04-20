#!/bin/bash
# Install openssh clinet and server and allow it through the firewall
# Usage: ssh-init.sh <PORT_NUM>

PORT_NUM="${1:-22}"

[ $(id -u) -ne 0 ] && { echo "This script requires admin privileges."; exit 1; }

if which ssh >/dev/null 2>&1; then
  echo "OpenSSH is already installed."
else
  echo "Installing OpenSSH."
  sudo apt update || { echo "Failed to update. Exiting..."; exit 2; }
  sudo apt install openssh-client -y && sudo apt install openssh-server -y || { echo "Failed to install openssh."; exit 3; }
fi

echo "Setting SSH firewall port allowance to $PORT_NUM..."
sudo ufw delete allow 22/tcp
sudo ufw allow $PORT_NUM/tcp
sudo systemctl restart ssh

Echo "Operation complete."

exit 0

# EOF
