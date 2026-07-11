#!/bin/bash
# Check internet connectivity and display status
# Usage: internet-check.sh

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
TARGET="8.8.8.8"
RED_TEXT="\e[31m"
GRN_TEXT="\e[32m"

if command -v ping >/dev/null 2>&1; then
  ping -q -c 1 -W 1 $TARGET > /dev/null 2>&1 && STATUS="Online" && COLOR=$GRN_TEXT || STATUS="Offline" && COLOR=$RED_TEXT
  echo -e "[$TIMESTAMP] Network Status: ${COLOR}${STATUS}\e[0m"
  [ "$STATUS" = "Online" ] || exit 1
else
  echo "Command 'ping' not found."
  exit 2
fi

exit 0