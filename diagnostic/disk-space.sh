#!/bin/bash
# Check the remaining disk space for root partition in bytes
# Usage: disk-space.sh

echo $(df --output=avail / | tail -n 1)

# EOF