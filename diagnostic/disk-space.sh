#!/bin/bash
# Return the remaining disk space for root partition in bytes
# Usage: disk-space.sh

command -v df >/dev/null 2>&1 || { echo "Command 'df' not found."; exit 1; }
echo $(df --output=avail / | tail -n 1)

# EOF