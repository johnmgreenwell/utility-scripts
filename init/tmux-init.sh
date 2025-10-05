#!/bin/bash
# Install tmux and prepare tmux conf file
# Usage: tmux-init.sh

if ! which git >/dev/null 2>&1; then
  echo "Installing git."
  sudo apt install git -y || { echo "Failed to install git."; exit 1; }
fi

if which tmux >/dev/null 2>&1; then
  echo "Tmux is already installed."
  exit 0
else
  echo "Installing tmux."
  sudo apt update || { echo "Failed to update. Exiting..."; exit 1; }
  sudo apt install tmux -y || { echo "Failed to install tmux."; exit 1; }
fi

echo "Updating tmux.conf file with custom settings."
cat > ~/.tmux.conf <<- EOM

# remap prefix
set -g prefix C-a
bind C-a send-prefix

# vim-like pane resizing
bind -r C-k resize-pane -U
bind -r C-j resize-pane -D
bind -r C-h resize-pane -L
bind -r C-l resize-pane -R

# vim-like pane switching
bind -r k select-pane -U
bind -r j select-pane -D
bind -r h select-pane -L
bind -r l select-pane -R

# and now unbind keys
unbind Up
unbind Down
unbind Left
unbind Right

unbind C-Up
unbind C-Down
unbind C-Left
unbind C-Right

EOM

exit 0

# EOF
