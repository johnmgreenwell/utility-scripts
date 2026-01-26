#!/bin/bash
# Starts or stops the tailscale service
# Usage: tailscale [start|stop]

[ $(id -u) -ne 0 ] && { echo "This script requires admin privileges."; exit 1; }
command -v systemctl >/dev/null 2>&1 || { echo "Command 'systemctl' not found."; exit 2; }
systemctl cat tailscaled &>/dev/null || { echo "Service 'tailscaled' not found."; exit 3; }

if [[ -n $1 ]]; then
  if [[ $1 == "start" ]]; then
    sudo systemctl start tailscaled
  elif [[ $1 == "stop" ]]; then
    sudo systemctl stop tailscaled
  else
    echo "Invalid argument."
    exit 4
  fi
else
  echo "No argument provided."
  echo "Usage: $0 [start|stop]"
  exit 5
fi

# EOF
