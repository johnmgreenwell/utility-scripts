#!/bin/bash
# Setup ufw firewall for various services and ports
# Usage: ufw-init.sh [SSH_PORT_NUM] [RDP_PORT_NUM]

SSH_PORT_NUM=$1
RDP_PORT_NUM=$2
SSH_CONFIG_FILE="/etc/ssh/sshd_config"
RDP_CONFIG_FILE="/etc/xrdp/xrdp.ini"

[ $(id -u) -ne 0 ] && { echo "This script requires admin privileges."; exit 1; }
[[ -z $SSH_PORT_NUM ]] && { echo "No SSH port number provided. Exiting..."; exit 2; }
[[ -z $RDP_PORT_NUM ]] && { echo "No RDP port number provided. Exiting..."; exit 3; }
[[ ! -f "$SSH_CONFIG_FILE" ]] && { echo "SSH config file \"$SSH_CONFIG_FILE\" not found. Exiting..."; exit 4; }
[[ ! -f "$RDP_CONFIG_FILE" ]] && { echo "RDP config file \"$RDP_CONFIG_FILE\" not found. Exiting..."; exit 5; }

# Remove any SSH port assignments in SSH config file, then add desired target port
if grep -q "^Port " "$SSH_CONFIG_FILE"; then
  # If active port, remove it and place new port in its place
  sed -i "s/^Port .*/Port $SSH_PORT_NUM/" "$SSH_CONFIG_FILE"
elif grep -q "^#Port " "$SSH_CONFIG_FILE"; then
  # If inactive/default port, do not remove it but place new port alongside it
  sed -i "/^#Port /a Port $SSH_PORT_NUM" "$SSH_CONFIG_FILE"
else
  # If no port defined or commented, simply append to end of file
  echo "Port $SSH_PORT_NUM" >> "$SSH_CONFIG_FILE"
fi

# Perform simple line replacement to update xrdp config file
sed -i.bak "s/^port=.*/port=$RDP_PORT_NUM/" "$RDP_CONFIG_FILE"

# Set firewall rules
echo "Setting SSH firewall port allowance to $SSH_PORT_NUM..."
sudo ufw delete allow 22/tcp
sudo ufw allow $SSH_PORT_NUM/tcp
echo "Setting RDP firewall port allowance to $RDP_PORT_NUM..."
sudo ufw delete allow 3389/tcp
sudo ufw allow $RDP_PORT_NUM/tcp
sudo ufw reload

echo "Operation completed. It may be necessary to restart the ssh/rdp services."

exit 0

# EOF
