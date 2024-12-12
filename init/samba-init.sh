#!/bin/bash
# Install smba server and prepare its configuration and auto-start
# to a directory called 'shared/' in MOUNT_DIRECTORY
# Usage: ./samba-init.sh <DEVICE_FILE> <MOUNT_DIRECTORY> <USERNAME>

DEVICE=${1:-"/dev/sda1"}
MOUNT=${2:-"/mnt/hdd1"}
USER=${3:-"pi"}

if which samba >/dev/null 2>&2; then
  echo "Samba is already installed."
  exit 0
else
  echo "Installing samba."
  sudo apt install samba -y
fi

sudo mkdir -p $MOUNT/shared

echo "Updating smb.conf file with custom settings..."
read -r -d '' SETUP << EOM
# Place custom server details here
# https://ubuntu.com/tutorials/install-and-configure-samba#3-setting-up-samba
EOM
echo "$SETUP" | sudo tee -a '/etc/samba/smb.conf' > /dev/null

# Custom device and mount string as array
STARTUP=(sudo mount "$DEVICE" "$MOUNT")

echo "Adding auto-mount on start..."
if [ ! -f /etc/rc.local ]; then
  echo "#!/bin/bash" | sudo tee '/etc/rc.local' > '/dev/null'
  sudo chmod +x /etc/rc.local
fi
echo "${STARTUP[@]}" | sudo tee -a '/etc/rc.local' > '/dev/null'

# Setup a user/password to access the samba share
sudo smbpasswd -a $USER

# Mount the drive and start the server
"${STARTUP[@]}"
sudo systemctl restart smbd.service nmbd.service

exit 0

# EOF
