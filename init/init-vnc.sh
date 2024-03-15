#!/bin/bash
# Install and prepare VNC 

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

STARTUP="tigervncserver -xstartup /usr/bin/gnome-session -geometry 1920x1080 -localhost no"

echo "Adding auto-mount on start..."
if [ ! -f /etc/rc.local ]; then
  sudo echo "#!/bin/bash" > /etc/rc.local
  sudo chmod +x /etc/rc.local
else
  sudo echo $STARTUP >> /etc/rc.local
fi

eval $STARTUP

exit 0

# EOF
