#!/bin/bash
# Check if internet connectivity is up or down
# Usage: internet-check.sh

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
TARGET="8.8.8.8" # Google's DNS server

ping -c 4 $TARGET > /dev/null 2>&1 && STATUS="Online" || STATUS="Offline"
echo "[$TIMESTAMP] Network Status: $STATUS"
[ "$STATUS" = "Online" ] && exit 0 || exit 1

# EOF
