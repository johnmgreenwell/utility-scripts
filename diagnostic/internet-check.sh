#!/bin/bash
# Check internet connectivity and display status
# Usage: internet-check.sh

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
TARGET="8.8.8.8"

if command -v ping >/dev/null 2>&1; then
  ping -q -c 1 -W 1 $TARGET > /dev/null 2>&1 && STATUS="Online" && COLOR="\e[32m" || STATUS="Offline" && COLOR="\e[31m"
  echo -e "[$TIMESTAMP] Network Status: ${COLOR}${STATUS}\e[0m"
  [ "$STATUS" = "Online" ] || exit 1
else
  echo "Command 'ping' not found."
  exit 2
fi

exit 0