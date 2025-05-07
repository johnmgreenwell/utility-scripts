#!/bin/bash
# Shutdown the machine after a set number of minutes
# Usage: delayed-shutdown.sh [MINUTES]

[ -z "$1" ] && { echo "Usage: $0 <minutes>"; exit 1; }

MINUTES=$1

echo "System will shut down in $MINUTES minute(s)..."
sudo shutdown -h +$MINUTES

# EOF