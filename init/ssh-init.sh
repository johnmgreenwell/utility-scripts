#!/bin/bash
# Install openssh server and let it through the firewall

if which ssh >/dev/null 2>&2; then
  echo "OpenSSH is already installed."
else
  echo "Installing OpenSSH."
  sudo apt install openssh-server -y
fi

sudo ufw allow ssh
sudo systemctl restart ssh

exit 0

# EOF
