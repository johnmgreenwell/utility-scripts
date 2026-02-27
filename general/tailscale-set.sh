#!/bin/bash
# Starts or stops the tailscale service
# Usage: tailscale [start|stop|status]

[ $# -eq 0 ] && { echo "Usage: $0 {start|stop|status}"; exit 1; }
[ $(id -u) -ne 0 ] && { echo "This script requires admin privileges."; exit 2; }
command -v systemctl >/dev/null 2>&1 || { echo "Command 'systemctl' not found."; exit 3; }
systemctl cat tailscaled &>/dev/null || { echo "Service 'tailscaled' not found."; exit 4; }

case "$1" in
  start)
    sudo systemctl start tailscaled
    ;;
  stop)
    sudo systemctl stop tailscaled
    ;;
  status)
    STATUS=$(systemctl is-active tailscaled 2>/dev/null || echo "unknown")
    if [ "$STATUS" = "active" ]; then
      TIMESTAMP=$(systemctl show tailscaled --property=ActiveEnterTimestamp --value)
    else
      TIMESTAMP=$(systemctl show tailscaled --property=InactiveEnterTimestamp --value)
    fi
    echo "Tailscale: $STATUS since $TIMESTAMP."
    ;;
  *)
    echo "Invalid command: $1"
    echo "Usage: $0 {start|stop|status}"
    exit 5
    ;;
esac

exit 0

# EOF
