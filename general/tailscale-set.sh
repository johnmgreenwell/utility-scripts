#!/bin/bash
# Starts or stops the tailscale service
# Usage: tailscale [start|stop|status]

[ $# -eq 0 ] && { echo "Usage: $0 {start|stop|status}"; exit 1; }
[ $(id -u) -ne 0 ] && { echo "This script requires admin privileges."; exit 2; }
command -v systemctl >/dev/null 2>&1 || { echo "Command 'systemctl' not found."; exit 3; }
systemctl cat tailscaled &>/dev/null || { echo "Service 'tailscaled' not found."; exit 4; }

if [[ $1 == "start" ]]; then
  sudo systemctl start tailscaled
elif [[ $1 == "stop" ]]; then
  sudo systemctl stop tailscaled
elif [[ $1 == "status" ]]
  STATUS=$(systemctl is-active tailscaled)
  if [ "$STATUS" = "active" ]; then
    TIMESTAMP=$(systemctl show tailscaled --property=ActiveEnterTimestamp --value)
  else
    TIMESTAMP=$(systemctl show tailscaled --property=InactiveEnterTimestamp --value)
  fi
  echo "Tailscale: $STATUS since $TIMESTAMP."
else
  echo "Invalid argument."
  exit 4
fi

exit 0

# EOF
