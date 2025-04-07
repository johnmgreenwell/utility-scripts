#!/bin/bash
# Return a set of strings representing simple system state
# Usage: sys-state.sh

echo "=== System Uptime ==="; uptime
echo "=== Memory Usage ==="; free -h
echo "=== Disk Usage ==="; df -h /
echo "=== Top 5 CPU Processes ==="; ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6

# EOF