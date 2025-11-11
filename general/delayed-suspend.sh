#!/bin/bash
# Suspend the machine after a set number of minutes
# Usage: delayed-suspend.sh [MINUTES]

[ $(id -u) -ne 0 ] && { echo "This script requires admin privileges."; exit 1; }

[[ -z "$1" || ! "$1" =~ ^[0-9]+$ ]] && { echo "Usage: $0 <minutes>"; exit 1; }

SECONDS=$(( $1 * 60 ))
sleep "$SECONDS"
sudo systemctl suspend

# EOF
