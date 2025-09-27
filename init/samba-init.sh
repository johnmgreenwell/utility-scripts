#!/bin/bash
# Install samba server and prepare its configuration and auto-start
# to a directory called 'shared/' in MOUNT_DIRECTORY
# Usage: ./samba-init.sh [USERNAME] [MOUNT_DIRECTORY] <DEVICE_FILE>
USER="${1:-pi}"
MOUNT="${2:-/mnt/hdd1}"
DEVICE="$3"

if which samba >/dev/null 2>&1; then
  echo "Samba is already installed."
  exit 0
else
  echo "Installing samba."
  sudo apt install samba -y || { echo "Failed to install samba"; exit 1; }
fi

sudo mkdir -p "$MOUNT/shared"
echo "Updating smb.conf file with custom settings..."
read -r -d '' SETUP << EOM
# Place custom server details here
# https://ubuntu.com/tutorials/install-and-configure-samba#3-setting-up-samba
EOM
echo "$SETUP" | sudo tee -a /etc/samba/smb.conf > /dev/null

if [ -n "$DEVICE" ]; then
  echo "Adding auto-mount on start..."
  if [ ! -f /etc/rc.local ]; then
    echo "#!/bin/bash" | sudo tee /etc/rc.local > /dev/null
    sudo chmod +x /etc/rc.local
  fi
  echo "sudo mount \"$DEVICE\" \"$MOUNT\"" | sudo tee -a /etc/rc.local > /dev/null
  # Mount the drive
  sudo mount "$DEVICE" "$MOUNT"
fi

# Setup a user/password to access the samba share
sudo smbpasswd -a "$USER"

# Start the server
sudo systemctl restart smbd.service nmbd.service
exit 0

# EOF
