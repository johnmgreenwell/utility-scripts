#!/bin/bash
# Install and prepare VNC configuration and auto-start
# Usage: vnc-init.sh

if which tigervncserver >/dev/null 2>&1; then
  echo "VNC server is already installed."
  exit 0
else
  echo "Installing VNC server."
  sudo apt install ubuntu-gnome-desktop -y
  sudo apt install tigervnc-standalone-server -y
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
User=jgreenw
PAMName=jgreenw
PIDFile=/home/jgreenw/.vnc/%H%i.pid
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
