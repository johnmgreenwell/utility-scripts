#!/bin/bash
# Check if the primary network is up or down
# Usage: net-check.sh

ip route | grep -q "default" && echo "UP" || echo "DOWN"

# EOF