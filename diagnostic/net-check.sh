#!/bin/bash
# Check if the primary network is up or down
# Usage: net-check.sh

ip route | grep -q "default" && { echo "UP"; exit 0; } || { echo "DOWN"; exit 1; }

# EOF