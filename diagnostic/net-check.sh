#!/bin/bash
# Check if the primary network is up or down, exits 0 for network up
# Usage: net-check.sh

command -v ip >/dev/null 2>&1 || { echo "Command 'ip' not found."; exit 2; }
ip route | grep -q "default" && { echo "Network: UP."; } || { echo "Network: DOWN"; exit 1; }
ping -q -c 1 -W 1 8.8.8.8 >/dev/null && echo "Internet: UP." || echo "Internet: DOWN"

exit 0

# EOF
