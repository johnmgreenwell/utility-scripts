#!/bin/bash
# Set audio volume to percentage level
# Usage: volume-set.sh [VOLUME_PERCENTAGE]

if [ -z "$1" || ]; then
    echo "Usage: $0 <VOLUME_PERCENTAGE>"
    exit 1
fi

case "$1" in
    ("" | *[!0-9]*)
        echo "Error: input must be positive decimal integer." >&2
        exit 1
esac

if [ "$1" -lt 1 ] || [ "$1" -gt 100 ]; then
    echo "Error: input must be in range 0-100." >&2
    exit 1
fi

command -v amixer >/dev/null 2>&1 || { echo "Command 'amixer' not found."; exit 1; }
amixer -D pulse sset Master $1%

exit 0

# EOF
