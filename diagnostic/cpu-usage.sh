#!/bin/bash
# Return the current CPU usage percentage
# Usage: cpu-usage.sh

if command -v mpstat >/dev/null 2>&1; then
  mpstat 1 1 | awk '/Average/ {print 100 - $NF}';
elif command -v top >/dev/null 2>&1; then
  echo $(top -bn2 | grep "Cpu(s)" | tail -1 | awk '{print 100 - $8}')
else
  echo "Neither commands 'mpstat' nor 'df' found."
  exit 1
fi

exit 0

# EOF