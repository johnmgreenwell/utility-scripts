#!/bin/bash
# Return the current memory usage percentage
# Usage: mem-usage.sh

echo $(free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }')

# EOF