#!/bin/bash
# Install smba server and prepare its configuration and auto-start

if which samba >/dev/null 2>&2; then
  echo "Samba is already installed."
  exit 0
else
  echo "Installing samba."
  sudo apt install samba -y
fi

sudo mkdir -p /mnt/hdd1/shared

echo "Updating smb.conf file with custom settings..."
sudo cat >> /etc/samba/smb.conf <<- EOM
# Place custom server details here
# https://ubuntu.com/tutorials/install-and-configure-samba#3-setting-up-samba
EOM

# Custom device and mount location here
STARTUP="sudo mount /dev/sda1 /mnt/hdd1"

echo "Adding auto-mount on start..."
if [ ! -f /etc/rc.local ]; then
  sudo echo "#!/bin/bash" > /etc/rc.local
  sudo chmod +x /etc/rc.local
fi

sudo echo "$STARTUP" >> /etc/rc.local
eval "$STARTUP"

sudo systemctl restart smbd.service nmbd.service

exit 0

# EOF
