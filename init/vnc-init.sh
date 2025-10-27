#!/bin/bash
# Install and prepare VNC configuration and auto-start
# The input username is optional, and is used for the systemd unit
# Usage: vnc-init.sh <USERNAME>

USERNAME=${1:-"root"}

[ $(id -u) -ne 0 ] && { echo "This script requires admin privileges."; exit 1; }

if which tigervncserver >/dev/null 2>&1; then
  echo "VNC server is already installed."
  exit 0
else
  echo "Installing VNC server."
  sudo apt update || { echo "Failed to update. Exiting..."; exit 1; }
  sudo apt install ubuntu-gnome-desktop -y || { echo "Failed to install ubuntu-gnome-desktop."; exit 1; }
  sudo apt install tigervnc-standalone-server -y || { echo "Failed to install tigervnc-standalone-server."; exit 1; }
fi

echo "Updating vncserver init.d file with custom settings."
cat > ~/.vnc/xstartup <<- EOM
#!/bin/bash
# Start Gnome Desktop 
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
vncconfig -iconic &
dbus-launch --exit-with-session gnome-session

EOM

read -r -d '' SERVICE << EOM
[Unit]
Description=Remote desktop service (VNC)
After=syslog.target network.target

[Service]
Type=simple
User=$USERNAME
PAMName=$USERNAME
PIDFile=/home/$USERNAME/.vnc/%H%i.pid
ExecStart=/usr/bin/tigervncserver -xstartup /usr/bin/gnome-session -geometry 1920x1080 -localhost no
ExecStop=/usr/bin/vncserver -kill :%i

[Install]
WantedBy=multi-user.target
EOM

echo "$SERVICE" | sudo tee '/etc/systemd/system/vncserver.service' > /dev/null

echo "Adding auto-mount on start..."
sudo systemctl enable vncserver.service
sudo systemctl daemon-reload 

echo "Performing initial launch for password entry..."
sudo tigervncserver -xstartup /usr/bin/gnome-session -geometry 1920x1080 -localhost no

exit 0

# EOF
