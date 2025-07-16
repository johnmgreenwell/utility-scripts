#!/bin/bash
# Shutdown the machine after a set number of minutes
# Usage: delayed-shutdown.sh [MINUTES]

if [ "$EUID" -ne 0 ]; then
    echo "This script requires root privileges to access some udev rules."
    echo "Please run with sudo or as root."
    exit 1
fi

[[ -z "$1" || ! "$1" =~ ^[0-9]+$ ]] && { echo "Usage: $0 <minutes>"; exit 1; }

MINUTES=$1
echo "System will shut down in $MINUTES minute(s)..."
sudo shutdown -h +$MINUTES

# EOF