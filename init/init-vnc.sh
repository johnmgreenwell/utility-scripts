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

#!/bin/sh
# Start Gnome Desktop 
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
vncconfig -iconic &
dbus-launch --exit-with-session gnome-session

EOM

tigervncserver -xstartup /usr/bin/gnome-session -localhost no

exit 0

# EOF
