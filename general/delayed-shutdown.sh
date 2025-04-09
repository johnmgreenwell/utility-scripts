#!/bin/bash
# Shutdown the machine after a set number of minutes
# Usage: delayed-shutdown.sh [MINUTES]

if [ -z "$1" ]; then
    echo "Usage: $0 <minutes>"
    exit 1
fi

MINUTES=$1

echo "System will shut down in $MINUTES minute(s)..."
sudo shutdown -h +$MINUTES

# EOF