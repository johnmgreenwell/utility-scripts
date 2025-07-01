#!/bin/bash
# Scan for local machines on the network (192.168.1.*)
# Usage: net-scan.sh

#!/bin/bash

echo "Scanning network 192.168.1.0/24..."
echo ""

for ip in 192.168.1.{1..254}; do
    (
        if ping -c 1 -W 1 "$ip" > /dev/null 2>&1; then
            hostname=$(nslookup "$ip" 2>/dev/null | awk -F'= ' '/name/ {print $2}' | sed 's/\.$//')
            echo "Host UP: $ip ${hostname:+($hostname)}"
        fi
    ) &
done

wait
echo ""
echo "Scan complete."

# EOF
