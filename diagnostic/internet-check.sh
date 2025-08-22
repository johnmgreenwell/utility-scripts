#!/bin/bash
# Check if internet connectivity is up or down
# Usage: internet-check.sh

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
TARGET="8.8.8.8"

command -v ping >/dev/null 2>&1 || { echo "Command 'ping' not found."; exit 2; }
ping -q -c 1 -W 1 $TARGET > /dev/null 2>&1 && STATUS="Online" || STATUS="Offline"
echo "[$TIMESTAMP] Network Status: $STATUS"
[ "$STATUS" = "Online" ] && exit 0 || exit 1

# EOF
