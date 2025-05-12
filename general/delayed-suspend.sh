#!/bin/bash
# Suspend the machine after a set number of minutes
# Usage: delayed-suspend.sh [MINUTES]

[[ -z "$1" || ! "$1" =~ ^[0-9]+$ ]] && { echo "Usage: $0 <minutes>"; exit 1; }

SECONDS=$(( $1 * 60 ))
sleep "$SECONDS"
systemctl suspend

# EOF
