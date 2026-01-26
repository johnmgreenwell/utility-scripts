#!/bin/bash
# Return the current CPU usage percentage
# Usage: cpu-usage.sh

command -v mpstat >/dev/null 2>&1 && { mpstat 1 1 | awk '/Average/ {print 100 - $NF}'; exit 0; }
echo $(top -bn2 | grep "Cpu(s)" | tail -1 | awk '{print 100 - $8}')

exit 0

# EOF