#!/bin/bash
# Return a string of the current time UTC
# Usage: time-get.sh

echo "$(date -u +"%Y-%m-%d %H:%M:%S UTC")"

# EOF