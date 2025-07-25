#!/bin/bash
# Starts or stops the tailscale service
# Usage: tailscale [start|stop]

if [[ -n $1 ]]; then
  if [[ $1 == "start" ]]; then
    sudo systemctl start tailscaled
  elif [[ $1 == "stop" ]]; then
    sudo systemctl stop tailscaled
  else
    echo "Invalid argument."
    exit 1
  fi
else
  echo "No argument provided."
  echo "Usage: $0 [start|stop]"
  exit 1
fi

# EOF
