#!/bin/bash
# Return the remaining disk space for root partition in bytes
# Usage: disk-space.sh

if command -v df >/dev/null 2>&1; then
  echo $(df --output=avail / | tail -n 1)
else
  echo "Command 'df' not found."
  exit 1
fi

exit 0

# EOF