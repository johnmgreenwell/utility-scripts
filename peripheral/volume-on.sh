#!/bin/bash
# Unmute audio volume
# Usage: volume-on.sh

command -v amixer >/dev/null 2>&1 || { echo "Command 'amixer' not found."; exit 1; }
amixer -D pulse sset Master unmute

exit 0

# EOF
