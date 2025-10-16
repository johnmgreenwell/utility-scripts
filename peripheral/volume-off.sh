#!/bin/bash
# Mute audio volume
# Usage: volume-off.sh

command -v amixer >/dev/null 2>&1 || { echo "Command 'amixer' not found."; exit 1; }
amixer -D pulse sset Master mute

exit 0

# EOF
