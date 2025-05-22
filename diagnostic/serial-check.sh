#!/bin/bash
# Scan for attached serial devices
# Usage: serial-check.sh

#!/bin/bash

echo "Scanning for serial devices..."

devices=$(ls /dev/ttyUSB* /dev/ttyACM* /dev/ttyS* 2>/dev/null)

if [[ -z "$devices" ]]; then
    echo "No serial devices found."
else
    echo "Found serial devices:"
    for dev in $devices; do
        echo "  $dev"
    done
fi

if [ -d /dev/serial/by-id ]; then
    echo ""
    echo "Descriptive device names (from /dev/serial/by-id):"
    for link in /dev/serial/by-id/*; do
        [ -e "$link" ] && echo "  $link -> $(readlink -f "$link")"
    done
fi

# EOF
