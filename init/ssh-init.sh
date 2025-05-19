#!/bin/bash
# Install openssh clinet and server and allow it through the firewall
# Usage: ssh-init.sh

if which ssh >/dev/null 2>&2; then
  echo "OpenSSH is already installed."
else
  echo "Installing OpenSSH."
  sudo apt update
  sudo apt install openssh-client -y && sudo apt install openssh-server -y
fi

sudo ufw allow ssh
sudo ufw allow 1022/tcp comment 'Open port ssh TCP/1022 as failsafe for upgrades'
sudo systemctl restart ssh

exit 0

# EOF
