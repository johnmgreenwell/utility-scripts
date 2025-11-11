#!/bin/bash
# Shutdown the machine after a set number of minutes
# Usage: delayed-shutdown.sh [MINUTES]

[ $(id -u) -ne 0 ] && { echo "This script requires admin privileges."; exit 1; }

[[ -z "$1" || ! "$1" =~ ^[0-9]+$ ]] && { echo "Usage: $0 <minutes>"; exit 1; }

MINUTES=$1
echo "System will shut down in $MINUTES minute(s)..."
sudo shutdown -h +$MINUTES

# EOF