#!/bin/bash
# Install openssh clinet and server and allow it through the firewall
# Usage: ssh-init.sh

[ $(id -u) -ne 0 ] && { echo "This script requires admin privileges."; exit 1; }

if which ssh >/dev/null 2>&1; then
  echo "OpenSSH is already installed."
else
  echo "Installing OpenSSH."
  sudo apt update || { echo "Failed to update. Exiting..."; exit 1; }
  sudo apt install openssh-client -y && sudo apt install openssh-server -y || { echo "Failed to install openssh."; exit 1; }
fi

sudo ufw allow ssh
sudo ufw allow 1022/tcp comment 'Open port ssh TCP/1022 as failsafe for upgrades.'
sudo systemctl restart ssh

exit 0

# EOF
