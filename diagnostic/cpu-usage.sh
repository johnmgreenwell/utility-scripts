#!/bin/bash
# Return the current CPU usage percentage
# Usage: cpu-usage.sh

echo $(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

# EOF