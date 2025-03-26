#!/bin/bash
# Check if the primary network is up or down

ip route | grep -q "default" && echo "UP" || echo "DOWN"

# EOF