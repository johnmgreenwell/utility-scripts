#!/bin/bash
# Check if a service is active and restart it if it is not
# Given no arguments, will list all active systemd services that are running
# Usage: task-check.sh <SERVICE_NAME>

[ $(id -u) -ne 0 ] && { echo "This script requires admin privileges."; exit 1; }
type systemctl &> /dev/null || { echo "Error: systemctl not found. This script requires systemd."; exit 2; }

if [ -z "$1" ]; then
    total=$(systemctl list-units --type=service --state=running --no-pager | grep -c '.service')
    echo "Currently active and running systemd services:"
    echo "----------------------------------------"
    systemctl list-units --type=service --state=running --no-pager | awk '{print $1, $4}' | column -t
    echo -e "\nTotal running services: $total"
else
    SERVICE="$1"
    if ! systemctl is-active --quiet "$SERVICE"; then
        echo "$(date): $SERVICE is not running. Restarting..." | tee -a "/var/log/service_monitor.log"
        systemctl restart "$SERVICE"

        if systemctl is-active --quiet "$SERVICE"; then
            echo "$(date): Successfully restarted $SERVICE" | tee -a "/var/log/service_monitor.log"
        else
            echo "$(date): Failed to restart $SERVICE" | tee -a "/var/log/service_monitor.log"
        fi
    else
        echo "$(date): $SERVICE is running." | tee -a "/var/log/service_monitor.log"
    fi
fi

exit 0

# EOF

